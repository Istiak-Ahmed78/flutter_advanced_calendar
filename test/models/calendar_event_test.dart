import 'package:flutter/material.dart';
import 'package:flutter_calendar_pro/src/core/models/calendar_event.dart';
import 'package:flutter_calendar_pro/src/core/models/enums.dart';
import 'package:flutter_calendar_pro/src/core/models/recurrence_rule.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CalendarEvent Tests', () {
    test('CalendarEvent creates instance correctly', () {
      final startDate = DateTime(2024, 1, 15, 10);
      final endDate = DateTime(2024, 1, 15, 11);

      final event = CalendarEvent(
        id: '1',
        title: 'Test Event',
        startDate: startDate,
        endDate: endDate,
      );

      expect(event.id, '1');
      expect(event.title, 'Test Event');
      expect(event.startDate, startDate);
      expect(event.endDate, endDate);
      expect(event.color, Colors.blue);
      expect(event.isAllDay, false);
      expect(event.description, null);
      expect(event.location, null);
    });

    test('CalendarEvent with all properties', () {
      final startDate = DateTime(2024, 1, 15, 10);
      final endDate = DateTime(2024, 1, 15, 11);

      final event = CalendarEvent(
        id: '2',
        title: 'Meeting',
        description: 'Team standup meeting',
        startDate: startDate,
        endDate: endDate,
        color: Colors.green,
        textColor: Colors.white,
        dotColor: Colors.red,
        location: 'Conference Room A',
        icon: Icons.meeting_room,
        category: 'Work',
        priority: EventPriority.high,
      );

      expect(event.description, 'Team standup meeting');
      expect(event.textColor, Colors.white);
      expect(event.dotColor, Colors.red);
      expect(event.location, 'Conference Room A');
      expect(event.icon, Icons.meeting_room);
      expect(event.category, 'Work');
      expect(event.priority, EventPriority.high);
      expect(event.status, EventStatus.confirmed);
    });

    test('CalendarEvent with duration factory', () {
      final startDate = DateTime(2024, 1, 15);

      final event = CalendarEvent.withDuration(
        id: '3',
        title: 'Project Sprint',
        startDate: startDate,
        durationDays: 7,
        color: Colors.purple,
        dotColor: Colors.amber,
      );

      expect(event.id, '3');
      expect(event.title, 'Project Sprint');
      expect(event.startDate, startDate);
      expect(event.endDate, DateTime(2024, 1, 22));
      expect(event.durationDays, 7);
      expect(event.isAllDay, true);
      expect(event.dotColor, Colors.amber);
    });

    test('CalendarEvent throws assertion error for invalid dates', () {
      final startDate = DateTime(2024, 1, 15);
      final endDate = DateTime(2024, 1, 14);

      expect(
        () => CalendarEvent(
          id: '4',
          title: 'Invalid Event',
          startDate: startDate,
          endDate: endDate,
        ),
        throwsAssertionError,
      );
    });

    test('CalendarEvent allows same start and end date', () {
      final date = DateTime(2024, 1, 15, 10);

      final event = CalendarEvent(
        id: '5',
        title: 'Same Date Event',
        startDate: date,
        endDate: date,
      );

      expect(event.startDate, date);
      expect(event.endDate, date);
    });

    test('CalendarEvent effectiveDotColor returns dotColor when set', () {
      final event = CalendarEvent(
        id: '6',
        title: 'Event',
        startDate: DateTime(2024, 1, 15),
        endDate: DateTime(2024, 1, 15),
        dotColor: Colors.red,
      );

      expect(event.effectiveDotColor, Colors.red);
    });

    test('CalendarEvent effectiveDotColor returns color when dotColor is null',
        () {
      final event = CalendarEvent(
        id: '7',
        title: 'Event',
        startDate: DateTime(2024, 1, 15),
        endDate: DateTime(2024, 1, 15),
      );

      expect(event.effectiveDotColor, Colors.blue);
    });

    test('CalendarEvent isMultiDay returns true for multi-day events', () {
      final event = CalendarEvent(
        id: '8',
        title: 'Multi-day Event',
        startDate: DateTime(2024, 1, 15),
        endDate: DateTime(2024, 1, 17),
        isAllDay: true,
      );

      expect(event.isMultiDay, true);
    });

    test('CalendarEvent isMultiDay returns false for same-day events', () {
      final event = CalendarEvent(
        id: '9',
        title: 'Single Day Event',
        startDate: DateTime(2024, 1, 15, 10),
        endDate: DateTime(2024, 1, 15, 11),
      );

      expect(event.isMultiDay, false);
    });

    test('CalendarEvent dateRange returns correct dates', () {
      final event = CalendarEvent(
        id: '10',
        title: 'Range Event',
        startDate: DateTime(2024, 1, 15),
        endDate: DateTime(2024, 1, 17),
        isAllDay: true,
      );

      final range = event.dateRange;

      expect(range.length, 3);
      expect(range[0].day, 15);
      expect(range[1].day, 16);
      expect(range[2].day, 17);
    });

    test('CalendarEvent getCurrentDay returns correct day number', () {
      final event = CalendarEvent(
        id: '11',
        title: 'Multi-day Event',
        startDate: DateTime(2024, 1, 15),
        endDate: DateTime(2024, 1, 17),
        isAllDay: true,
      );

      expect(event.getCurrentDay(DateTime(2024, 1, 15)), 1);
      expect(event.getCurrentDay(DateTime(2024, 1, 16)), 2);
      expect(event.getCurrentDay(DateTime(2024, 1, 17)), 3);
      expect(event.getCurrentDay(DateTime(2024, 1, 18)), null);
    });

    test('CalendarEvent getCurrentDay returns null for single-day events', () {
      final event = CalendarEvent(
        id: '12',
        title: 'Single Day Event',
        startDate: DateTime(2024, 1, 15, 10),
        endDate: DateTime(2024, 1, 15, 11),
      );

      expect(event.getCurrentDay(DateTime(2024, 1, 15)), null);
    });

    test('CalendarEvent getTotalDays returns correct count', () {
      final multiDayEvent = CalendarEvent(
        id: '13',
        title: 'Multi-day Event',
        startDate: DateTime(2024, 1, 15),
        endDate: DateTime(2024, 1, 17),
        isAllDay: true,
      );

      final singleDayEvent = CalendarEvent(
        id: '14',
        title: 'Single Day Event',
        startDate: DateTime(2024, 1, 15, 10),
        endDate: DateTime(2024, 1, 15, 11),
      );

      expect(multiDayEvent.getTotalDays, 3);
      expect(singleDayEvent.getTotalDays, 1);
    });

    test('CalendarEvent occursOnDate returns true for event dates', () {
      final event = CalendarEvent(
        id: '15',
        title: 'Event',
        startDate: DateTime(2024, 1, 15),
        endDate: DateTime(2024, 1, 17),
        isAllDay: true,
      );

      expect(event.occursOnDate(DateTime(2024, 1, 15)), true);
      expect(event.occursOnDate(DateTime(2024, 1, 16)), true);
      expect(event.occursOnDate(DateTime(2024, 1, 17)), true);
      expect(event.occursOnDate(DateTime(2024, 1, 18)), false);
    });

    test('CalendarEvent occursOnDate respects exception dates', () {
      final event = CalendarEvent(
        id: '16',
        title: 'Event',
        startDate: DateTime(2024, 1, 15),
        endDate: DateTime(2024, 1, 17),
        isAllDay: true,
        exceptionDates: <DateTime>[DateTime(2024, 1, 16)],
      );

      expect(event.occursOnDate(DateTime(2024, 1, 15)), true);
      expect(event.occursOnDate(DateTime(2024, 1, 16)), false);
      expect(event.occursOnDate(DateTime(2024, 1, 17)), true);
    });

    test('CalendarEvent durationInHours calculates correctly', () {
      final event = CalendarEvent(
        id: '17',
        title: 'Event',
        startDate: DateTime(2024, 1, 15, 10),
        endDate: DateTime(2024, 1, 15, 12, 30),
      );

      expect(event.durationInHours, 2.5);
    });

    test('CalendarEvent durationInMinutes calculates correctly', () {
      final event = CalendarEvent(
        id: '18',
        title: 'Event',
        startDate: DateTime(2024, 1, 15, 10),
        endDate: DateTime(2024, 1, 15, 10, 45),
      );

      expect(event.durationInMinutes, 45);
    });

    test('CalendarEvent isHappening returns correct value', () {
      final now = DateTime.now();
      final happeningEvent = CalendarEvent(
        id: '19',
        title: 'Happening Now',
        startDate: now.subtract(const Duration(hours: 1)),
        endDate: now.add(const Duration(hours: 1)),
      );

      final pastEvent = CalendarEvent(
        id: '20',
        title: 'Past Event',
        startDate: now.subtract(const Duration(hours: 2)),
        endDate: now.subtract(const Duration(hours: 1)),
      );

      expect(happeningEvent.isHappening, true);
      expect(pastEvent.isHappening, false);
    });

    test('CalendarEvent isPast returns correct value', () {
      final now = DateTime.now();
      final pastEvent = CalendarEvent(
        id: '21',
        title: 'Past Event',
        startDate: now.subtract(const Duration(days: 2)),
        endDate: now.subtract(const Duration(days: 1)),
      );

      final futureEvent = CalendarEvent(
        id: '22',
        title: 'Future Event',
        startDate: now.add(const Duration(days: 1)),
        endDate: now.add(const Duration(days: 2)),
      );

      expect(pastEvent.isPast, true);
      expect(futureEvent.isPast, false);
    });

    test('CalendarEvent isFuture returns correct value', () {
      final now = DateTime.now();
      final futureEvent = CalendarEvent(
        id: '23',
        title: 'Future Event',
        startDate: now.add(const Duration(days: 1)),
        endDate: now.add(const Duration(days: 2)),
      );

      final pastEvent = CalendarEvent(
        id: '24',
        title: 'Past Event',
        startDate: now.subtract(const Duration(days: 2)),
        endDate: now.subtract(const Duration(days: 1)),
      );

      expect(futureEvent.isFuture, true);
      expect(pastEvent.isFuture, false);
    });

    test('CalendarEvent isCancelled returns correct value', () {
      final cancelledEvent = CalendarEvent(
        id: '25',
        title: 'Cancelled Event',
        startDate: DateTime(2024, 1, 15),
        endDate: DateTime(2024, 1, 15),
        status: EventStatus.cancelled,
      );

      final confirmedEvent = CalendarEvent(
        id: '26',
        title: 'Confirmed Event',
        startDate: DateTime(2024, 1, 15),
        endDate: DateTime(2024, 1, 15),
      );

      expect(cancelledEvent.isCancelled, true);
      expect(confirmedEvent.isCancelled, false);
    });

    test('CalendarEvent isTentative returns correct value', () {
      final tentativeEvent = CalendarEvent(
        id: '27',
        title: 'Tentative Event',
        startDate: DateTime(2024, 1, 15),
        endDate: DateTime(2024, 1, 15),
        status: EventStatus.tentative,
      );

      final confirmedEvent = CalendarEvent(
        id: '28',
        title: 'Confirmed Event',
        startDate: DateTime(2024, 1, 15),
        endDate: DateTime(2024, 1, 15),
      );

      expect(tentativeEvent.isTentative, true);
      expect(confirmedEvent.isTentative, false);
    });

    test('CalendarEvent copyWith creates modified copy', () {
      final original = CalendarEvent(
        id: '29',
        title: 'Original',
        startDate: DateTime(2024, 1, 15),
        endDate: DateTime(2024, 1, 15),
      );

      final modified = original.copyWith(
        title: 'Modified',
        color: Colors.red,
        dotColor: Colors.green,
      );

      expect(modified.id, '29');
      expect(modified.title, 'Modified');
      expect(modified.color, Colors.red);
      expect(modified.dotColor, Colors.green);
      expect(modified.startDate, original.startDate);
      expect(modified.endDate, original.endDate);
    });

    test('CalendarEvent copyWith preserves unmodified values', () {
      final original = CalendarEvent(
        id: '30',
        title: 'Original',
        description: 'Description',
        startDate: DateTime(2024, 1, 15),
        endDate: DateTime(2024, 1, 15),
        location: 'Location',
        category: 'Category',
      );

      final modified = original.copyWith(
        title: 'Modified',
      );

      expect(modified.description, original.description);
      expect(modified.location, original.location);
      expect(modified.category, original.category);
    });

    test('CalendarEvent toJson serializes correctly', () {
      final event = CalendarEvent(
        id: '31',
        title: 'Test Event',
        description: 'Description',
        startDate: DateTime(2024, 1, 15, 10),
        endDate: DateTime(2024, 1, 15, 11),
        textColor: Colors.white,
        dotColor: Colors.red,
        location: 'Location',
        category: 'Work',
        priority: EventPriority.high,
      );

      final json = event.toJson();

      expect(json['id'], '31');
      expect(json['title'], 'Test Event');
      expect(json['description'], 'Description');
      expect(json['startDate'], event.startDate.toIso8601String());
      expect(json['endDate'], event.endDate.toIso8601String());
      expect(json['isAllDay'], false);
      expect(json['color'], isA<int>());
      expect(json['textColor'], isA<int>());
      expect(json['dotColor'], isA<int>());
      expect(json['location'], 'Location');
      expect(json['category'], 'Work');
      expect(json['priority'], 'high');
      expect(json['status'], 'confirmed');
    });

    test('CalendarEvent fromJson deserializes correctly', () {
      final json = <String, dynamic>{
        'id': '32',
        'title': 'Test Event',
        'description': 'Description',
        'startDate': '2024-01-15T10:00:00.000',
        'endDate': '2024-01-15T11:00:00.000',
        'isAllDay': false,
        'color': Colors.blue.toARGB32(), // FIXED
        'textColor': Colors.white.toARGB32(), // FIXED
        'dotColor': Colors.red.toARGB32(), // FIXED
        'location': 'Location',
        'category': 'Work',
        'priority': 'high',
        'status': 'confirmed',
      };

      final event = CalendarEvent.fromJson(json);

      expect(event.id, '32');
      expect(event.title, 'Test Event');
      expect(event.description, 'Description');
      expect(event.isAllDay, false);
      expect(event.location, 'Location');
      expect(event.category, 'Work');
      expect(event.priority, EventPriority.high);
      expect(event.status, EventStatus.confirmed);
    });

    test('CalendarEvent fromJson handles missing optional fields', () {
      final json = <String, dynamic>{
        'id': '33',
        'title': 'Minimal Event',
        'startDate': '2024-01-15T10:00:00.000',
        'endDate': '2024-01-15T11:00:00.000',
      };

      final event = CalendarEvent.fromJson(json);

      expect(event.id, '33');
      expect(event.title, 'Minimal Event');
      expect(event.description, null);
      expect(event.location, null);
      expect(event.category, null);
      expect(event.priority, EventPriority.normal);
      expect(event.status, EventStatus.confirmed);
    });

    test('CalendarEvent fromJson handles string boolean values', () {
      final json = <String, dynamic>{
        'id': '34',
        'title': 'Event',
        'startDate': '2024-01-15T10:00:00.000',
        'endDate': '2024-01-15T11:00:00.000',
        'isAllDay': 'true',
      };

      final event = CalendarEvent.fromJson(json);

      expect(event.isAllDay, true);
    });

    test('CalendarEvent fromJson handles integer boolean values', () {
      final json = <String, dynamic>{
        'id': '35',
        'title': 'Event',
        'startDate': '2024-01-15T10:00:00.000',
        'endDate': '2024-01-15T11:00:00.000',
        'isAllDay': 1,
      };

      final event = CalendarEvent.fromJson(json);

      expect(event.isAllDay, true);
    });

    test('CalendarEvent fromJson handles string color values', () {
      final json = <String, dynamic>{
        'id': '36',
        'title': 'Event',
        'startDate': '2024-01-15T10:00:00.000',
        'endDate': '2024-01-15T11:00:00.000',
        'color': Colors.blue.toARGB32().toString(), // FIXED
      };

      final event = CalendarEvent.fromJson(json);

      expect(event.color, isA<Color>());
    });

    test('CalendarEvent fromJson handles exception dates', () {
      final json = <String, dynamic>{
        'id': '37',
        'title': 'Event',
        'startDate': '2024-01-15T10:00:00.000',
        'endDate': '2024-01-15T11:00:00.000',
        'exceptionDates': <String>[
          '2024-01-16T00:00:00.000',
          '2024-01-17T00:00:00.000',
        ],
      };

      final event = CalendarEvent.fromJson(json);

      expect(event.exceptionDates, isNotNull);
      expect(event.exceptionDates?.length, 2);
    });

    test('CalendarEvent fromJson handles custom data', () {
      final json = <String, dynamic>{
        'id': '38',
        'title': 'Event',
        'startDate': '2024-01-15T10:00:00.000',
        'endDate': '2024-01-15T11:00:00.000',
        'customData': <String, dynamic>{
          'key1': 'value1',
          'key2': 123,
        },
      };

      final event = CalendarEvent.fromJson(json);

      expect(event.customData, isNotNull);
      expect(event.customData?['key1'], 'value1');
      expect(event.customData?['key2'], 123);
    });

    test('CalendarEvent equality based on id', () {
      final event1 = CalendarEvent(
        id: '39',
        title: 'Event 1',
        startDate: DateTime(2024, 1, 15),
        endDate: DateTime(2024, 1, 15),
      );

      final event2 = CalendarEvent(
        id: '39',
        title: 'Event 2',
        startDate: DateTime(2024, 1, 16),
        endDate: DateTime(2024, 1, 16),
      );

      final event3 = CalendarEvent(
        id: '40',
        title: 'Event 1',
        startDate: DateTime(2024, 1, 15),
        endDate: DateTime(2024, 1, 15),
      );

      expect(event1, equals(event2));
      expect(event1, isNot(equals(event3)));
    });

    test('CalendarEvent hashCode based on id', () {
      final event1 = CalendarEvent(
        id: '41',
        title: 'Event',
        startDate: DateTime(2024, 1, 15),
        endDate: DateTime(2024, 1, 15),
      );

      final event2 = CalendarEvent(
        id: '41',
        title: 'Different Title',
        startDate: DateTime(2024, 1, 16),
        endDate: DateTime(2024, 1, 16),
      );

      expect(event1.hashCode, equals(event2.hashCode));
    });

    test('CalendarEvent toString returns correct format', () {
      final event = CalendarEvent(
        id: '42',
        title: 'Test Event',
        startDate: DateTime(2024, 1, 15, 10),
        endDate: DateTime(2024, 1, 15, 11),
      );

      final str = event.toString();

      expect(str, contains('42'));
      expect(str, contains('Test Event'));
      expect(str, contains('2024'));
    });

    test('CalendarEvent with recurrence rule', () {
      final rule = RecurrenceRule(
        frequency: RecurrenceFrequency.daily,
      );

      final event = CalendarEvent(
        id: '43',
        title: 'Recurring Event',
        startDate: DateTime(2024, 1, 15),
        endDate: DateTime(2024, 1, 15),
        recurrenceRule: rule,
      );

      expect(event.recurrenceRule, isNotNull);
      expect(event.recurrenceRule?.frequency, RecurrenceFrequency.daily);
    });

    test('CalendarEvent with custom data', () {
      final customData = <String, dynamic>{
        'attendees': <String>['John', 'Jane'],
        'room': 'A101',
        'equipment': <String>['Projector', 'Whiteboard'],
      };

      final event = CalendarEvent(
        id: '44',
        title: 'Event',
        startDate: DateTime(2024, 1, 15),
        endDate: DateTime(2024, 1, 15),
        customData: customData,
      );

      expect(event.customData, isNotNull);
      expect(event.customData?['attendees'], isA<List<String>>());
      expect(event.customData?['room'], 'A101');
    });

    test('CalendarEvent with all event priorities', () {
      final lowEvent = CalendarEvent(
        id: '45',
        title: 'Low Priority',
        startDate: DateTime(2024, 1, 15),
        endDate: DateTime(2024, 1, 15),
        priority: EventPriority.low,
      );

      final normalEvent = CalendarEvent(
        id: '46',
        title: 'Normal Priority',
        startDate: DateTime(2024, 1, 15),
        endDate: DateTime(2024, 1, 15),
      );

      final highEvent = CalendarEvent(
        id: '47',
        title: 'High Priority',
        startDate: DateTime(2024, 1, 15),
        endDate: DateTime(2024, 1, 15),
        priority: EventPriority.high,
      );

      expect(lowEvent.priority, EventPriority.low);
      expect(normalEvent.priority, EventPriority.normal);
      expect(highEvent.priority, EventPriority.high);
    });

    test('CalendarEvent with all event statuses', () {
      final confirmedEvent = CalendarEvent(
        id: '48',
        title: 'Confirmed',
        startDate: DateTime(2024, 1, 15),
        endDate: DateTime(2024, 1, 15),
      );

      final tentativeEvent = CalendarEvent(
        id: '49',
        title: 'Tentative',
        startDate: DateTime(2024, 1, 15),
        endDate: DateTime(2024, 1, 15),
        status: EventStatus.tentative,
      );

      final cancelledEvent = CalendarEvent(
        id: '50',
        title: 'Cancelled',
        startDate: DateTime(2024, 1, 15),
        endDate: DateTime(2024, 1, 15),
        status: EventStatus.cancelled,
      );

      expect(confirmedEvent.status, EventStatus.confirmed);
      expect(tentativeEvent.status, EventStatus.tentative);
      expect(cancelledEvent.status, EventStatus.cancelled);
    });
  });
}
