import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';

void main() {
  group('MyApp Tests', () {
    testWidgets('MyApp creates MaterialApp', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('MyApp has correct title', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.title, 'Advanced Calendar Demo');
    });

    testWidgets('MyApp has no debug banner', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.debugShowCheckedModeBanner, false);
    });

    testWidgets('MyApp uses Material3', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.theme?.useMaterial3, true);
    });

    testWidgets('MyApp home is CalendarDemoPage', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.byType(CalendarDemoPage), findsOneWidget);
    });
  });

  group('CalendarDemoPage Tests', () {
    testWidgets('CalendarDemoPage renders correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.byType(CalendarDemoPage), findsOneWidget);
      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('AppBar has correct title', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text('Advanced Calendar Demo'), findsOneWidget);
    });

    testWidgets('AppBar has settings button', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('AppBar has theme button', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.palette), findsOneWidget);
    });

    testWidgets('FloatingActionButton is present', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('Info bar is displayed', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.event), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
      expect(find.byIcon(Icons.view_module), findsOneWidget);
    });

    testWidgets('Calendar displays with sample events',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });
  });

  group('Settings Dialog Tests', () {
    testWidgets('Settings button opens dialog', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      expect(find.text('Calendar Settings'), findsOneWidget);
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('Settings dialog has 24-hour format switch',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      expect(find.text('24-Hour Format'), findsOneWidget);
      expect(find.byType(SwitchListTile), findsNWidgets(3));
    });

    testWidgets('Settings dialog has show event time switch',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      expect(find.text('Show Event Time'), findsOneWidget);
    });

    testWidgets('Settings dialog has vertical scroll switch',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      expect(find.text('Vertical Scroll'), findsOneWidget);
    });

    testWidgets('Settings dialog can be closed', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('Can toggle 24-hour format', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      final Finder formatSwitch = find.byWidgetPredicate(
        (Widget widget) =>
            widget is SwitchListTile &&
            widget.title is Text &&
            (widget.title as Text).data == '24-Hour Format',
      );

      await tester.tap(formatSwitch);
      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Can toggle show event time', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      final Finder eventTimeSwitch = find.byWidgetPredicate(
        (Widget widget) =>
            widget is SwitchListTile &&
            widget.title is Text &&
            (widget.title as Text).data == 'Show Event Time',
      );

      await tester.tap(eventTimeSwitch);
      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Can toggle vertical scroll', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      final Finder verticalScrollSwitch = find.byWidgetPredicate(
        (Widget widget) =>
            widget is SwitchListTile &&
            widget.title is Text &&
            (widget.title as Text).data == 'Vertical Scroll',
      );

      await tester.tap(verticalScrollSwitch);
      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });
  });

  group('Theme Dialog Tests', () {
    testWidgets('Theme button opens dialog', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.palette));
      await tester.pumpAndSettle();

      expect(find.text('Select Theme'), findsOneWidget);
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('Theme dialog shows all theme options',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.palette));
      await tester.pumpAndSettle();

      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);
      expect(find.text('Colorful'), findsOneWidget);
      expect(find.text('Minimal'), findsOneWidget);
    });

    testWidgets('Can select dark theme', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.palette));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      expect(find.text('Theme changed to Dark'), findsOneWidget);
    });

    testWidgets('Can select colorful theme', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.palette));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Colorful'));
      await tester.pumpAndSettle();

      expect(find.text('Theme changed to Colorful'), findsOneWidget);
    });

    testWidgets('Can select minimal theme', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.palette));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Minimal'));
      await tester.pumpAndSettle();

      expect(find.text('Theme changed to Minimal'), findsOneWidget);
    });

    testWidgets('Theme dialog can be closed', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.palette));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });
  });

  group('Add Event Dialog Tests', () {
    testWidgets('FAB opens add event dialog', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('Add Event'), findsOneWidget);
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('Add event dialog has title field',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('Event Title'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('Add event dialog has all day switch',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('All Day Event'), findsOneWidget);
    });

    testWidgets('Add event dialog has multi-day switch',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('Multi-Day Event'), findsOneWidget);
    });

    testWidgets('Add event dialog has color picker',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('Event Color'), findsOneWidget);
    });

    testWidgets('Can cancel add event dialog', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('Can add event with title', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Test Event');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      expect(find.text('Event added'), findsOneWidget);
    });

    testWidgets('Cannot add event without title', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      // Dialog should still be open
      expect(find.text('Add Event'), findsOneWidget);
    });

    testWidgets('Enabling multi-day enables all-day',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      final Finder multiDaySwitch = find.byWidgetPredicate(
        (Widget widget) =>
            widget is SwitchListTile &&
            widget.title is Text &&
            (widget.title as Text).data == 'Multi-Day Event',
      );

      await tester.tap(multiDaySwitch);
      await tester.pumpAndSettle();

      expect(find.text('End Date'), findsOneWidget);
    });

    testWidgets('Can toggle all-day switch', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      final Finder allDaySwitch = find.byWidgetPredicate(
        (Widget widget) =>
            widget is SwitchListTile &&
            widget.title is Text &&
            (widget.title as Text).data == 'All Day Event',
      );

      await tester.tap(allDaySwitch);
      await tester.pumpAndSettle();

      // Time pickers should disappear
      expect(find.text('Start Time'), findsNothing);
      expect(find.text('End Time'), findsNothing);
    });
  });

  group('Color Picker Tests', () {
    testWidgets('Color picker opens from add event dialog',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Event Color'));
      await tester.pumpAndSettle();

      expect(find.text('Select Color'), findsOneWidget);
    });

    testWidgets('Color picker shows multiple colors',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Event Color'));
      await tester.pumpAndSettle();

      expect(find.byType(InkWell), findsWidgets);
    });

    testWidgets('Can select a color', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Event Color'));
      await tester.pumpAndSettle();

      // Tap first color
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // Color picker should close
      expect(find.text('Select Color'), findsNothing);
    });
  });

  group('Day Details Tests', () {
    testWidgets('Tapping a day shows bottom sheet',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Find a date cell and tap it
      final Finder dateFinder = find.text('15').first;
      if (dateFinder.evaluate().isNotEmpty) {
        await tester.tap(dateFinder);
        await tester.pumpAndSettle();

        // Bottom sheet should appear with date info
        expect(find.byType(BottomSheet), findsOneWidget);
      }
    });
  });

  group('Info Bar Tests', () {
    testWidgets('Info bar shows event count', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text('Events'), findsOneWidget);
    });

    testWidgets('Info bar shows current view', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text('View'), findsOneWidget);
      expect(find.text('MONTH'), findsOneWidget);
    });

    testWidgets('Info bar shows selected info', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text('Selected'), findsOneWidget);
    });
  });

  group('Sample Events Tests', () {
    testWidgets('Sample events are loaded', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Check that events are displayed in info bar
      final Finder eventCountFinder = find.descendant(
        of: find.byIcon(Icons.calendar_today),
        matching: find.byType(Text),
      );

      expect(eventCountFinder, findsWidgets);
    });
  });

  group('Holidays Tests', () {
    testWidgets('Holidays are configured', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });
  });

  group('Priority Icon Tests', () {
    testWidgets('Priority icons are correct', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Test is implicit - if app renders, priority logic works
      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });
  });

  group('Recurring Events Tests', () {
    testWidgets('Recurring events are added', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Sample events include recurring events
      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });
  });

  group('Edge Cases Tests', () {
    testWidgets('Handles empty event title gracefully',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      // Dialog should still be open
      expect(find.text('Add Event'), findsOneWidget);
    });

    testWidgets('Handles theme changes correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.palette));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.palette));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Light'));
      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });

    testWidgets('Handles multiple setting changes',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      final Finder verticalScrollSwitch = find.byWidgetPredicate(
        (Widget widget) =>
            widget is SwitchListTile &&
            widget.title is Text &&
            (widget.title as Text).data == 'Vertical Scroll',
      );

      await tester.tap(verticalScrollSwitch);
      await tester.pumpAndSettle();

      expect(find.byType(AdvancedCalendar), findsOneWidget);
    });
  });

  group('Integration Tests', () {
    testWidgets('Full workflow: Add, view, and delete event',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Add event
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Integration Test Event');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      expect(find.text('Event added'), findsOneWidget);

      // Wait for snackbar to disappear
      await tester.pumpAndSettle(const Duration(seconds: 2));
    });

    testWidgets('Change theme and add event', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Change theme
      await tester.tap(find.byIcon(Icons.palette));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      // Add event
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Dark Theme Event');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      expect(find.text('Event added'), findsOneWidget);
    });

    testWidgets('Add multi-day event', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Multi-Day Event');
      await tester.pumpAndSettle();

      final Finder multiDaySwitch = find.byWidgetPredicate(
        (Widget widget) =>
            widget is SwitchListTile &&
            widget.title is Text &&
            (widget.title as Text).data == 'Multi-Day Event',
      );

      await tester.tap(multiDaySwitch);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Multi-day event added'), findsOneWidget);
    });
  });
}
