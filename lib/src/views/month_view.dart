import 'package:flutter/material.dart';

import '../core/controllers/calendar_controller.dart';
import '../core/models/calendar_config.dart';
import '../core/utils/date_utils.dart' as calendar_utils;
import '../themes/calendar_theme.dart';
import '../widgets/day_cell.dart';

/// Month view displaying a full calendar grid
class MonthView extends StatelessWidget {
  const MonthView({
    super.key,
    required this.controller,
    required this.config,
    required this.theme,
    this.onDaySelected,
    this.onDayLongPressed,
    this.displayDate,
  });
  final CalendarController controller;
  final CalendarConfig config;
  final CalendarTheme theme;
  final void Function(DateTime)? onDaySelected;
  final void Function(DateTime)? onDayLongPressed;
  final DateTime? displayDate;
  DateTime get _effectiveDate => displayDate ?? controller.focusedDay;

  @override
  Widget build(BuildContext context) {
    // ✅ FIX: When displayDate is provided (used in vertical scroll ListView),
    // just return the grid without any scrolling wrapper
    if (displayDate != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildWeekdayHeader(),
          _buildCalendarGrid(),
        ],
      );
    }

    // Default: Use Column with Expanded (for PageView or single month)
    return Column(
      children: [
        _buildWeekdayHeader(),
        const SizedBox(height: 8),
        Expanded(child: _buildCalendarGrid()),
      ],
    );
  }

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

  void _handleDayTap(DateTime day) {
    if (config.enableRangeSelection) {
      controller.handleRangeTap(day, allowSameDay: config.allowSameDayRange);

      if (controller.hasRangeSelection && onDaySelected != null) {
        onDaySelected?.call(day);
      }
    } else {
      controller.selectDay(day);
      onDaySelected?.call(day);
    }
  }

  void _handleDayLongPress(DateTime day) {
    if (config.enableLongPress) {
      onDayLongPressed?.call(day);
    }
  }

  List<String> _getWeekdayNames() {
    const allWeekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

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

  bool _isInDisplayMonth(DateTime day) =>
      calendar_utils.isSameMonth(day, _effectiveDate);

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
