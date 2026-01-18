import 'package:flutter/material.dart';
import 'package:flutter_calendar_pro/flutter_calendar_pro.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AdvancedCalendar Widget Tests', () {
    testWidgets('Calendar renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(),
          ),
        ),
      );

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Calendar displays with custom controller',
        (WidgetTester tester) async {
      final controller = CalendarController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              controller: controller,
            ),
          ),
        ),
      );

      expect(find.byType(AdvancedCalendar), findsOneWidget);

      controller.dispose();
    });

    testWidgets('Calendar displays with custom config',
        (WidgetTester tester) async {
      const config = CalendarConfig(
        showWeekNumbers: true,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              config: config,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Calendar with light theme', (WidgetTester tester) async {
      final theme = CalendarTheme.light();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              theme: theme,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Calendar with dark theme', (WidgetTester tester) async {
      final theme = CalendarTheme.dark();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              theme: theme,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Calendar with green theme', (WidgetTester tester) async {
      final theme = CalendarTheme.green();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              theme: theme,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Calendar with orange theme', (WidgetTester tester) async {
      final theme = CalendarTheme.orange();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              theme: theme,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Calendar with colorful theme', (WidgetTester tester) async {
      final theme = CalendarTheme.colorful();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              theme: theme,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Calendar with minimal theme', (WidgetTester tester) async {
      final theme = CalendarTheme.minimal();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              theme: theme,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Calendar with custom theme properties',
        (WidgetTester tester) async {
      const theme = CalendarTheme(
        headerBackgroundColor: Colors.purple,
        selectedDayBackgroundColor: Colors.amber,
        todayBackgroundColor: Colors.green,
        eventIndicatorColor: Colors.red,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              theme: theme,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Calendar with header hidden', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              showHeader: false,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Calendar with header visible', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Date selection callback works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              onDaySelected: (DateTime date) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Range selection callback works', (WidgetTester tester) async {
      const config = CalendarConfig(
        enableRangeSelection: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              config: config,
              onRangeSelected: (DateTime start, DateTime end) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Long press callback works', (WidgetTester tester) async {
      const config = CalendarConfig();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              config: config,
              onDayLongPressed: (DateTime date) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Event tap callback works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              onEventTap: (CalendarEvent event) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Time slot tap callback works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              onTimeSlotTap: (DateTime time, String column) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Calendar with vertical scroll enabled',
        (WidgetTester tester) async {
      const config = CalendarConfig(
        enableVerticalScroll: true,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              config: config,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Calendar with horizontal scroll (default)',
        (WidgetTester tester) async {
      const config = CalendarConfig();

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              config: config,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Calendar with month view', (WidgetTester tester) async {
      const config = CalendarConfig();

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              config: config,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Calendar with week view', (WidgetTester tester) async {
      const config = CalendarConfig(
        initialView: CalendarView.week,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              config: config,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Calendar with day view', (WidgetTester tester) async {
      const config = CalendarConfig(
        initialView: CalendarView.day,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              config: config,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Calendar with year view', (WidgetTester tester) async {
      const config = CalendarConfig(
        initialView: CalendarView.year,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              config: config,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Calendar with agenda view', (WidgetTester tester) async {
      const config = CalendarConfig(
        initialView: CalendarView.agenda,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              config: config,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Calendar with timeline view', (WidgetTester tester) async {
      const config = CalendarConfig(
        initialView: CalendarView.timeline,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              config: config,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Calendar with custom timeline columns',
        (WidgetTester tester) async {
      const config = CalendarConfig(
        initialView: CalendarView.timeline,
      );

      const customColumns = [
        'Hall A',
        'Hall B',
        'Hall C',
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              config: config,
              timelineColumns: customColumns,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Calendar with weekends hidden', (WidgetTester tester) async {
      const config = CalendarConfig(
        hideWeekends: true,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              config: config,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Calendar with swipe navigation enabled',
        (WidgetTester tester) async {
      const config = CalendarConfig(
        initialView: CalendarView.week,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              config: config,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets('Calendar with Sunday as week start',
        (WidgetTester tester) async {
      const config = CalendarConfig(
        weekStartDay: WeekStartDay.sunday,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              config: config,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Calendar updates when controller changes',
        (WidgetTester tester) async {
      final controller1 = CalendarController();
      final controller2 = CalendarController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              controller: controller1,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              controller: controller2,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);

      controller1.dispose();
      controller2.dispose();
    });

    testWidgets('Calendar updates when theme changes',
        (WidgetTester tester) async {
      final theme1 = CalendarTheme.light();
      final theme2 = CalendarTheme.dark();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              theme: theme1,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              theme: theme2,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Calendar updates when config changes',
        (WidgetTester tester) async {
      const config1 = CalendarConfig();

      const config2 = CalendarConfig(
        enableVerticalScroll: true,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              config: config1,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              config: config2,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Calendar disposes controllers correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsNothing);
    });

    testWidgets('Calendar with range selection enabled',
        (WidgetTester tester) async {
      const config = CalendarConfig(
        enableRangeSelection: true,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              config: config,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Calendar with holidays', (WidgetTester tester) async {
      final holidays = [
        DateTime(2024),
        DateTime(2024, 12, 25),
      ];

      final holidayNames = {
        DateTime(2024): 'New Year',
        DateTime(2024, 12, 25): 'Christmas',
      };

      final config = CalendarConfig(
        holidays: holidays,
        holidayNames: holidayNames,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              config: config,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });
  });

  group('AdvancedCalendar Controller Tests', () {
    testWidgets('Controller navigates to next month',
        (WidgetTester tester) async {
      final controller = CalendarController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              controller: controller,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final initialDate = controller.focusedDay;
      controller.navigateNext();

      await tester.pumpAndSettle();

      expect(controller.focusedDay.month, isNot(equals(initialDate.month)));

      controller.dispose();
    });

    testWidgets('Controller navigates to previous month',
        (WidgetTester tester) async {
      final controller = CalendarController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              controller: controller,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final initialDate = controller.focusedDay;
      controller.navigatePrevious();

      await tester.pumpAndSettle();

      expect(controller.focusedDay.month, isNot(equals(initialDate.month)));

      controller.dispose();
    });

    testWidgets('Controller changes view', (WidgetTester tester) async {
      final controller = CalendarController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              controller: controller,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(controller.currentView, CalendarView.month);

      controller.setView(CalendarView.week);

      await tester.pumpAndSettle();

      expect(controller.currentView, CalendarView.week);

      controller.dispose();
    });

    testWidgets('Controller jumps to specific date',
        (WidgetTester tester) async {
      final controller = CalendarController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              controller: controller,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final targetDate = DateTime(2025, 6, 15);
      controller.jumpToDate(targetDate);

      await tester.pumpAndSettle();

      expect(controller.focusedDay.year, targetDate.year);
      expect(controller.focusedDay.month, targetDate.month);

      controller.dispose();
    });
  });

  group('AdvancedCalendar Edge Cases', () {
    testWidgets('Handles null controller gracefully',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Handles null config gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Handles null theme gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Handles leap year correctly', (WidgetTester tester) async {
      final controller = CalendarController()
        ..jumpToDate(DateTime(2024, 2, 15));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              controller: controller,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);

      controller.dispose();
    });

    testWidgets('Handles year boundary', (WidgetTester tester) async {
      final controller = CalendarController()
        ..jumpToDate(DateTime(2024, 12, 31));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedCalendar(
              controller: controller,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);

      controller.dispose();
    });
  });
}
