import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:doppel/shared/services/stable_id.dart';

// Exercises the secure-storage branches of StableId with a mocked Keychain
// (flutter_secure_storage's method channel), which the plain fallback test in
// stable_id_test.dart can't reach.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel =
      MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
  late Map<String, String> keychain;

  setUp(() {
    keychain = {};
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      final args = Map<String, dynamic>.from(call.arguments as Map);
      final key = args['key'] as String?;
      switch (call.method) {
        case 'read':
          return keychain[key];
        case 'write':
          keychain[key!] = args['value'] as String;
          return null;
        case 'delete':
          keychain.remove(key);
          return null;
        case 'containsKey':
          return keychain.containsKey(key);
        case 'readAll':
          return Map<String, String>.from(keychain);
        case 'deleteAll':
          keychain.clear();
          return null;
        default:
          return null;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('prefers the Keychain token even when prefs is empty', () async {
    keychain[StableId.key] = 'keychain-tok';
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    final id = await StableId().resolve(prefs);

    expect(id, 'keychain-tok');
    expect(prefs.getString(StableId.key), 'keychain-tok',
        reason: 'mirrored into prefs for sync readers');
  });

  test('migrates a legacy prefs-only token up into the Keychain', () async {
    SharedPreferences.setMockInitialValues({StableId.key: 'legacy-tok'});
    final prefs = await SharedPreferences.getInstance();

    final id = await StableId().resolve(prefs);

    expect(id, 'legacy-tok');
    expect(keychain[StableId.key], 'legacy-tok');
  });

  test('generates and persists to both stores on first run', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    final id = await StableId().resolve(prefs);

    expect(id, isNotEmpty);
    expect(keychain[StableId.key], id);
    expect(prefs.getString(StableId.key), id);
  });
}
