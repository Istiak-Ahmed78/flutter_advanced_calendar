import 'package:flutter/material.dart';
import 'package:flutter_calendar_pro/flutter_calendar_pro.dart';

class SampleData {
  // Private constructor to prevent instantiation
  SampleData._();

  /// Get a list of sample events for demonstration
  static List<CalendarEvent> getEvents() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return [
      // Today's events
      CalendarEvent(
        id: '1',
        title: 'Team Meeting',
        description: 'Daily team sync',
        startDate: today.add(const Duration(hours: 9)),
        endDate: today.add(const Duration(hours: 10)),
        color: Colors.blue,
        location: 'Conference Room A',
        icon: Icons.people,
      ),
      CalendarEvent(
        id: '2',
        title: 'Lunch Break',
        description: 'Team lunch',
        startDate: today.add(const Duration(hours: 13)),
        endDate: today.add(const Duration(hours: 14)),
        color: Colors.orange,
        location: 'Downtown Cafe',
        icon: Icons.restaurant,
      ),

      // Tomorrow's events
      CalendarEvent(
        id: '3',
        title: 'Project Deadline',
        description: 'Submit final deliverables',
        startDate: today.add(const Duration(days: 1)),
        endDate: today.add(const Duration(days: 1)),
        color: Colors.red,
        isAllDay: true,
        icon: Icons.flag,
      ),
      CalendarEvent(
        id: '5',
        title: 'Workshop',
        description: 'Flutter best practices',
        startDate: today.add(const Duration(days: 5, hours: 10)),
        endDate: today.add(const Duration(days: 5, hours: 17)),
        color: Colors.purple,
        location: 'Training Room',
        icon: Icons.school,
      ),
    ];
  }

  /// Get simple events (backward compatibility)
  static List<CalendarEvent> getSimpleEvents() {
    return getEvents();
  }

  /// Get events for a specific date range
  static List<CalendarEvent> getEventsForRange(DateTime start, DateTime end) {
    return getEvents().where((event) {
      return event.startDate.isAfter(start.subtract(const Duration(days: 1))) &&
          event.startDate.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  /// Get upcoming events (from today onwards)
  static List<CalendarEvent> getUpcomingEvents() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return getEvents().where((event) {
      return event.startDate.isAfter(today.subtract(const Duration(days: 1)));
    }).toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
  }

  /// Get events for today
  static List<CalendarEvent> getTodayEvents() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    return getEvents().where((event) {
      return event.startDate
              .isAfter(today.subtract(const Duration(seconds: 1))) &&
          event.startDate.isBefore(tomorrow);
    }).toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
  }

  /// Get events for this week
  static List<CalendarEvent> getWeekEvents() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 7));

    return getEventsForRange(weekStart, weekEnd);
  }

  /// Get events for this month
  static List<CalendarEvent> getMonthEvents() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);

    return getEventsForRange(monthStart, monthEnd);
  }
}
