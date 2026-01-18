import 'package:flutter/material.dart';

import '../utils/date_utils.dart' as calendar_utils;
import 'enums.dart';
import 'recurrence_rule.dart';

/// Represents a calendar event with comprehensive feature support.
///
/// This model supports:
/// - Single and multi-day events
/// - All-day and timed events
/// - Custom colors and icons
/// - Event recurrence patterns
/// - Priority and status tracking
/// - Custom metadata storage
///
/// Example:
/// ```dart
/// final event = CalendarEvent(
///   id: '1',
///   title: 'Team Meeting',
///   startDate: DateTime(2024, 1, 15, 9, 0),
///   endDate: DateTime(2024, 1, 15, 10, 0),
///   color: Colors.blue,
///   location: 'Conference Room A',
///   category: 'work',
/// );
/// ```
class CalendarEvent {
  /// Creates a calendar event.
  ///
  /// [id] - Unique identifier for the event.
  /// [title] - The event title/name.
  /// [startDate] - When the event starts.
  /// [endDate] - When the event ends. Must be after or equal to [startDate].
  /// [isAllDay] - Whether this is an all-day event. Defaults to false.
  /// [color] - The event's display color. Defaults to blue.
  /// [textColor] - Optional custom text color for the event.
  /// [dotColor] - Optional custom color for event indicator dots.
  /// [durationDays] - For multi-day events, the number of days.
  /// [location] - Where the event takes place.
  /// [icon] - Optional icon to display with the event.
  /// [category] - Event category/type for filtering and grouping.
  /// [priority] - Event priority level. Defaults to normal.
  /// [status] - Event status (confirmed, tentative, cancelled). Defaults to confirmed.
  /// [recurrenceRule] - Optional rule for recurring events.
  /// [exceptionDates] - Dates to exclude from recurring events.
  /// [currentDay] - For multi-day events, which day this instance represents.
  /// [totalDays] - For multi-day events, the total number of days.
  /// [customData] - Optional custom metadata storage.
  CalendarEvent({
    required this.id,
    required this.title,
    this.description,
    required this.startDate,
    required this.endDate,
    this.isAllDay = false,
    this.color = Colors.blue,
    this.textColor,
    this.dotColor,
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

  /// Creates an event from JSON data.
  ///
  /// This factory constructor safely handles various data types and provides
  /// backward compatibility with different JSON formats.
  ///
  /// Example:
  /// ```dart
  /// final event = CalendarEvent.fromJson({
  ///   'id': '1',
  ///   'title': 'Meeting',
  ///   'startDate': '2024-01-15T09:00:00.000',
  ///   'endDate': '2024-01-15T10:00:00.000',
  /// });
  /// ```
  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
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

    String? parseString(dynamic value) {
      if (value == null) {
        return null;
      }
      if (value is String) {
        return value;
      }
      return value.toString();
    }

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

  /// Creates a multi-day event with a specified duration.
  ///
  /// This is a convenience factory for creating events that span multiple days.
  ///
  /// [id] - Unique identifier for the event.
  /// [title] - The event title.
  /// [startDate] - When the event starts.
  /// [durationDays] - How many days the event lasts.
  /// [description] - Optional event description.
  /// [color] - Event color. Defaults to blue.
  /// [textColor] - Optional custom text color.
  /// [dotColor] - Optional custom dot indicator color.
  /// [location] - Where the event takes place.
  /// [icon] - Optional icon to display.
  /// [category] - Event category/type.
  /// [priority] - Event priority. Defaults to normal.
  /// [status] - Event status. Defaults to confirmed.
  /// [customData] - Optional custom metadata.
  ///
  /// Example:
  /// ```dart
  /// final conference = CalendarEvent.withDuration(
  ///   id: '1',
  ///   title: 'Tech Conference',
  ///   startDate: DateTime(2024, 6, 1),
  ///   durationDays: 3,
  ///   color: Colors.purple,
  /// );
  /// ```
  factory CalendarEvent.withDuration({
    required String id,
    required String title,
    required DateTime startDate,
    required int durationDays,
    String? description,
    Color color = Colors.blue,
    Color? textColor,
    Color? dotColor,
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
        dotColor: dotColor,
        isAllDay: true,
        location: location,
        icon: icon,
        category: category,
        priority: priority,
        status: status,
        customData: customData,
      );

  /// Unique identifier for this event.
  final String id;

  /// The event title/name.
  final String title;

  /// Optional detailed description of the event.
  final String? description;

  /// When the event starts.
  final DateTime startDate;

  /// When the event ends.
  final DateTime endDate;

  /// Whether this is an all-day event (no specific time).
  final bool isAllDay;

  /// The primary color used to display this event.
  final Color color;

  /// Optional custom text color for the event.
  final Color? textColor;

  /// Optional custom color for event indicator dots in month view.
  final Color? dotColor;

  /// For multi-day events, the number of days the event spans.
  final int? durationDays;

  /// Where the event takes place.
  final String? location;

  /// Optional icon to display with the event.
  final IconData? icon;

  /// Event category/type for filtering and grouping.
  final String? category;

  /// Priority level of the event.
  final EventPriority priority;

  /// Current status of the event.
  final EventStatus status;

  /// Optional recurrence pattern for repeating events.
  final RecurrenceRule? recurrenceRule;

  /// Dates to exclude from recurring events.
  final List<DateTime>? exceptionDates;

  /// For multi-day events, which day this instance represents (1-based).
  final int? currentDay;

  /// For multi-day events, the total number of days.
  final int? totalDays;

  /// Custom metadata storage for application-specific data.
  final Map<String, dynamic>? customData;

  /// Gets the effective dot color, falling back to the event color if not set.
  Color get effectiveDotColor => dotColor ?? color;

  /// Whether this event spans multiple days.
  bool get isMultiDay =>
      !calendar_utils.isSameDay(startDate, endDate) && isAllDay;

  /// Gets all dates this event covers as a list.
  List<DateTime> get dateRange =>
      calendar_utils.getDateRange(startDate, endDate);

  /// Calculates which day of a multi-day event the given date represents.
  ///
  /// [date] - The date to check.
  ///
  /// Returns the day number (1-based) or null if the date is not in this event.
  int? getCurrentDay(DateTime date) {
    if (!isMultiDay) {
      return null;
    }

    final index =
        dateRange.indexWhere((d) => calendar_utils.isSameDay(d, date));

    return index >= 0 ? index + 1 : null;
  }

  /// Gets the total number of days this event spans.
  int get getTotalDays => isMultiDay ? dateRange.length : 1;

  /// Checks if this event occurs on a specific date.
  ///
  /// Takes into account:
  /// - Multi-day events
  /// - Recurring events
  /// - Exception dates
  ///
  /// [date] - The date to check.
  ///
  /// Returns true if the event occurs on this date.
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

  /// Gets the event duration in hours.
  double get durationInHours => endDate.difference(startDate).inMinutes / 60.0;

  /// Gets the event duration in minutes.
  int get durationInMinutes => endDate.difference(startDate).inMinutes;

  /// Whether the event is currently happening.
  bool get isHappening {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }

  /// Whether the event has already ended.
  bool get isPast => endDate.isBefore(DateTime.now());

  /// Whether the event is in the future.
  bool get isFuture => startDate.isAfter(DateTime.now());

  /// Whether the event has been cancelled.
  bool get isCancelled => status == EventStatus.cancelled;

  /// Whether the event is tentative (not confirmed).
  bool get isTentative => status == EventStatus.tentative;

  /// Creates a copy of this event with the given fields replaced.
  ///
  /// This is useful for updating events without modifying the original.
  ///
  /// Example:
  /// ```dart
  /// final updatedEvent = event.copyWith(
  ///   title: 'Updated Meeting',
  ///   color: Colors.red,
  /// );
  /// ```
  CalendarEvent copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    bool? isAllDay,
    Color? color,
    Color? textColor,
    Color? dotColor,
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
        dotColor: dotColor ?? this.dotColor,
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

  /// Converts this event to a JSON map.
  ///
  /// Useful for serialization and storage.
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'isAllDay': isAllDay,
        'color': color.toARGB32(),
        'textColor': textColor?.toARGB32(),
        'dotColor': dotColor?.toARGB32(),
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
