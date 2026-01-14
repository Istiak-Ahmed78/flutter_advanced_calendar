import 'package:flutter/material.dart';
import 'enums.dart';

/// Configuration for calendar behavior and appearance
class CalendarConfig {
  // NEW: Holiday names

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
    this.showEventDots = true, // NEW
    this.maxEventDotsPerDay = 3, // NEW
    this.enableLongPress = true,
    this.enableDoubleTap = false,
    this.animationDuration = const Duration(milliseconds: 300),
    this.locale,
    this.holidays = const [], // NEW
    this.holidayNames = const {}, // NEW
  });
  // View settings
  final CalendarView initialView;
  final bool showWeekNumbers;
  final WeekStartDay weekStartDay;

  // Date constraints
  final DateTime? minDate;
  final DateTime? maxDate;

  // Feature flags
  final bool enableRangeSelection;
  final bool enableMultiDayEvents;
  final bool hideWeekends; // Issue #5: Hide weekends option
  final bool showHolidays; // Issue #8: Show holidays
  final bool
      enableVerticalScroll; // Issue #7: Vertical scroll for table calendar
  final bool allowSameDayRange; // Issue #6: Allow same day selection in range
  final bool enableSwipeNavigation;
  final bool enableDragAndDrop;

  // Display settings
  final bool show24HourFormat;
  final bool showEventTime;
  final bool showEventLocation;
  final bool showEventIcon;
  final int maxEventsPerDay;
  final bool compactMode;
  final bool showEventDots; // NEW: Show colored dots for events
  final int maxEventDotsPerDay; // NEW: Maximum number of dots to show per day

  // Interaction settings
  final bool enableLongPress;
  final bool enableDoubleTap;
  final Duration animationDuration;

  // Locale settings
  final Locale? locale;

  // Holiday settings
  final List<DateTime> holidays; // NEW: List of holiday dates
  final Map<DateTime, String> holidayNames;

  /// Check if a date is a holiday
  bool isHoliday(DateTime date) => holidays.any((holiday) =>
      holiday.year == date.year &&
      holiday.month == date.month &&
      holiday.day == date.day);

  /// Get holiday name for a date
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
