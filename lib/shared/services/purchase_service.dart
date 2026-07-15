import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../features/settings/presentation/providers/settings_provider.dart';
import '../analytics/analytics_events.dart';
import '../analytics/analytics_provider.dart';
import 'iap_backend.dart';

/// Product id for the premium subscription. Must match the auto-renewable
/// subscription created in App Store Connect (and Google Play Console).
const kPremiumProductId = 'com.ishtos.doppel.premium.monthly';

/// Pure entitlement rule: a purchase grants premium when it is our product and
/// it was purchased or restored. Extracted so it is unit-testable without the
/// store / platform channels.
bool grantsPremium(PurchaseStatus status, String productId) =>
    productId == kPremiumProductId &&
    (status == PurchaseStatus.purchased ||
        status == PurchaseStatus.restored);

final purchaseControllerProvider =
    StateNotifierProvider<PurchaseController, PurchaseState>((ref) {
  InAppPurchase? iap;
  try {
    iap = InAppPurchase.instance;
  } catch (_) {
    // Platform/store unavailable (e.g. running under `flutter test`).
    iap = null;
  }
  return PurchaseController(ref, iap, ref.read(iapBackendClientProvider));
});

class PurchaseState {
  const PurchaseState({
    this.isStoreAvailable = false,
    this.product,
    this.purchasePending = false,
    this.errorMessage,
  });

  final bool isStoreAvailable;
  final ProductDetails? product;
  final bool purchasePending;
  final String? errorMessage;

  /// Localized price string (e.g. "¥480") once the product has loaded.
  String? get priceLabel => product?.price;

  PurchaseState copyWith({
    bool? isStoreAvailable,
    ProductDetails? product,
    bool? purchasePending,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PurchaseState(
      isStoreAvailable: isStoreAvailable ?? this.isStoreAvailable,
      product: product ?? this.product,
      purchasePending: purchasePending ?? this.purchasePending,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Drives Apple/Google in-app purchases for the premium subscription and keeps
/// [SettingsState.isPremium] in sync with the user's entitlement.
///
/// All platform access is guarded: if [_iap] is null (tests / unsupported
/// platform) or a channel throws, the controller stays in a safe "store
/// unavailable" state instead of crashing.
class PurchaseController extends StateNotifier<PurchaseState> {
  PurchaseController(this._ref, this._iap, this._backend)
      : super(const PurchaseState()) {
    final iap = _iap;
    if (iap == null) return;
    // Listen at construction so transactions delivered at launch (an
    // interrupted or restored purchase) are always processed.
    try {
      _sub = iap.purchaseStream.listen(_onPurchaseUpdates, onError: (_) {});
    } catch (_) {
      // Store unavailable — leave isStoreAvailable false.
    }
    _init();
  }

  final Ref _ref;
  final InAppPurchase? _iap;
  final IapBackendClient _backend;
  StreamSubscription<List<PurchaseDetails>>? _sub;

  Future<void> _init() async {
    final iap = _iap;
    if (iap == null) return;
    try {
      final available = await iap.isAvailable();
      if (!available) {
        state = state.copyWith(isStoreAvailable: false);
        return;
      }
      final resp = await iap.queryProductDetails({kPremiumProductId});
      state = state.copyWith(
        isStoreAvailable: true,
        product:
            resp.productDetails.isNotEmpty ? resp.productDetails.first : null,
      );
      await _syncEntitlement();
    } catch (_) {
      state = state.copyWith(isStoreAvailable: false);
    }
  }

  /// Sync premium from the server-side entitlement (best-effort). Only updates
  /// on a definite answer, so a network error never downgrades the user.
  Future<void> _syncEntitlement() async {
    final token = _ref.read(settingsProvider).appAccountToken;
    if (token.isEmpty || !_backend.isAvailable) return;
    final ent = await _backend.entitlement(appAccountToken: token);
    if (ent != null) {
      await _ref.read(settingsProvider.notifier).setPremium(ent.entitled);
    }
  }

  /// Begin purchasing the premium subscription.
  Future<void> buy() async {
    final iap = _iap;
    final product = state.product;
    if (iap == null || product == null) return;
    state = state.copyWith(purchasePending: true, clearError: true);
    final appAccountToken = _ref.read(settingsProvider).appAccountToken;
    await iap.buyNonConsumable(
      purchaseParam: PurchaseParam(
        productDetails: product,
        applicationUserName: appAccountToken.isEmpty ? null : appAccountToken,
      ),
    );
  }

  /// Restore a previously purchased subscription (e.g. after reinstall).
  Future<void> restore() async {
    final iap = _iap;
    if (iap == null) return;
    state = state.copyWith(clearError: true);
    await iap.restorePurchases();
  }

  Future<void> _onPurchaseUpdates(List<PurchaseDetails> purchases) async {
    final iap = _iap;
    if (iap == null) return;
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.pending) {
        state = state.copyWith(purchasePending: true);
      } else {
        if (purchase.status == PurchaseStatus.error) {
          state = state.copyWith(
            purchasePending: false,
            errorMessage:
                purchase.error?.message ?? '購入処理に失敗しました。もう一度お試しください。',
          );
        } else if (grantsPremium(purchase.status, purchase.productID)) {
          await _grantFromPurchase(purchase);
          state = state.copyWith(purchasePending: false, clearError: true);
        } else if (purchase.status == PurchaseStatus.canceled) {
          state = state.copyWith(purchasePending: false);
        }
        // Always finish a transaction the store asks us to complete.
        if (purchase.pendingCompletePurchase) {
          await iap.completePurchase(purchase);
        }
      }
    }
  }

  /// Grant premium for a purchased/restored transaction. Prefer the server's
  /// receipt verification; if the backend is unreachable, grant optimistically
  /// (the user paid) and let the next entitlement sync reconcile.
  Future<void> _grantFromPurchase(PurchaseDetails purchase) async {
    final token = _ref.read(settingsProvider).appAccountToken;
    final receipt = purchase.verificationData.serverVerificationData;
    IapEntitlement? ent;
    if (_backend.isAvailable && token.isNotEmpty && receipt.isNotEmpty) {
      ent = await _backend.verify(appAccountToken: token, receipt: receipt);
    }
    final entitled = ent?.entitled ?? true; // optimistic when backend is silent
    await _ref.read(settingsProvider.notifier).setPremium(entitled);

    _ref.read(analyticsProvider).capture(
      AnalyticsEvents.purchaseCompleted,
      properties: {
        'product_id': purchase.productID,
        'status': purchase.status.name,
        'backend_verified': ent != null,
      },
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
