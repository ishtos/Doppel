import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doppel/shared/widgets/app_stat_tile.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    home: Scaffold(body: Center(child: child)),
  );

  testWidgets('renders icon, value and label (card variant is default)', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const AppStatTile(icon: Icons.timer, value: '12.5時間', label: '累計練習'),
      ),
    );

    expect(find.text('12.5時間'), findsOneWidget);
    expect(find.text('累計練習'), findsOneWidget);
    expect(find.byIcon(Icons.timer), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
  });

  testWidgets('compact variant uses a fixed-size container, not a Card', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const AppStatTile(
          variant: StatTileVariant.compact,
          icon: Icons.mic,
          value: '3回',
          label: '今週',
        ),
      ),
    );

    expect(find.text('3回'), findsOneWidget);
    expect(find.byType(Card), findsNothing);
  });
}
