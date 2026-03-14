import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doppel/main.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: DoppelApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Doppel'), findsOneWidget);
    expect(find.text('ホーム'), findsOneWidget);
  });
}
