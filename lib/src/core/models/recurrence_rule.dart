import 'enums.dart';

/// Recurrence end condition
class RecurrenceEnd {
  RecurrenceEnd.count(this.count)
      : type = RecurrenceEndType.count,
        until = null;

  RecurrenceEnd.never()
      : type = RecurrenceEndType.never,
        until = null,
        count = null;

  RecurrenceEnd.until(this.until)
      : type = RecurrenceEndType.until,
        count = null;

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

  final RecurrenceEndType type;
  final DateTime? until;
  final int? count;

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

/// Recurrence rule for repeating events
class RecurrenceRule {
  RecurrenceRule({
    required this.frequency,
    this.interval = 1,
    this.byWeekDay,
    this.byMonthDay,
    this.byMonth,
    this.endCondition,
  }) : assert(interval > 0, 'Interval must be greater than 0');

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

  final RecurrenceFrequency frequency;
  final int interval;
  final List<int>? byWeekDay; // 1=Monday, 7=Sunday
  final List<int>? byMonthDay; // 1-31
  final List<int>? byMonth; // 1-12
  final RecurrenceEnd? endCondition;

  /// Generate occurrences within a date range
  List<DateTime> generateOccurrences(
    DateTime start,
    DateTime rangeStart,
    DateTime rangeEnd,
  ) {
    final occurrences = <DateTime>[];
    var current = start;
    var count = 0;

    // Safety limit to prevent infinite loops
    const maxOccurrences = 1000;

    while (current.isBefore(rangeEnd) && count < maxOccurrences) {
      // Check end condition
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

      // Add if in range and matches all conditions
      if (!current.isBefore(rangeStart) && _matchesConditions(current)) {
        occurrences.add(current);
      }

      // Calculate next occurrence
      current = _getNextOccurrence(current);
      count++;
    }

    return occurrences;
  }

  /// Check if date matches all recurrence conditions
  bool _matchesConditions(DateTime date) {
    // Check byWeekDay
    if (byWeekDay != null && byWeekDay!.isNotEmpty) {
      if (!byWeekDay!.contains(date.weekday)) {
        return false;
      }
    }

    // Check byMonthDay
    if (byMonthDay != null && byMonthDay!.isNotEmpty) {
      if (!byMonthDay!.contains(date.day)) {
        return false;
      }
    }

    // Check byMonth
    if (byMonth != null && byMonth!.isNotEmpty) {
      if (!byMonth!.contains(date.month)) {
        return false;
      }
    }

    return true;
  }

  /// Calculate next occurrence based on frequency
  DateTime _getNextOccurrence(DateTime current) {
    switch (frequency) {
      case RecurrenceFrequency.daily:
        return current.add(Duration(days: interval));

      case RecurrenceFrequency.weekly:
        if (byWeekDay != null && byWeekDay!.isNotEmpty) {
          // Find next matching weekday
          var next = current.add(const Duration(days: 1));
          var daysChecked = 0;
          const maxDays = 7 * 4; // Check up to 4 weeks

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

        // Handle day overflow (e.g., Jan 31 -> Feb 31 = Feb 28/29)
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

  /// Convert to RRULE string (RFC 5545)
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

  String _weekDayToRRule(int weekday) {
    const days = ['MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU'];
    return days[weekday - 1];
  }

  String _formatRRuleDate(DateTime date) =>
      '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}T'
      '${date.hour.toString().padLeft(2, '0')}${date.minute.toString().padLeft(2, '0')}${date.second.toString().padLeft(2, '0')}Z';

  Map<String, dynamic> toJson() => {
        'frequency': frequency.name,
        'interval': interval,
        'byWeekDay': byWeekDay,
        'byMonthDay': byMonthDay,
        'byMonth': byMonth,
        'endCondition': endCondition?.toJson(),
      };

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

  String _formatWeekDays() {
    if (byWeekDay == null || byWeekDay!.isEmpty) {
      return '';
    }

    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return byWeekDay!.map((day) => dayNames[day - 1]).join(', ');
  }
}
