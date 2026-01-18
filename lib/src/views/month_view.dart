import 'package:flutter/material.dart';

import '../core/controllers/calendar_controller.dart';
import '../core/models/calendar_config.dart';
import '../core/utils/date_utils.dart' as calendar_utils;
import '../themes/calendar_theme.dart';
import '../widgets/day_cell.dart';

/// A traditional calendar grid view displaying a full month.
///
/// The month view shows a complete month in a grid layout with weekday
/// headers and day cells. It supports various display modes including
/// single month, page view, and vertical scrolling.
///
/// Features:
/// - Full month grid with 4-6 weeks
/// - Weekday headers (customizable start day)
/// - Day cells with events
/// - Single and range selection
/// - Holiday highlighting
/// - Weekend hiding option
/// - Outside month day display
/// - Event indicators (dots or inline)
/// - Tap and long-press handling
///
/// Example:
/// ```dart
/// MonthView(
///   controller: calendarController,
///   config: CalendarConfig(
///     enableRangeSelection: true,
///     showEventDots: true,
///   ),
///   theme: CalendarTheme.light(),
///   onDaySelected: (date) {
///     print('Selected: $date');
///   },
///   onDayLongPressed: (date) {
///     print('Long pressed: $date');
///   },
/// )
/// ```
class MonthView extends StatelessWidget {
  /// Creates a month view.
  ///
  /// [controller] - The calendar controller managing state and events.
  /// [config] - Configuration for display and interaction options.
  /// [theme] - Theme configuration for visual styling.
  /// [onDaySelected] - Optional callback when a day is tapped.
  /// [onDayLongPressed] - Optional callback when a day is long-pressed.
  /// [displayDate] - Optional date to display instead of controller's focused day.
  ///   Used for vertical scrolling mode where multiple months are shown.
  ///
  /// Example:
  /// ```dart
  /// // Single month with controller's date
  /// MonthView(
  ///   controller: myController,
  ///   config: CalendarConfig(),
  ///   theme: CalendarTheme.dark(),
  /// )
  ///
  /// // Multiple months in ListView
  /// ListView.builder(
  ///   itemBuilder: (context, index) {
  ///     final date = DateTime(2024, index + 1);
  ///     return MonthView(
  ///       controller: myController,
  ///       config: CalendarConfig(),
  ///       theme: CalendarTheme.light(),
  ///       displayDate: date, // Override date for each month
  ///     );
  ///   },
  /// )
  /// ```
  const MonthView({
    super.key,
    required this.controller,
    required this.config,
    required this.theme,
    this.onDaySelected,
    this.onDayLongPressed,
    this.displayDate,
  });

  /// The calendar controller managing state and events.
  final CalendarController controller;

  /// Configuration for display and interaction options.
  final CalendarConfig config;

  /// Theme configuration for visual styling.
  final CalendarTheme theme;

  /// Callback invoked when a day is tapped.
  ///
  /// For range selection, this is called when the range is complete.
  final void Function(DateTime)? onDaySelected;

  /// Callback invoked when a day is long-pressed.
  ///
  /// Only called if [CalendarConfig.enableLongPress] is true.
  final void Function(DateTime)? onDayLongPressed;

  /// Optional date to display instead of controller's focused day.
  ///
  /// When provided, the view displays this specific month and doesn't
  /// wrap content in Expanded. This is useful for vertical scrolling
  /// where multiple MonthView widgets are shown in a ListView.
  final DateTime? displayDate;

  /// Gets the effective date to display.
  ///
  /// Returns [displayDate] if provided, otherwise uses controller's focused day.
  DateTime get _effectiveDate => displayDate ?? controller.focusedDay;

  @override
  Widget build(BuildContext context) {
    // When displayDate is provided (vertical scroll mode),
    // return a minimal column without expansion
    if (displayDate != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildWeekdayHeader(),
          _buildCalendarGrid(),
        ],
      );
    }

    // Default mode: Use Column with Expanded for PageView or single month
    return Column(
      children: [
        _buildWeekdayHeader(),
        const SizedBox(height: 8),
        Expanded(child: _buildCalendarGrid()),
      ],
    );
  }

  /// Builds the weekday header row (Mon, Tue, Wed, etc.).
  Widget _buildWeekdayHeader() {
    final weekdays = _getWeekdayNames();

    return Container(
      height: theme.weekdayHeight,
      decoration: BoxDecoration(
        color: theme.weekdayBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: theme.borderColor,
            width: theme.borderWidth,
          ),
        ),
      ),
      child: Row(
        children: weekdays
            .map((weekday) => Expanded(
                  child: Center(
                    child: Text(
                      weekday,
                      style: theme.weekdayTextStyle ??
                          TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: theme.weekdayTextColor,
                          ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  /// Builds the calendar grid with day cells.
  Widget _buildCalendarGrid() {
    final visibleDays = _getFilteredVisibleDays();
    final weeks = _groupIntoWeeks(visibleDays);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: weeks
          .map((week) => SizedBox(
                height: theme.dayCellHeight,
                child: Row(
                  children: week
                      .map((day) => Expanded(
                            child: _buildDayCell(day),
                          ))
                      .toList(),
                ),
              ))
          .toList(),
    );
  }

  /// Builds a single day cell.
  ///
  /// [day] - The date for this cell.
  Widget _buildDayCell(DateTime day) {
    final events = controller.getEventsForDay(day);
    final isOutsideMonth = !_isInDisplayMonth(day);
    final isToday = calendar_utils.isSameDay(day, DateTime.now());
    final isHoliday = config.isHoliday(day);

    return DayCell(
      date: day,
      controller: controller,
      theme: theme,
      config: config,
      events: events,
      isOutsideMonth: isOutsideMonth,
      isToday: isToday,
      isHoliday: isHoliday,
      holidayName: config.getHolidayName(day),
      showEvents: config.enableMultiDayEvents,
      maxVisibleEvents: config.maxEventsPerDay,
      showEventDots: config.showEventDots,
      maxEventDots: config.maxEventDotsPerDay,
      onTap: () => _handleDayTap(day),
      onLongPress: () => _handleDayLongPress(day),
    );
  }

  /// Handles day cell tap events.
  ///
  /// Supports both single selection and range selection modes.
  ///
  /// [day] - The tapped date.
  void _handleDayTap(DateTime day) {
    if (config.enableRangeSelection) {
      controller.handleRangeTap(day, allowSameDay: config.allowSameDayRange);

      // Only call callback when range is complete
      if (controller.hasRangeSelection && onDaySelected != null) {
        onDaySelected?.call(day);
      }
    } else {
      controller.selectDay(day);
      onDaySelected?.call(day);
    }
  }

  /// Handles day cell long-press events.
  ///
  /// Only triggers if [CalendarConfig.enableLongPress] is true.
  ///
  /// [day] - The long-pressed date.
  void _handleDayLongPress(DateTime day) {
    if (config.enableLongPress) {
      onDayLongPressed?.call(day);
    }
  }

  /// Gets the weekday names in the correct order based on week start day.
  ///
  /// Returns a list of abbreviated weekday names (e.g., ['Mon', 'Tue', ...]).
  /// Filters out weekends if [CalendarConfig.hideWeekends] is true.
  List<String> _getWeekdayNames() {
    const allWeekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    // Rotate weekdays based on week start day
    final startIndex = controller.weekStartDay - 1;
    final rotated = [
      ...allWeekdays.sublist(startIndex),
      ...allWeekdays.sublist(0, startIndex),
    ];

    if (config.hideWeekends) {
      return rotated.where((day) => day != 'Sat' && day != 'Sun').toList();
    }

    return rotated;
  }

  /// Gets all visible days for the month, including padding days.
  ///
  /// Returns a list of dates including days from previous/next months
  /// to fill complete weeks. Filters out weekends if configured.
  List<DateTime> _getFilteredVisibleDays() {
    final allDays = calendar_utils.getVisibleDays(
      _effectiveDate,
      controller.weekStartDay,
      hideWeekends: config.hideWeekends,
    );

    if (!config.hideWeekends) {
      return allDays;
    }

    return allDays
        .where((day) =>
            day.weekday != DateTime.saturday && day.weekday != DateTime.sunday)
        .toList();
  }

  /// Checks if a date belongs to the currently displayed month.
  ///
  /// [day] - The date to check.
  ///
  /// Returns true if the date is in the same month as [_effectiveDate].
  bool _isInDisplayMonth(DateTime day) =>
      calendar_utils.isSameMonth(day, _effectiveDate);

  /// Groups days into weeks for grid layout.
  ///
  /// [days] - List of dates to group.
  ///
  /// Returns a list of weeks, where each week is a list of dates.
  /// Each week contains 7 days (or 5 if weekends are hidden).
  List<List<DateTime>> _groupIntoWeeks(List<DateTime> days) {
    final weeks = <List<DateTime>>[];
    final daysPerWeek = config.hideWeekends ? 5 : 7;

    for (var i = 0; i < days.length; i += daysPerWeek) {
      final end =
          (i + daysPerWeek < days.length) ? i + daysPerWeek : days.length;
      weeks.add(days.sublist(i, end));
    }

    return weeks;
  }
}
