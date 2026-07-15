import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Resolves the stable per-install token used for IAP entitlement and progress
/// backup.
///
/// Precedence:
///   1. Keychain / Android Keystore copy — survives an iOS reinstall, so
///      backed-up progress can be restored after delete + reinstall.
///   2. Legacy SharedPreferences value — migrated up into secure storage.
///   3. A freshly generated UUID.
///
/// A SharedPreferences mirror is always kept so existing synchronous readers
/// keep working. Never throws: if secure storage is unavailable (e.g. under
/// `flutter test`) it falls back to the prefs-only behaviour.
class StableId {
  StableId([FlutterSecureStorage? secureStorage])
      : _secure = secureStorage ?? const FlutterSecureStorage();

  static const key = 'app_account_token';

  final FlutterSecureStorage _secure;

  Future<String> resolve(SharedPreferences prefs) async {
    String? secure;
    try {
      secure = await _secure.read(key: key);
    } catch (_) {
      // Secure storage unavailable — fall through to prefs.
    }
    if (secure != null && secure.isNotEmpty) {
      if (prefs.getString(key) != secure) await prefs.setString(key, secure);
      return secure;
    }

    // Migrate a legacy prefs-only token into secure storage.
    final legacy = prefs.getString(key);
    if (legacy != null && legacy.isNotEmpty) {
      await _tryWrite(legacy);
      return legacy;
    }

    // First run: generate and persist to both stores.
    final token = const Uuid().v4();
    await _tryWrite(token);
    await prefs.setString(key, token);
    return token;
  }

  Future<void> _tryWrite(String value) async {
    try {
      await _secure.write(key: key, value: value);
    } catch (_) {
      // Best-effort — prefs mirror still holds the value.
    }
  }
}
