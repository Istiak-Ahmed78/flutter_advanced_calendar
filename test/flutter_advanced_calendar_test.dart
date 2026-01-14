// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';

// void main() {
//   group('AdvancedCalendar Widget Tests', () {
//     testWidgets('Calendar renders correctly', (WidgetTester tester) async {
//       await tester.pumpWidget(
//         MaterialApp(
//           home: Scaffold(
//             body: AdvancedCalendar(
//               initialDate: DateTime(2024, 1, 15),
//               onDateSelected: (date) {},
//             ),
//           ),
//         ),
//       );

//       expect(find.byType(AdvancedCalendar), findsOneWidget);
//     });

//     testWidgets('Calendar displays current month', (WidgetTester tester) async {
//       final testDate = DateTime(2024, 3, 15);

//       await tester.pumpWidget(
//         MaterialApp(
//           home: Scaffold(
//             body: AdvancedCalendar(
//               initialDate: testDate,
//               onDateSelected: (date) {},
//             ),
//           ),
//         ),
//       );

//       // Verify month/year header is displayed
//       expect(find.text('March 2024'), findsOneWidget);
//     });

//     testWidgets('Date selection callback works', (WidgetTester tester) async {
//       DateTime? selectedDate;

//       await tester.pumpWidget(
//         MaterialApp(
//           home: Scaffold(
//             body: AdvancedCalendar(
//               initialDate: DateTime(2024, 1, 15),
//               onDateSelected: (date) {
//                 selectedDate = date;
//               },
//             ),
//           ),
//         ),
//       );

//       // Tap on a date
//       await tester.tap(find.text('20'));
//       await tester.pump();

//       expect(selectedDate, isNotNull);
//       expect(selectedDate?.day, 20);
//     });

//     testWidgets('Navigation to next month works', (WidgetTester tester) async {
//       await tester.pumpWidget(
//         MaterialApp(
//           home: Scaffold(
//             body: AdvancedCalendar(
//               initialDate: DateTime(2024, 1, 15),
//               onDateSelected: (date) {},
//             ),
//           ),
//         ),
//       );

//       expect(find.text('January 2024'), findsOneWidget);

//       // Tap next month button
//       await tester.tap(find.byIcon(Icons.chevron_right));
//       await tester.pumpAndSettle();

//       expect(find.text('February 2024'), findsOneWidget);
//     });

//     testWidgets('Navigation to previous month works',
//         (WidgetTester tester) async {
//       await tester.pumpWidget(
//         MaterialApp(
//           home: Scaffold(
//             body: AdvancedCalendar(
//               initialDate: DateTime(2024, 1, 15),
//               onDateSelected: (date) {},
//             ),
//           ),
//         ),
//       );

//       expect(find.text('January 2024'), findsOneWidget);

//       // Tap previous month button
//       await tester.tap(find.byIcon(Icons.chevron_left));
//       await tester.pumpAndSettle();

//       expect(find.text('December 2023'), findsOneWidget);
//     });

//     testWidgets('Events are displayed on calendar',
//         (WidgetTester tester) async {
//       final events = [
//         CalendarEvent(
//           id: '1',
//           title: 'Meeting',
//           date: DateTime(2024, 1, 15),
//           color: Colors.blue,
//         ),
//         CalendarEvent(
//           id: '2',
//           title: 'Birthday',
//           date: DateTime(2024, 1, 20),
//           color: Colors.red,
//         ),
//       ];

//       await tester.pumpWidget(
//         MaterialApp(
//           home: Scaffold(
//             body: AdvancedCalendar(
//               initialDate: DateTime(2024, 1, 15),
//               events: events,
//               onDateSelected: (date) {},
//             ),
//           ),
//         ),
//       );

//       // Verify events are displayed
//       expect(find.text('Meeting'), findsOneWidget);
//       expect(find.text('Birthday'), findsOneWidget);
//     });

//     testWidgets('Custom styling is applied', (WidgetTester tester) async {
//       final config = CalendarConfig(
//         primaryColor: Colors.purple,
//         selectedDateColor: Colors.amber,
//         todayColor: Colors.green,
//         weekdayTextStyle: const TextStyle(fontWeight: FontWeight.bold),
//       );

//       await tester.pumpWidget(
//         MaterialApp(
//           home: Scaffold(
//             body: AdvancedCalendar(
//               initialDate: DateTime(2024, 1, 15),
//               config: config,
//               onDateSelected: (date) {},
//             ),
//           ),
//         ),
//       );

//       expect(find.byType(AdvancedCalendar), findsOneWidget);
//     });

//     testWidgets('Today is highlighted', (WidgetTester tester) async {
//       final today = DateTime.now();

//       await tester.pumpWidget(
//         MaterialApp(
//           home: Scaffold(
//             body: AdvancedCalendar(
//               initialDate: today,
//               onDateSelected: (date) {},
//             ),
//           ),
//         ),
//       );

//       // Find today's date with special styling
//       expect(find.byType(AdvancedCalendar), findsOneWidget);
//     });
//   });

//   group('AdvancedCalendar Edge Cases', () {
//     testWidgets('Handles leap year correctly', (WidgetTester tester) async {
//       await tester.pumpWidget(
//         MaterialApp(
//           home: Scaffold(
//             body: AdvancedCalendar(
//               initialDate: DateTime(2024, 2, 15), // 2024 is a leap year
//               onDateSelected: (date) {},
//             ),
//           ),
//         ),
//       );

//       expect(find.text('29'), findsOneWidget); // Feb 29 should exist
//     });

//     testWidgets('Handles non-leap year correctly', (WidgetTester tester) async {
//       await tester.pumpWidget(
//         MaterialApp(
//           home: Scaffold(
//             body: AdvancedCalendar(
//               initialDate: DateTime(2023, 2, 15), // 2023 is not a leap year
//               onDateSelected: (date) {},
//             ),
//           ),
//         ),
//       );

//       expect(find.text('29'), findsNothing); // Feb 29 should not exist
//     });

//     testWidgets('Handles empty events list', (WidgetTester tester) async {
//       await tester.pumpWidget(
//         MaterialApp(
//           home: Scaffold(
//             body: AdvancedCalendar(
//               initialDate: DateTime(2024, 1, 15),
//               events: [],
//               onDateSelected: (date) {},
//             ),
//           ),
//         ),
//       );

//       expect(find.byType(AdvancedCalendar), findsOneWidget);
//     });
//   });
// }
