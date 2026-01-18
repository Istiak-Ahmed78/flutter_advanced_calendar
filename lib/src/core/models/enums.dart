import 'package:flutter_calendar_pro/flutter_calendar_pro.dart';

/// Priority levels for calendar events.
///
/// Used to indicate the importance or urgency of an event.
///
/// Example:
/// ```dart
/// final event = CalendarEvent(
///   title: 'Important Meeting',
///   priority: EventPriority.high,
///   // ...
/// );
/// ```
enum EventPriority {
  /// Low priority event.
  low,

  /// Normal priority event (default).
  normal,

  /// High priority event.
  high,

  /// Urgent priority event requiring immediate attention.
  urgent,
}

/// Status of a calendar event.
///
/// Indicates the current state or confirmation level of an event.
///
/// Example:
/// ```dart
/// final event = CalendarEvent(
///   title: 'Team Meeting',
///   status: EventStatus.confirmed,
///   // ...
/// );
/// ```
enum EventStatus {
  /// Event is confirmed and will happen.
  confirmed,

  /// Event is tentative and may change.
  tentative,

  /// Event has been cancelled.
  cancelled,
}

/// Available calendar view modes.
///
/// Determines how the calendar is displayed to the user.
///
/// Example:
/// ```dart
/// final controller = CalendarController(
///   initialView: CalendarView.month,
/// );
/// ```
enum CalendarView {
  /// Monthly grid view showing all days in a month.
  month,

  /// Weekly view showing 7 days with hourly time slots.
  week,

  /// Single day view with detailed hourly breakdown.
  day,

  /// Yearly overview showing all 12 months.
  year,

  /// List-based agenda view showing upcoming events chronologically.
  agenda,

  /// Timeline view showing events in a horizontal timeline.
  timeline,
}

/// Frequency options for recurring events.
///
/// Defines how often a recurring event repeats.
///
/// Example:
/// ```dart
/// final rule = RecurrenceRule(
///   frequency: RecurrenceFrequency.weekly,
///   interval: 2, // Every 2 weeks
/// );
/// ```
enum RecurrenceFrequency {
  /// Event repeats every day.
  daily,

  /// Event repeats every week.
  weekly,

  /// Event repeats every month.
  monthly,

  /// Event repeats every year.
  yearly,
}

/// Defines how a recurring event series ends.
///
/// Used in conjunction with [RecurrenceRule] to specify when
/// recurring events should stop.
///
/// Example:
/// ```dart
/// final rule = RecurrenceRule(
///   frequency: RecurrenceFrequency.daily,
///   endType: RecurrenceEndType.count,
///   count: 10, // Repeat 10 times
/// );
/// ```
enum RecurrenceEndType {
  /// Recurrence never ends (continues indefinitely).
  never,

  /// Recurrence ends on a specific date.
  until,

  /// Recurrence ends after a specific number of occurrences.
  count,
}

/// First day of the week for calendar display.
///
/// Different regions and cultures start their week on different days.
/// This enum allows customization of the calendar's week start day.
///
/// Example:
/// ```dart
/// final config = CalendarConfig(
///   weekStartDay: WeekStartDay.sunday,
/// );
/// ```
enum WeekStartDay {
  /// Week starts on Monday.
  monday,

  /// Week starts on Tuesday.
  tuesday,

  /// Week starts on Wednesday.
  wednesday,

  /// Week starts on Thursday.
  thursday,

  /// Week starts on Friday.
  friday,

  /// Week starts on Saturday.
  saturday,

  /// Week starts on Sunday.
  sunday,
}

/// Extension methods for [WeekStartDay] enum.
///
/// Provides utility methods for working with week start days.
extension WeekStartDayExtension on WeekStartDay {
  /// Converts the enum value to the corresponding [DateTime] weekday constant.
  ///
  /// Returns:
  /// - [DateTime.monday] for [WeekStartDay.monday]
  /// - [DateTime.tuesday] for [WeekStartDay.tuesday]
  /// - etc.
  ///
  /// Example:
  /// ```dart
  /// final weekStart = WeekStartDay.monday;
  /// final dayValue = weekStart.value; // Returns DateTime.monday (1)
  /// ```
  int get value {
    switch (this) {
      case WeekStartDay.monday:
        return DateTime.monday;
      case WeekStartDay.tuesday:
        return DateTime.tuesday;
      case WeekStartDay.wednesday:
        return DateTime.wednesday;
      case WeekStartDay.thursday:
        return DateTime.thursday;
      case WeekStartDay.friday:
        return DateTime.friday;
      case WeekStartDay.saturday:
        return DateTime.saturday;
      case WeekStartDay.sunday:
        return DateTime.sunday;
    }
  }
}
