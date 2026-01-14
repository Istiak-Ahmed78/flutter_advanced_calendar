import 'package:flutter/material.dart';

import '../utils/date_utils.dart' as calendar_utils;
import 'enums.dart';
import 'recurrence_rule.dart';

/// Calendar event model with full feature support
class CalendarEvent {
  CalendarEvent({
    required this.id,
    required this.title,
    this.description,
    required this.startDate,
    required this.endDate,
    this.isAllDay = false,
    this.color = Colors.blue,
    this.textColor,
    this.dotColor, // NEW
    this.durationDays,
    this.location,
    this.icon,
    this.category,
    this.priority = EventPriority.normal,
    this.status = EventStatus.confirmed,
    this.recurrenceRule,
    this.exceptionDates,
    this.currentDay,
    this.totalDays,
    this.customData,
  }) : assert(
          !endDate.isBefore(startDate),
          'End date must be after or equal to start date',
        );

  /// Create from JSON (safe + backward compatible)
  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    // Helper function to safely read color values
    Color? parseColor(dynamic value) {
      if (value == null) {
        return null;
      }
      if (value is int) {
        return Color(value);
      }
      if (value is String) {
        final intValue = int.tryParse(value);
        if (intValue != null) {
          return Color(intValue);
        }
      }
      return null;
    }

    // Helper function to safely read string values
    String? parseString(dynamic value) {
      if (value == null) {
        return null;
      }
      if (value is String) {
        return value;
      }
      return value.toString();
    }

    // Helper function to safely read bool values
    bool parseBool(dynamic value, {bool defaultValue = false}) {
      if (value is bool) {
        return value;
      }
      if (value is String) {
        return value.toLowerCase() == 'true';
      }
      if (value is int) {
        return value != 0;
      }
      return defaultValue;
    }

    // Helper function to safely read int values
    int? parseInt(dynamic value) {
      if (value == null) {
        return null;
      }
      if (value is int) {
        return value;
      }
      if (value is String) {
        return int.tryParse(value);
      }
      if (value is double) {
        return value.toInt();
      }
      return null;
    }

    // Helper to safely convert dynamic to Map<String, dynamic>
    Map<String, dynamic>? safeMap(dynamic value) {
      if (value == null) {
        return null;
      }
      if (value is Map<String, dynamic>) {
        return value;
      }
      if (value is Map) {
        try {
          return Map<String, dynamic>.from(value);
        } catch (e) {
          return null;
        }
      }
      return null;
    }

    // Helper to safely parse exception dates
    List<DateTime>? parseExceptionDates(dynamic value) {
      if (value == null) {
        return null;
      }
      if (value is List<dynamic>) {
        return value
            .where((d) => d != null)
            .map((d) => DateTime.parse(d.toString()))
            .toList();
      }
      return null;
    }

    return CalendarEvent(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: parseString(json['description']),
      startDate: DateTime.parse(json['startDate'].toString()),
      endDate: DateTime.parse(json['endDate'].toString()),
      isAllDay: parseBool(json['isAllDay']),
      color: parseColor(json['color']) ?? Colors.blue,
      textColor: parseColor(json['textColor']),
      dotColor: parseColor(json['dotColor']),
      durationDays: parseInt(json['durationDays']),
      location: parseString(json['location']),
      category: parseString(json['category']),
      priority: EventPriority.values.firstWhere(
        (e) => e.name == json['priority']?.toString(),
        orElse: () => EventPriority.normal,
      ),
      status: EventStatus.values.firstWhere(
        (e) => e.name == json['status']?.toString(),
        orElse: () => EventStatus.confirmed,
      ),
      recurrenceRule: json['recurrenceRule'] != null
          ? RecurrenceRule.fromJson(
              safeMap(json['recurrenceRule']) ?? {},
            )
          : null,
      exceptionDates: parseExceptionDates(json['exceptionDates']),
      currentDay: parseInt(json['currentDay']),
      totalDays: parseInt(json['totalDays']),
      customData: safeMap(json['customData']),
    );
  }

  /// Create range event (today + N days)
  factory CalendarEvent.withDuration({
    required String id,
    required String title,
    required DateTime startDate,
    required int durationDays,
    String? description,
    Color color = Colors.blue,
    Color? textColor,
    Color? dotColor, // NEW
    String? location,
    IconData? icon,
    String? category,
    EventPriority priority = EventPriority.normal,
    EventStatus status = EventStatus.confirmed,
    Map<String, dynamic>? customData,
  }) =>
      CalendarEvent(
        id: id,
        title: title,
        description: description,
        startDate: startDate,
        endDate: startDate.add(Duration(days: durationDays)),
        durationDays: durationDays,
        color: color,
        textColor: textColor,
        dotColor: dotColor, // NEW
        isAllDay: true,
        location: location,
        icon: icon,
        category: category,
        priority: priority,
        status: status,
        customData: customData,
      );
  final String id;
  final String title;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final bool isAllDay;

  // Individual event colors
  final Color color;
  final Color? textColor;
  final Color? dotColor; // NEW: Individual dot color for event indicators

  // Range events (today + N days)
  final int? durationDays;

  // Metadata
  final String? location;
  final IconData? icon;
  final String? category;
  final EventPriority priority;
  final EventStatus status;

  // Recurrence
  final RecurrenceRule? recurrenceRule;
  final List<DateTime>? exceptionDates;

  // Day counter (Day 3/7)
  final int? currentDay;
  final int? totalDays;

  // Custom data
  final Map<String, dynamic>? customData;

  /// Get the effective dot color (uses dotColor if set, otherwise uses event color)
  Color get effectiveDotColor => dotColor ?? color;

  /// Check if event spans multiple days
  bool get isMultiDay =>
      !calendar_utils.isSameDay(startDate, endDate) && isAllDay;

  /// Get all dates this event covers
  List<DateTime> get dateRange =>
      calendar_utils.getDateRange(startDate, endDate);

  /// Calculate current day in multi-day event
  int? getCurrentDay(DateTime date) {
    if (!isMultiDay) {
      return null;
    }

    final index =
        dateRange.indexWhere((d) => calendar_utils.isSameDay(d, date));

    return index >= 0 ? index + 1 : null;
  }

  /// Get total days in multi-day event
  int get getTotalDays => isMultiDay ? dateRange.length : 1;

  /// Check if event occurs on a specific date
  bool occursOnDate(DateTime date) {
    if (exceptionDates?.any(
          (e) => calendar_utils.isSameDay(e, date),
        ) ==
        true) {
      return false;
    }

    if (dateRange.any((d) => calendar_utils.isSameDay(d, date))) {
      return true;
    }

    if (recurrenceRule != null) {
      final occurrences = recurrenceRule!.generateOccurrences(
        startDate,
        date,
        date.add(const Duration(days: 1)),
      );
      return occurrences.isNotEmpty;
    }

    return false;
  }

  /// Duration helpers
  double get durationInHours => endDate.difference(startDate).inMinutes / 60.0;

  int get durationInMinutes => endDate.difference(startDate).inMinutes;

  bool get isHappening {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }

  bool get isPast => endDate.isBefore(DateTime.now());

  bool get isFuture => startDate.isAfter(DateTime.now());

  bool get isCancelled => status == EventStatus.cancelled;

  bool get isTentative => status == EventStatus.tentative;

  /// Copy with
  CalendarEvent copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    bool? isAllDay,
    Color? color,
    Color? textColor,
    Color? dotColor, // NEW
    int? durationDays,
    String? location,
    IconData? icon,
    String? category,
    EventPriority? priority,
    EventStatus? status,
    RecurrenceRule? recurrenceRule,
    List<DateTime>? exceptionDates,
    int? currentDay,
    int? totalDays,
    Map<String, dynamic>? customData,
  }) =>
      CalendarEvent(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        isAllDay: isAllDay ?? this.isAllDay,
        color: color ?? this.color,
        textColor: textColor ?? this.textColor,
        dotColor: dotColor ?? this.dotColor, // NEW
        durationDays: durationDays ?? this.durationDays,
        location: location ?? this.location,
        icon: icon ?? this.icon,
        category: category ?? this.category,
        priority: priority ?? this.priority,
        status: status ?? this.status,
        recurrenceRule: recurrenceRule ?? this.recurrenceRule,
        exceptionDates: exceptionDates ?? this.exceptionDates,
        currentDay: currentDay ?? this.currentDay,
        totalDays: totalDays ?? this.totalDays,
        customData: customData ?? this.customData,
      );

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'isAllDay': isAllDay,
        'color': color.toARGB32(), // FIXED
        'textColor': textColor?.toARGB32(), // FIXED
        'dotColor': dotColor?.toARGB32(), // FIXED
        'durationDays': durationDays,
        'location': location,
        'category': category,
        'priority': priority.name,
        'status': status.name,
        'recurrenceRule': recurrenceRule?.toJson(),
        'exceptionDates':
            exceptionDates?.map((d) => d.toIso8601String()).toList(),
        'currentDay': currentDay,
        'totalDays': totalDays,
        'customData': customData,
      };

  @override
  String toString() =>
      'CalendarEvent(id: $id, title: $title, start: $startDate, end: $endDate)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarEvent &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
