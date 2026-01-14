import 'package:flutter/material.dart';

import '../core/controllers/calendar_controller.dart';
import '../core/models/calendar_config.dart';
import '../core/models/calendar_event.dart';
import '../themes/calendar_theme.dart';
import 'event_card.dart';

/// Widget for displaying a single day cell in the calendar
class DayCell extends StatelessWidget {
  const DayCell({
    super.key,
    required this.date,
    required this.controller,
    this.theme,
    this.config,
    this.events = const [],
    this.onTap,
    this.onLongPress,
    this.showEvents = true,
    this.maxVisibleEvents = 3,
    this.isOutsideMonth = false,
    this.isToday = false,
    this.isHoliday = false,
    this.holidayName,
    this.showEventDots = true,
    this.maxEventDots = 3,
  });
  final DateTime date;
  final CalendarController controller;
  final CalendarTheme? theme;
  final CalendarConfig? config;
  final List<CalendarEvent> events;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool showEvents;
  final int maxVisibleEvents;
  final bool isOutsideMonth;
  final bool isToday;
  final bool isHoliday;
  final String? holidayName;
  final bool showEventDots;
  final int maxEventDots;

  @override
  Widget build(BuildContext context) {
    final calendarTheme = theme ?? CalendarTheme.light();
    final isSelected = controller.isDaySelected(date);
    final isInRange = controller.isDayInRange(date);
    final isRangeStart = controller.isRangeStart(date);
    final isRangeEnd = controller.isRangeEnd(date);
    final isWeekend = controller.isWeekend(date);

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: _getBackgroundColor(
            calendarTheme,
            isToday: isToday,
            isSelected: isSelected,
            isInRange: isInRange,
            isRangeStart: isRangeStart,
            isRangeEnd: isRangeEnd,
            isHoliday: isHoliday,
          ),
          border: _getBorder(
            calendarTheme,
            isToday: isToday,
            isSelected: isSelected,
            isHoliday: isHoliday,
          ),
          borderRadius: _getBorderRadius(
            calendarTheme,
            isRangeStart: isRangeStart,
            isRangeEnd: isRangeEnd,
            isInRange: isInRange,
          ),
        ),
        child: Column(
          children: [
            // Day number
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '${date.day}',
                style: _getTextStyle(
                  calendarTheme,
                  isToday: isToday,
                  isSelected: isSelected,
                  isWeekend: isWeekend,
                  isHoliday: isHoliday,
                  isOutsideMonth: isOutsideMonth,
                ),
              ),
            ),

            // Holiday name (if available and space permits)
            if (isHoliday &&
                holidayName != null &&
                config?.showHolidays == true) ...[
              const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  holidayName!,
                  style: TextStyle(
                    fontSize: 8,
                    color: calendarTheme.holidayTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],

            // Event indicators (dots or list)
            if (showEvents && events.isNotEmpty) ...[
              const SizedBox(height: 2),
              Expanded(
                child: showEventDots
                    ? _buildEventDots(calendarTheme)
                    : _buildEventList(calendarTheme),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Build event dots with individual colors
  Widget _buildEventDots(CalendarTheme theme) {
    if (events.isEmpty) {
      return const SizedBox.shrink();
    }

    final visibleEvents = events.take(maxEventDots).toList();
    final hasMore = events.length > maxEventDots;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Event dots with individual colors
        Wrap(
          spacing: theme.eventIndicatorSpacing,
          runSpacing: theme.eventIndicatorSpacing,
          alignment: WrapAlignment.center,
          children: visibleEvents
              .map((event) => Container(
                    width: theme.eventIndicatorSize,
                    height: theme.eventIndicatorSize,
                    decoration: BoxDecoration(
                      color:
                          event.effectiveDotColor, // Use individual dot color
                      shape: BoxShape.circle,
                    ),
                  ))
              .toList(),
        ),

        // "+X more" indicator
        if (hasMore) ...[
          const SizedBox(height: 2),
          Text(
            '+${events.length - maxEventDots}',
            style: TextStyle(
              fontSize: 8,
              color: theme.dayTextColor.withValues(alpha: 0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  /// Build event list (legacy mode)
  Widget _buildEventList(CalendarTheme theme) {
    if (events.isEmpty) {
      return const SizedBox.shrink();
    }

    final visibleEvents = events.take(maxVisibleEvents).toList();
    final hasMore = events.length > maxVisibleEvents;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Event indicators
        ...visibleEvents.map((event) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
              child: EventIndicator(
                color: event.color,
                size: theme.eventIndicatorSize,
              ),
            )),

        // "+X more" indicator
        if (hasMore) ...[
          const SizedBox(height: 2),
          Text(
            '+${events.length - maxVisibleEvents}',
            style: TextStyle(
              fontSize: 9,
              color: theme.dayTextColor.withValues(alpha: 0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Color _getBackgroundColor(
    CalendarTheme theme, {
    required bool isToday,
    required bool isSelected,
    required bool isInRange,
    required bool isRangeStart,
    required bool isRangeEnd,
    required bool isHoliday,
  }) {
    if (isSelected) {
      return theme.selectedDayBackgroundColor;
    }
    if (isRangeStart) {
      return theme.rangeStartBackgroundColor;
    }
    if (isRangeEnd) {
      return theme.rangeEndBackgroundColor;
    }
    if (isInRange) {
      return theme.rangeMiddleBackgroundColor;
    }
    if (isToday) {
      return theme.todayBackgroundColor;
    }
    if (isHoliday && config?.showHolidays == true) {
      return theme.holidayBackgroundColor;
    }
    return Colors.transparent;
  }

  Border? _getBorder(
    CalendarTheme theme, {
    required bool isToday,
    required bool isSelected,
    required bool isHoliday,
  }) {
    // Issue #8: Show both today and holiday decoration
    if (isToday && isHoliday && config?.showHolidays == true) {
      // Double border: inner today, outer holiday
      return Border.all(
        color: theme.holidayTextColor,
        width: theme.borderWidth * 2,
      );
    }

    if (isSelected) {
      return Border.all(
        color: theme.selectedBorderColor,
        width: theme.borderWidth,
      );
    }

    if (isToday) {
      return Border.all(
        color: theme.todayBorderColor,
        width: theme.borderWidth,
      );
    }

    return null;
  }

  BorderRadius? _getBorderRadius(
    CalendarTheme theme, {
    required bool isRangeStart,
    required bool isRangeEnd,
    required bool isInRange,
  }) {
    if (!isInRange && !isRangeStart && !isRangeEnd) {
      return BorderRadius.circular(theme.borderRadius);
    }

    if (isRangeStart && isRangeEnd) {
      return BorderRadius.circular(theme.borderRadius);
    }

    if (isRangeStart) {
      return BorderRadius.only(
        topLeft: Radius.circular(theme.borderRadius),
        bottomLeft: Radius.circular(theme.borderRadius),
      );
    }

    if (isRangeEnd) {
      return BorderRadius.only(
        topRight: Radius.circular(theme.borderRadius),
        bottomRight: Radius.circular(theme.borderRadius),
      );
    }

    return null;
  }

  TextStyle _getTextStyle(
    CalendarTheme theme, {
    required bool isToday,
    required bool isSelected,
    required bool isWeekend,
    required bool isHoliday,
    required bool isOutsideMonth,
  }) {
    Color textColor;

    if (isSelected) {
      textColor = theme.selectedDayTextColor;
    } else if (isOutsideMonth) {
      textColor = theme.outsideMonthTextColor;
    } else if (isHoliday && config?.showHolidays == true) {
      textColor = theme.holidayTextColor;
    } else if (isWeekend) {
      textColor = theme.weekendTextColor;
    } else if (isToday) {
      textColor = theme.todayTextColor;
    } else {
      textColor = theme.dayTextColor;
    }

    return TextStyle(
      fontSize: 14,
      fontWeight: isToday || isSelected ? FontWeight.bold : FontWeight.normal,
      color: textColor,
    );
  }
}
