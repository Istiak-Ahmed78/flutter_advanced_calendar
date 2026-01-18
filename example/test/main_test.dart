import 'package:example/features/01_month_view/a_basic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MonthViewBasic', () {
    testWidgets('builds and displays calendar', (WidgetTester tester) async {
      // Set fixed viewport size
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: MonthViewBasic(),
        ),
      );

      // Wait for layout to complete
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify widget builds
      expect(find.byType(MonthViewBasic), findsOneWidget);

      // Verify AppBar
      expect(find.text('Basic Month View'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);

      // Cleanup
      addTearDown(tester.view.reset);
    });

    testWidgets('displays calendar grid', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: MonthViewBasic(),
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify calendar displays day numbers
      expect(find.text('1'), findsWidgets);
      expect(find.text('15'), findsWidgets);

      addTearDown(tester.view.reset);
    });

    testWidgets('can tap on a day', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: MonthViewBasic(),
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find and tap day 15
      final dayFinder = find.text('15');

      if (dayFinder.evaluate().isNotEmpty) {
        await tester.tap(dayFinder.first);
        await tester.pumpAndSettle();

        // Verify no crash after tap
        expect(find.byType(MonthViewBasic), findsOneWidget);
      }

      addTearDown(tester.view.reset);
    });
  });
}
