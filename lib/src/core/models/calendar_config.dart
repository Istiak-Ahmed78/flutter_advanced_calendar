import 'package:flutter/material.dart';
import 'enums.dart';

/// Configuration for calendar behavior and appearance.
///
/// This class controls all aspects of calendar functionality including:
/// - View settings (initial view, week numbers, week start day)
/// - Date constraints (min/max dates)
/// - Feature flags (range selection, multi-day events, etc.)
/// - Display settings (time format, event display options)
/// - Interaction settings (gestures, animations)
/// - Holiday management
///
/// Example:
/// ```dart
/// final config = CalendarConfig(
///   initialView: CalendarView.month,
///   weekStartDay: WeekStartDay.monday,
///   show24HourFormat: true,
///   enableRangeSelection: true,
///   holidays: [DateTime(2024, 1, 1), DateTime(2024, 12, 25)],
/// );
/// ```
class CalendarConfig {
  /// Creates a calendar configuration.
  ///
  /// All parameters are optional and have sensible defaults.
  const CalendarConfig({
    this.initialView = CalendarView.month,
    this.showWeekNumbers = false,
    this.weekStartDay = WeekStartDay.monday,
    this.minDate,
    this.maxDate,
    this.enableRangeSelection = false,
    this.enableMultiDayEvents = true,
    this.hideWeekends = false,
    this.showHolidays = true,
    this.enableVerticalScroll = false,
    this.allowSameDayRange = true,
    this.enableSwipeNavigation = true,
    this.enableDragAndDrop = false,
    this.show24HourFormat = true,
    this.showEventTime = true,
    this.showEventLocation = false,
    this.showEventIcon = true,
    this.maxEventsPerDay = 3,
    this.compactMode = false,
    this.showEventDots = true,
    this.maxEventDotsPerDay = 3,
    this.enableLongPress = true,
    this.enableDoubleTap = false,
    this.animationDuration = const Duration(milliseconds: 300),
    this.locale,
    this.holidays = const [],
    this.holidayNames = const {},
  });

  // ==================== View Settings ====================

  /// The initial view to display when the calendar is first shown.
  ///
  /// Defaults to [CalendarView.month].
  final CalendarView initialView;

  /// Whether to show week numbers in the calendar.
  ///
  /// When true, displays the ISO week number on the left side of each week row.
  /// Defaults to false.
  final bool showWeekNumbers;

  /// The first day of the week.
  ///
  /// Use [WeekStartDay.monday] or [WeekStartDay.sunday].
  /// Defaults to [WeekStartDay.monday].
  final WeekStartDay weekStartDay;

  // ==================== Date Constraints ====================

  /// The minimum selectable date.
  ///
  /// Users cannot navigate to or select dates before this date.
  /// If null, there is no minimum date constraint.
  final DateTime? minDate;

  /// The maximum selectable date.
  ///
  /// Users cannot navigate to or select dates after this date.
  /// If null, there is no maximum date constraint.
  final DateTime? maxDate;

  // ==================== Feature Flags ====================

  /// Whether to enable date range selection.
  ///
  /// When true, users can select a start and end date to create a range.
  /// Defaults to false.
  final bool enableRangeSelection;

  /// Whether to enable multi-day events.
  ///
  /// When true, events can span multiple days and will be displayed accordingly.
  /// Defaults to true.
  final bool enableMultiDayEvents;

  /// Whether to hide weekends (Saturday and Sunday) from the calendar.
  ///
  /// When true, the calendar will only show weekdays.
  /// Defaults to false.
  final bool hideWeekends;

  /// Whether to visually highlight holidays in the calendar.
  ///
  /// Defaults to true.
  final bool showHolidays;

  /// Whether to enable vertical scrolling in table calendar view.
  ///
  /// When true, the calendar can be scrolled vertically to view more weeks.
  /// Defaults to false.
  final bool enableVerticalScroll;

  /// Whether to allow selecting the same day as both start and end in range selection.
  ///
  /// When true, users can create a single-day range.
  /// Defaults to true.
  final bool allowSameDayRange;

  /// Whether to enable swipe gestures for navigation.
  ///
  /// When true, users can swipe left/right to navigate between months/weeks.
  /// Defaults to true.
  final bool enableSwipeNavigation;

  /// Whether to enable drag-and-drop functionality for events.
  ///
  /// When true, events can be dragged to different dates/times.
  /// Defaults to false.
  final bool enableDragAndDrop;

  // ==================== Display Settings ====================

  /// Whether to use 24-hour time format.
  ///
  /// When true, displays times as "14:00".
  /// When false, displays times as "2:00 PM".
  /// Defaults to true.
  final bool show24HourFormat;

  /// Whether to show event times in the calendar.
  ///
  /// Defaults to true.
  final bool showEventTime;

  /// Whether to show event locations in the calendar.
  ///
  /// Defaults to false.
  final bool showEventLocation;

  /// Whether to show event icons in the calendar.
  ///
  /// Defaults to true.
  final bool showEventIcon;

  /// Maximum number of events to display per day in month view.
  ///
  /// Additional events will be indicated with a "+X more" label.
  /// Defaults to 3.
  final int maxEventsPerDay;

  /// Whether to use compact mode for the calendar.
  ///
  /// In compact mode, spacing and padding are reduced to fit more content.
  /// Defaults to false.
  final bool compactMode;

  /// Whether to show colored dots for events in month view.
  ///
  /// When true, displays small colored dots below the date number to indicate events.
  /// Defaults to true.
  final bool showEventDots;

  /// Maximum number of event dots to show per day.
  ///
  /// If there are more events than this number, the remaining events are not shown as dots.
  /// Defaults to 3.
  final int maxEventDotsPerDay;

  // ==================== Interaction Settings ====================

  /// Whether to enable long-press gestures.
  ///
  /// When true, long-pressing on a date or event triggers callbacks.
  /// Defaults to true.
  final bool enableLongPress;

  /// Whether to enable double-tap gestures.
  ///
  /// When true, double-tapping on a date or event triggers callbacks.
  /// Defaults to false.
  final bool enableDoubleTap;

  /// Duration for calendar animations (view changes, navigation, etc.).
  ///
  /// Defaults to 300 milliseconds.
  final Duration animationDuration;

  // ==================== Locale Settings ====================

  /// The locale to use for date formatting and localization.
  ///
  /// If null, uses the system locale.
  final Locale? locale;

  // ==================== Holiday Settings ====================

  /// List of dates to mark as holidays.
  ///
  /// These dates will be visually highlighted if [showHolidays] is true.
  ///
  /// Example:
  /// ```dart
  /// holidays: [
  ///   DateTime(2024, 1, 1),   // New Year's Day
  ///   DateTime(2024, 12, 25), // Christmas
  /// ]
  /// ```
  final List<DateTime> holidays;

  /// Map of holiday dates to their names.
  ///
  /// Used to display holiday names in tooltips or event lists.
  ///
  /// Example:
  /// ```dart
  /// holidayNames: {
  ///   DateTime(2024, 1, 1): 'New Year\'s Day',
  ///   DateTime(2024, 12, 25): 'Christmas',
  /// }
  /// ```
  final Map<DateTime, String> holidayNames;

  // ==================== Utility Methods ====================

  /// Checks if a given date is marked as a holiday.
  ///
  /// [date] - The date to check.
  ///
  /// Returns true if the date is in the [holidays] list.
  bool isHoliday(DateTime date) => holidays.any((holiday) =>
      holiday.year == date.year &&
      holiday.month == date.month &&
      holiday.day == date.day);

  /// Gets the name of a holiday for a given date.
  ///
  /// [date] - The date to look up.
  ///
  /// Returns the holiday name if found, null otherwise.
  String? getHolidayName(DateTime date) {
    final holiday = holidayNames.keys.firstWhere(
      (key) =>
          key.year == date.year &&
          key.month == date.month &&
          key.day == date.day,
      orElse: () => DateTime(0),
    );
    return holiday.year != 0 ? holidayNames[holiday] : null;
  }

  /// Creates a copy of this configuration with the given fields replaced.
  ///
  /// This is useful for creating variations of a configuration without
  /// modifying the original.
  ///
  /// Example:
  /// ```dart
  /// final newConfig = config.copyWith(
  ///   initialView: CalendarView.week,
  ///   show24HourFormat: false,
  /// );
  /// ```
  CalendarConfig copyWith({
    CalendarView? initialView,
    bool? showWeekNumbers,
    WeekStartDay? weekStartDay,
    DateTime? minDate,
    DateTime? maxDate,
    bool? enableRangeSelection,
    bool? enableMultiDayEvents,
    bool? hideWeekends,
    bool? showHolidays,
    bool? enableVerticalScroll,
    bool? allowSameDayRange,
    bool? enableSwipeNavigation,
    bool? enableDragAndDrop,
    bool? show24HourFormat,
    bool? showEventTime,
    bool? showEventLocation,
    bool? showEventIcon,
    int? maxEventsPerDay,
    bool? compactMode,
    bool? showEventDots,
    int? maxEventDotsPerDay,
    bool? enableLongPress,
    bool? enableDoubleTap,
    Duration? animationDuration,
    Locale? locale,
    List<DateTime>? holidays,
    Map<DateTime, String>? holidayNames,
  }) =>
      CalendarConfig(
        initialView: initialView ?? this.initialView,
        showWeekNumbers: showWeekNumbers ?? this.showWeekNumbers,
        weekStartDay: weekStartDay ?? this.weekStartDay,
        minDate: minDate ?? this.minDate,
        maxDate: maxDate ?? this.maxDate,
        enableRangeSelection: enableRangeSelection ?? this.enableRangeSelection,
        enableMultiDayEvents: enableMultiDayEvents ?? this.enableMultiDayEvents,
        hideWeekends: hideWeekends ?? this.hideWeekends,
        showHolidays: showHolidays ?? this.showHolidays,
        enableVerticalScroll: enableVerticalScroll ?? this.enableVerticalScroll,
        allowSameDayRange: allowSameDayRange ?? this.allowSameDayRange,
        enableSwipeNavigation:
            enableSwipeNavigation ?? this.enableSwipeNavigation,
        enableDragAndDrop: enableDragAndDrop ?? this.enableDragAndDrop,
        show24HourFormat: show24HourFormat ?? this.show24HourFormat,
        showEventTime: showEventTime ?? this.showEventTime,
        showEventLocation: showEventLocation ?? this.showEventLocation,
        showEventIcon: showEventIcon ?? this.showEventIcon,
        maxEventsPerDay: maxEventsPerDay ?? this.maxEventsPerDay,
        compactMode: compactMode ?? this.compactMode,
        showEventDots: showEventDots ?? this.showEventDots,
        maxEventDotsPerDay: maxEventDotsPerDay ?? this.maxEventDotsPerDay,
        enableLongPress: enableLongPress ?? this.enableLongPress,
        enableDoubleTap: enableDoubleTap ?? this.enableDoubleTap,
        animationDuration: animationDuration ?? this.animationDuration,
        locale: locale ?? this.locale,
        holidays: holidays ?? this.holidays,
        holidayNames: holidayNames ?? this.holidayNames,
      );
}
