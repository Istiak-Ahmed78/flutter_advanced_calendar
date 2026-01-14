// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';
// import 'package:flutter/material.dart';

// void main() {
//   group('CalendarController Tests', () {
//     late CalendarController controller;

//     setUp(() {
//       controller = CalendarController(
//         initialDate: DateTime(2024, 1, 15),
//       );
//     });

//     tearDown(() {
//       controller.dispose();
//     });

//     test('Initial state is correct', () {
//       expect(controller.focusedDay.year, 2024);
//       expect(controller.focusedDay.month, 1);
//       expect(controller.currentView, CalendarView.month);
//       expect(controller.events.isEmpty, true);
//     });

//     test('Navigation works correctly', () {
//       controller.nextMonth();
//       expect(controller.focusedDay.month, 2);

//       controller.previousMonth();
//       expect(controller.focusedDay.month, 1);

//       controller.nextYear();
//       expect(controller.focusedDay.year, 2025);

//       controller.previousYear();
//       expect(controller.focusedDay.year, 2024);
//     });

//     test('Day selection works', () {
//       final day = DateTime(2024, 1, 20);
//       controller.selectDay(day);

//       expect(controller.selectedDay, day);
//       expect(controller.isDaySelected(day), true);
//     });

//     test('Range selection works', () {
//       final start = DateTime(2024, 1, 10);
//       final end = DateTime(2024, 1, 15);

//       controller.selectRange(start, end);

//       expect(controller.rangeStart, start);
//       expect(controller.rangeEnd, end);
//       expect(controller.hasRangeSelection, true);
//       expect(controller.selectedRange.length, 6); // 10-15 inclusive
//     });

//     test('Event management works', () {
//       final event = CalendarEvent(
//         id: '1',
//         title: 'Test Event',
//         startDate: DateTime(2024, 1, 15, 10, 0),
//         endDate: DateTime(2024, 1, 15, 11, 0),
//         color: Colors.blue,
//       );

//       controller.addEvent(event);
//       expect(controller.events.length, 1);

//       final eventsOnDay = controller.getEventsForDay(DateTime(2024, 1, 15));
//       expect(eventsOnDay.length, 1);
//       expect(eventsOnDay.first.title, 'Test Event');

//       controller.removeEvent('1');
//       expect(controller.events.isEmpty, true);
//     });

//     test('Multi-day event works', () {
//       final event = CalendarEvent.withDuration(
//         id: '1',
//         title: 'Multi-day Event',
//         startDate: DateTime(2024, 1, 10),
//         durationDays: 3,
//         color: Colors.green,
//       );

//       controller.addEvent(event);

//       // Should appear on all 4 days (start + 3 days)
//       expect(controller.hasEventsOnDay(DateTime(2024, 1, 10)), true);
//       expect(controller.hasEventsOnDay(DateTime(2024, 1, 11)), true);
//       expect(controller.hasEventsOnDay(DateTime(2024, 1, 12)), true);
//       expect(controller.hasEventsOnDay(DateTime(2024, 1, 13)), true);
//       expect(controller.hasEventsOnDay(DateTime(2024, 1, 14)), false);
//     });

//     test('Holiday management works', () {
//       final holiday = DateTime(2024, 1, 1);

//       controller.addHoliday(holiday);
//       expect(controller.isHoliday(holiday), true);
//       expect(controller.holidays.length, 1);

//       controller.removeHoliday(holiday);
//       expect(controller.isHoliday(holiday), false);
//     });

//     test('View switching works', () {
//       expect(controller.currentView, CalendarView.month);

//       controller.setView(CalendarView.week);
//       expect(controller.currentView, CalendarView.week);

//       controller.toggleMonthWeekView();
//       expect(controller.currentView, CalendarView.month);
//     });

//     test('Jump to date works', () {
//       final targetDate = DateTime(2025, 6, 15);
//       controller.jumpToDate(targetDate);

//       expect(controller.focusedDay.year, 2025);
//       expect(controller.focusedDay.month, 6);
//       expect(controller.focusedDay.day, 15);
//     });

//     test('Clear selection works', () {
//       controller..selectDay(DateTime(2024, 1, 15))
//       ..selectRange(DateTime(2024, 1, 10), DateTime(2024, 1, 20))

//       ..clearSelection();

//       expect(controller.selectedDay, null);
//       expect(controller.rangeStart, null);
//       expect(controller.rangeEnd, null);
//     });
//   });

//   group('RecurrenceRule Tests', () {
//     test('Daily recurrence works', () {
//       final rule = RecurrenceRule(
//         frequency: RecurrenceFrequency.daily,
//         interval: 1,
//         endCondition: RecurrenceEnd.count(5),
//       );

//       final start = DateTime(2024);
//       final occurrences = rule.generateOccurrences(
//         start,
//         DateTime(2024),
//         DateTime(2024, 1, 31),
//       );

//       expect(occurrences.length, 5);
//       expect(occurrences[0].day, 1);
//       expect(occurrences[4].day, 5);
//     });

//     test('Weekly recurrence works', () {
//       final rule = RecurrenceRule(
//         frequency: RecurrenceFrequency.weekly,
//         byWeekDay: [DateTime.monday, DateTime.wednesday, DateTime.friday],
//         endCondition: RecurrenceEnd.count(6),
//       );

//       final start = DateTime(2024, 1, 1); // Monday
//       final occurrences = rule.generateOccurrences(
//         start,
//         DateTime(2024),
//         DateTime(2024, 1, 31),
//       );

//       expect(occurrences.length, 6);
//       // Should be Mon, Wed, Fri, Mon, Wed, Fri
//     });

//     test('Monthly recurrence works', () {
//       final rule = RecurrenceRule(
//         frequency: RecurrenceFrequency.monthly,
//         endCondition: RecurrenceEnd.count(3),
//       );

//       final start = DateTime(2024, 1, 15);
//       final occurrences = rule.generateOccurrences(
//         start,
//         DateTime(2024),
//         DateTime(2024, 12, 31),
//       );

//       expect(occurrences.length, 3);
//       expect(occurrences[0].month, 1);
//       expect(occurrences[1].month, 2);
//       expect(occurrences[2].month, 3);
//     });
//   });
// }
