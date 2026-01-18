import 'enums.dart';

/// Defines when a recurring event series should end.
///
/// Supports three types of end conditions:
/// - Never ending (continues indefinitely)
/// - Until a specific date
/// - After a specific number of occurrences
///
/// Example:
/// ```dart
/// // Never ending
/// final neverEnd = RecurrenceEnd.never();
///
/// // End on a specific date
/// final untilEnd = RecurrenceEnd.until(DateTime(2024, 12, 31));
///
/// // End after 10 occurrences
/// final countEnd = RecurrenceEnd.count(10);
/// ```
class RecurrenceEnd {
  /// Creates a recurrence end condition based on occurrence count.
  ///
  /// [count] - The number of times the event should occur before ending.
  ///
  /// Example:
  /// ```dart
  /// final end = RecurrenceEnd.count(5); // Repeat 5 times
  /// ```
  RecurrenceEnd.count(this.count)
      : type = RecurrenceEndType.count,
        until = null;

  /// Creates a recurrence that never ends.
  ///
  /// The event will continue repeating indefinitely.
  ///
  /// Example:
  /// ```dart
  /// final end = RecurrenceEnd.never();
  /// ```
  RecurrenceEnd.never()
      : type = RecurrenceEndType.never,
        until = null,
        count = null;

  /// Creates a recurrence end condition based on a specific date.
  ///
  /// [until] - The date when the recurrence should stop.
  ///
  /// Example:
  /// ```dart
  /// final end = RecurrenceEnd.until(DateTime(2024, 12, 31));
  /// ```
  RecurrenceEnd.until(this.until)
      : type = RecurrenceEndType.until,
        count = null;

  /// Creates a recurrence end condition from JSON data.
  ///
  /// Safely handles various data formats and provides fallback values.
  factory RecurrenceEnd.fromJson(Map<String, dynamic> json) {
    final typeString = json['type']?.toString() ?? 'never';
    final type = RecurrenceEndType.values.firstWhere(
      (e) => e.name == typeString,
      orElse: () => RecurrenceEndType.never,
    );

    switch (type) {
      case RecurrenceEndType.never:
        return RecurrenceEnd.never();
      case RecurrenceEndType.until:
        final untilString = json['until']?.toString();
        return RecurrenceEnd.until(
          untilString != null ? DateTime.parse(untilString) : DateTime.now(),
        );
      case RecurrenceEndType.count:
        final count = json['count'] is int
            ? json['count'] as int
            : json['count'] is String
                ? int.tryParse(json['count'] as String) ?? 1
                : 1;
        return RecurrenceEnd.count(count);
    }
  }

  /// The type of end condition.
  final RecurrenceEndType type;

  /// The date when recurrence ends (only for [RecurrenceEndType.until]).
  final DateTime? until;

  /// The number of occurrences before ending (only for [RecurrenceEndType.count]).
  final int? count;

  /// Converts this end condition to a JSON map.
  Map<String, dynamic> toJson() => {
        'type': type.name,
        'until': until?.toIso8601String(),
        'count': count,
      };

  @override
  String toString() {
    switch (type) {
      case RecurrenceEndType.never:
        return 'Never ends';
      case RecurrenceEndType.until:
        return 'Until ${until?.toIso8601String()}';
      case RecurrenceEndType.count:
        return 'After $count occurrences';
    }
  }
}

/// Defines a recurrence pattern for repeating events.
///
/// Supports complex recurrence rules including:
/// - Daily, weekly, monthly, and yearly frequencies
/// - Custom intervals (e.g., every 2 weeks)
/// - Specific days of the week
/// - Specific days of the month
/// - Specific months
/// - End conditions (never, until date, or after count)
///
/// Example:
/// ```dart
/// // Every weekday (Monday-Friday)
/// final weekdayRule = RecurrenceRule(
///   frequency: RecurrenceFrequency.weekly,
///   byWeekDay: [1, 2, 3, 4, 5], // Mon-Fri
/// );
///
/// // Every 2 weeks on Monday and Wednesday, 10 times
/// final customRule = RecurrenceRule(
///   frequency: RecurrenceFrequency.weekly,
///   interval: 2,
///   byWeekDay: [1, 3], // Monday and Wednesday
///   endCondition: RecurrenceEnd.count(10),
/// );
/// ```
class RecurrenceRule {
  /// Creates a recurrence rule.
  ///
  /// [frequency] - How often the event repeats (daily, weekly, monthly, yearly).
  /// [interval] - The interval between occurrences. Must be greater than 0. Defaults to 1.
  /// [byWeekDay] - List of weekdays when the event occurs (1=Monday, 7=Sunday).
  /// [byMonthDay] - List of days of the month when the event occurs (1-31).
  /// [byMonth] - List of months when the event occurs (1-12).
  /// [endCondition] - When the recurrence should end.
  ///
  /// Example:
  /// ```dart
  /// final rule = RecurrenceRule(
  ///   frequency: RecurrenceFrequency.weekly,
  ///   interval: 2,
  ///   byWeekDay: [1, 3, 5], // Mon, Wed, Fri
  /// );
  /// ```
  RecurrenceRule({
    required this.frequency,
    this.interval = 1,
    this.byWeekDay,
    this.byMonthDay,
    this.byMonth,
    this.endCondition,
  }) : assert(interval > 0, 'Interval must be greater than 0');

  /// Creates a recurrence rule from JSON data.
  ///
  /// Safely handles various data formats and provides fallback values.
  factory RecurrenceRule.fromJson(Map<String, dynamic> json) => RecurrenceRule(
        frequency: RecurrenceFrequency.values.firstWhere(
          (e) => e.name == (json['frequency']?.toString() ?? 'daily'),
          orElse: () => RecurrenceFrequency.daily,
        ),
        interval: (json['interval'] is int)
            ? json['interval'] as int
            : (json['interval'] is String)
                ? int.tryParse(json['interval'] as String) ?? 1
                : 1,
        byWeekDay: json['byWeekDay'] is List
            ? List<int>.from(json['byWeekDay'] as List)
            : null,
        byMonthDay: json['byMonthDay'] is List
            ? List<int>.from(json['byMonthDay'] as List)
            : null,
        byMonth: json['byMonth'] is List
            ? List<int>.from(json['byMonth'] as List)
            : null,
        endCondition: json['endCondition'] != null
            ? RecurrenceEnd.fromJson(
                json['endCondition'] is Map<String, dynamic>
                    ? json['endCondition'] as Map<String, dynamic>
                    : Map<String, dynamic>.from(json['endCondition'] as Map))
            : null,
      );

  /// How often the event repeats.
  final RecurrenceFrequency frequency;

  /// The interval between occurrences (e.g., 2 for "every 2 weeks").
  final int interval;

  /// List of weekdays when the event occurs (1=Monday, 7=Sunday).
  ///
  /// Only applicable for weekly frequency.
  final List<int>? byWeekDay;

  /// List of days of the month when the event occurs (1-31).
  ///
  /// Only applicable for monthly frequency.
  final List<int>? byMonthDay;

  /// List of months when the event occurs (1-12).
  ///
  /// Can be used with any frequency to limit occurrences to specific months.
  final List<int>? byMonth;

  /// When the recurrence should end.
  final RecurrenceEnd? endCondition;

  /// Generates all event occurrences within a date range.
  ///
  /// [start] - The start date of the recurring event.
  /// [rangeStart] - The beginning of the date range to generate occurrences for.
  /// [rangeEnd] - The end of the date range to generate occurrences for.
  ///
  /// Returns a list of DateTime objects representing each occurrence.
  ///
  /// Example:
  /// ```dart
  /// final rule = RecurrenceRule(
  ///   frequency: RecurrenceFrequency.daily,
  ///   endCondition: RecurrenceEnd.count(5),
  /// );
  /// final occurrences = rule.generateOccurrences(
  ///   DateTime(2024, 1, 1),
  ///   DateTime(2024, 1, 1),
  ///   DateTime(2024, 1, 31),
  /// );
  /// ```
  List<DateTime> generateOccurrences(
    DateTime start,
    DateTime rangeStart,
    DateTime rangeEnd,
  ) {
    final occurrences = <DateTime>[];
    var current = start;
    var count = 0;

    const maxOccurrences = 1000;

    while (current.isBefore(rangeEnd) && count < maxOccurrences) {
      if (endCondition != null) {
        if (endCondition!.type == RecurrenceEndType.until &&
            current.isAfter(endCondition!.until!)) {
          break;
        }
        if (endCondition!.type == RecurrenceEndType.count &&
            count >= endCondition!.count!) {
          break;
        }
      }

      if (!current.isBefore(rangeStart) && _matchesConditions(current)) {
        occurrences.add(current);
      }

      current = _getNextOccurrence(current);
      count++;
    }

    return occurrences;
  }

  /// Checks if a date matches all recurrence conditions.
  ///
  /// [date] - The date to check.
  ///
  /// Returns true if the date satisfies all specified conditions.
  bool _matchesConditions(DateTime date) {
    if (byWeekDay != null && byWeekDay!.isNotEmpty) {
      if (!byWeekDay!.contains(date.weekday)) {
        return false;
      }
    }

    if (byMonthDay != null && byMonthDay!.isNotEmpty) {
      if (!byMonthDay!.contains(date.day)) {
        return false;
      }
    }

    if (byMonth != null && byMonth!.isNotEmpty) {
      if (!byMonth!.contains(date.month)) {
        return false;
      }
    }

    return true;
  }

  /// Calculates the next occurrence based on the frequency and interval.
  ///
  /// [current] - The current occurrence date.
  ///
  /// Returns the next occurrence date.
  DateTime _getNextOccurrence(DateTime current) {
    switch (frequency) {
      case RecurrenceFrequency.daily:
        return current.add(Duration(days: interval));

      case RecurrenceFrequency.weekly:
        if (byWeekDay != null && byWeekDay!.isNotEmpty) {
          var next = current.add(const Duration(days: 1));
          var daysChecked = 0;
          const maxDays = 7 * 4;

          while (daysChecked < maxDays) {
            if (byWeekDay!.contains(next.weekday)) {
              return next;
            }
            next = next.add(const Duration(days: 1));
            daysChecked++;
          }
          return next;
        }
        return current.add(Duration(days: 7 * interval));

      case RecurrenceFrequency.monthly:
        var newYear = current.year;
        var newMonth = current.month + interval;

        while (newMonth > 12) {
          newMonth -= 12;
          newYear++;
        }

        var newDay = current.day;
        if (byMonthDay != null && byMonthDay!.isNotEmpty) {
          newDay = byMonthDay!.first;
        }

        final daysInNewMonth = DateTime(newYear, newMonth + 1, 0).day;
        if (newDay > daysInNewMonth) {
          newDay = daysInNewMonth;
        }

        return DateTime(
          newYear,
          newMonth,
          newDay,
          current.hour,
          current.minute,
          current.second,
        );

      case RecurrenceFrequency.yearly:
        return DateTime(
          current.year + interval,
          current.month,
          current.day,
          current.hour,
          current.minute,
          current.second,
        );
    }
  }

  /// Converts this recurrence rule to an RRULE string (RFC 5545 format).
  ///
  /// Returns a string in the iCalendar RRULE format.
  ///
  /// Example output: "FREQ=WEEKLY;INTERVAL=2;BYDAY=MO,WE,FR;COUNT=10"
  String toRRule() {
    final buffer = StringBuffer('FREQ=${frequency.name.toUpperCase()}');

    if (interval > 1) {
      buffer.write(';INTERVAL=$interval');
    }

    if (byWeekDay != null && byWeekDay!.isNotEmpty) {
      final days = byWeekDay!.map(_weekDayToRRule).join(',');
      buffer.write(';BYDAY=$days');
    }

    if (byMonthDay != null && byMonthDay!.isNotEmpty) {
      buffer.write(';BYMONTHDAY=${byMonthDay!.join(',')}');
    }

    if (byMonth != null && byMonth!.isNotEmpty) {
      buffer.write(';BYMONTH=${byMonth!.join(',')}');
    }

    if (endCondition != null) {
      if (endCondition!.type == RecurrenceEndType.until) {
        buffer.write(';UNTIL=${_formatRRuleDate(endCondition!.until!)}');
      } else if (endCondition!.type == RecurrenceEndType.count) {
        buffer.write(';COUNT=${endCondition!.count}');
      }
    }

    return buffer.toString();
  }

  /// Converts a weekday number to RRULE format.
  String _weekDayToRRule(int weekday) {
    const days = ['MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU'];
    return days[weekday - 1];
  }

  /// Formats a DateTime to RRULE date format.
  String _formatRRuleDate(DateTime date) =>
      '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}T'
      '${date.hour.toString().padLeft(2, '0')}${date.minute.toString().padLeft(2, '0')}${date.second.toString().padLeft(2, '0')}Z';

  /// Converts this recurrence rule to a JSON map.
  Map<String, dynamic> toJson() => {
        'frequency': frequency.name,
        'interval': interval,
        'byWeekDay': byWeekDay,
        'byMonthDay': byMonthDay,
        'byMonth': byMonth,
        'endCondition': endCondition?.toJson(),
      };

  /// Creates a copy of this recurrence rule with the given fields replaced.
  ///
  /// Example:
  /// ```dart
  /// final newRule = rule.copyWith(
  ///   interval: 2,
  ///   endCondition: RecurrenceEnd.count(5),
  /// );
  /// ```
  RecurrenceRule copyWith({
    RecurrenceFrequency? frequency,
    int? interval,
    List<int>? byWeekDay,
    List<int>? byMonthDay,
    List<int>? byMonth,
    RecurrenceEnd? endCondition,
  }) =>
      RecurrenceRule(
        frequency: frequency ?? this.frequency,
        interval: interval ?? this.interval,
        byWeekDay: byWeekDay ?? this.byWeekDay,
        byMonthDay: byMonthDay ?? this.byMonthDay,
        byMonth: byMonth ?? this.byMonth,
        endCondition: endCondition ?? this.endCondition,
      );

  @override
  String toString() {
    final buffer = StringBuffer();

    switch (frequency) {
      case RecurrenceFrequency.daily:
        buffer.write(interval == 1 ? 'Daily' : 'Every $interval days');
        break;
      case RecurrenceFrequency.weekly:
        buffer.write(interval == 1 ? 'Weekly' : 'Every $interval weeks');
        if (byWeekDay != null && byWeekDay!.isNotEmpty) {
          buffer.write(' on ${_formatWeekDays()}');
        }
        break;
      case RecurrenceFrequency.monthly:
        buffer.write(interval == 1 ? 'Monthly' : 'Every $interval months');
        break;
      case RecurrenceFrequency.yearly:
        buffer.write(interval == 1 ? 'Yearly' : 'Every $interval years');
        break;
    }

    if (endCondition != null) {
      buffer.write(', $endCondition');
    }

    return buffer.toString();
  }

  /// Formats the list of weekdays as a human-readable string.
  String _formatWeekDays() {
    if (byWeekDay == null || byWeekDay!.isEmpty) {
      return '';
    }

    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return byWeekDay!.map((day) => dayNames[day - 1]).join(', ');
  }
}
