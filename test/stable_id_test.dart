import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:doppel/shared/services/stable_id.dart';

// Secure storage (Keychain) is unavailable under `flutter test`, so StableId
// must fall back to the SharedPreferences mirror without throwing.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('returns an existing prefs token (legacy migration path)', () async {
    SharedPreferences.setMockInitialValues({'app_account_token': 'existing-tok'});
    final prefs = await SharedPreferences.getInstance();
    expect(await StableId().resolve(prefs), 'existing-tok');
  });

  test('generates and persists a token on first run', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final id = await StableId().resolve(prefs);
    expect(id, isNotEmpty);
    expect(prefs.getString('app_account_token'), id);
  });

  test('is stable across repeated calls', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final a = await StableId().resolve(prefs);
    final b = await StableId().resolve(prefs);
    expect(a, b);
  });
}
