import 'package:doppel/shared/services/purchase_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

void main() {
  group('grantsPremium', () {
    test('grants premium for our product when purchased', () {
      expect(grantsPremium(PurchaseStatus.purchased, kPremiumProductId),
          isTrue);
    });

    test('grants premium for our product when restored', () {
      expect(
          grantsPremium(PurchaseStatus.restored, kPremiumProductId), isTrue);
    });

    test('does not grant for a different product id', () {
      expect(grantsPremium(PurchaseStatus.purchased, 'com.other.product'),
          isFalse);
    });

    test('does not grant for pending / error / canceled', () {
      expect(
          grantsPremium(PurchaseStatus.pending, kPremiumProductId), isFalse);
      expect(grantsPremium(PurchaseStatus.error, kPremiumProductId), isFalse);
      expect(grantsPremium(PurchaseStatus.canceled, kPremiumProductId),
          isFalse);
    });
  });
}
