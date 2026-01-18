import 'package:flutter/material.dart';

import '../core/controllers/calendar_controller.dart';
import '../core/models/calendar_config.dart';
import '../core/models/calendar_event.dart';
import '../themes/calendar_theme.dart';
import 'event_card.dart';

/// A single day cell widget for calendar views.
///
/// The day cell displays a date number with optional event indicators,
/// holiday names, and various visual states (selected, today, in range, etc.).
/// It supports both dot indicators and list-style event display.
///
/// Features:
/// - Day number display
/// - Multiple visual states (today, selected, range, holiday, weekend)
/// - Event indicators (dots or list)
/// - Individual event colors for dots
/// - Holiday name display
/// - Outside month styling
/// - Range selection visualization
/// - Tap and long-press handling
/// - "+X more" overflow indicator
///
/// Visual States Priority (highest to lowest):
/// 1. Selected
/// 2. Range start/end
/// 3. In range
/// 4. Today
/// 5. Holiday
/// 6. Weekend
/// 7. Normal
///
/// Example:
/// ```dart
/// DayCell(
///   date: DateTime(2024, 1, 15),
///   controller: calendarController,
///   theme: CalendarTheme.light(),
///   config: CalendarConfig(showHolidays: true),
///   events: [event1, event2],
///   isToday: true,
///   showEventDots: true,
///   onTap: () => print('Day tapped'),
/// )
/// ```
class DayCell extends StatelessWidget {
  /// Creates a day cell.
  ///
  /// [date] - The date this cell represents.
  /// [controller] - The calendar controller for state management.
  /// [theme] - Optional theme configuration. Defaults to light theme.
  /// [config] - Optional calendar configuration.
  /// [events] - List of events on this day. Defaults to empty list.
  /// [onTap] - Optional callback when the cell is tapped.
  /// [onLongPress] - Optional callback when the cell is long-pressed.
  /// [showEvents] - Whether to show event indicators. Defaults to true.
  /// [maxVisibleEvents] - Maximum events to show in list mode. Defaults to 3.
  /// [isOutsideMonth] - Whether this date is outside the current month.
  /// [isToday] - Whether this is today's date.
  /// [isHoliday] - Whether this date is a holiday.
  /// [holidayName] - Optional holiday name to display.
  /// [showEventDots] - Whether to use dot indicators (vs list). Defaults to true.
  /// [maxEventDots] - Maximum event dots to show. Defaults to 3.
  ///
  /// Example:
  /// ```dart
  /// DayCell(
  ///   date: DateTime(2024, 12, 25),
  ///   controller: myController,
  ///   theme: CalendarTheme.dark(),
  ///   events: christmasEvents,
  ///   isHoliday: true,
  ///   holidayName: 'Christmas',
  ///   showEventDots: true,
  ///   maxEventDots: 5,
  ///   onTap: () => showDayDetails(date),
  /// )
  /// ```
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

  /// The date this cell represents.
  final DateTime date;

  /// The calendar controller managing state.
  final CalendarController controller;

  /// Theme configuration for visual styling.
  ///
  /// If not provided, defaults to [CalendarTheme.light()].
  final CalendarTheme? theme;

  /// Calendar configuration for display options.
  final CalendarConfig? config;

  /// List of events on this day.
  final List<CalendarEvent> events;

  /// Callback invoked when the cell is tapped.
  final VoidCallback? onTap;

  /// Callback invoked when the cell is long-pressed.
  final VoidCallback? onLongPress;

  /// Whether to show event indicators.
  final bool showEvents;

  /// Maximum number of events to show in list mode.
  ///
  /// When there are more events, a "+X more" indicator is shown.
  final int maxVisibleEvents;

  /// Whether this date is outside the currently displayed month.
  ///
  /// Outside month dates are typically shown with reduced opacity.
  final bool isOutsideMonth;

  /// Whether this is today's date.
  final bool isToday;

  /// Whether this date is a holiday.
  final bool isHoliday;

  /// Optional holiday name to display below the day number.
  ///
  /// Only shown if [isHoliday] is true and [CalendarConfig.showHolidays] is true.
  final String? holidayName;

  /// Whether to use dot indicators for events.
  ///
  /// When true, shows colored dots. When false, shows list-style indicators.
  final bool showEventDots;

  /// Maximum number of event dots to show.
  ///
  /// When there are more events, a "+X more" indicator is shown.
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
            _buildDayNumber(calendarTheme, isSelected, isWeekend),
            if (isHoliday &&
                holidayName != null &&
                config?.showHolidays == true)
              _buildHolidayName(calendarTheme),
            if (showEvents && events.isNotEmpty)
              _buildEventIndicators(calendarTheme),
          ],
        ),
      ),
    );
  }

  /// Builds the day number text.
  ///
  /// [theme] - The calendar theme.
  /// [isSelected] - Whether this day is selected.
  /// [isWeekend] - Whether this is a weekend day.
  Widget _buildDayNumber(
    CalendarTheme theme,
    bool isSelected,
    bool isWeekend,
  ) =>
      Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          '${date.day}',
          style: _getTextStyle(
            theme,
            isToday: isToday,
            isSelected: isSelected,
            isWeekend: isWeekend,
            isHoliday: isHoliday,
            isOutsideMonth: isOutsideMonth,
          ),
        ),
      );

  /// Builds the holiday name text.
  ///
  /// [theme] - The calendar theme.
  Widget _buildHolidayName(CalendarTheme theme) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              holidayName!,
              style: TextStyle(
                fontSize: 8,
                color: theme.holidayTextColor,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );

  /// Builds the event indicators section.
  ///
  /// [theme] - The calendar theme.
  Widget _buildEventIndicators(CalendarTheme theme) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 2),
          Expanded(
            child:
                showEventDots ? _buildEventDots(theme) : _buildEventList(theme),
          ),
        ],
      );

  /// Builds event dots with individual colors.
  ///
  /// Shows up to [maxEventDots] colored dots, with a "+X more" indicator
  /// if there are additional events.
  ///
  /// [theme] - The calendar theme.
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
                      color: event.effectiveDotColor,
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

  /// Builds event list with indicator bars (legacy mode).
  ///
  /// Shows up to [maxVisibleEvents] event indicators, with a "+X more"
  /// indicator if there are additional events.
  ///
  /// [theme] - The calendar theme.
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

  /// Determines the background color based on the cell's state.
  ///
  /// Priority order:
  /// 1. Selected
  /// 2. Range start
  /// 3. Range end
  /// 4. In range
  /// 5. Today
  /// 6. Holiday
  /// 7. Transparent (default)
  ///
  /// [theme] - The calendar theme.
  /// [isToday] - Whether this is today.
  /// [isSelected] - Whether this day is selected.
  /// [isInRange] - Whether this day is in a selected range.
  /// [isRangeStart] - Whether this is the range start.
  /// [isRangeEnd] - Whether this is the range end.
  /// [isHoliday] - Whether this is a holiday.
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

  /// Determines the border based on the cell's state.
  ///
  /// Special case: When a day is both today and a holiday, shows a
  /// double-width border with the holiday color.
  ///
  /// [theme] - The calendar theme.
  /// [isToday] - Whether this is today.
  /// [isSelected] - Whether this day is selected.
  /// [isHoliday] - Whether this is a holiday.
  Border? _getBorder(
    CalendarTheme theme, {
    required bool isToday,
    required bool isSelected,
    required bool isHoliday,
  }) {
    // Special case: Show both today and holiday decoration
    if (isToday && isHoliday && config?.showHolidays == true) {
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

  /// Determines the border radius based on range selection state.
  ///
  /// - Full radius for non-range or single-day range
  /// - Left radius only for range start
  /// - Right radius only for range end
  /// - No radius for middle of range
  ///
  /// [theme] - The calendar theme.
  /// [isRangeStart] - Whether this is the range start.
  /// [isRangeEnd] - Whether this is the range end.
  /// [isInRange] - Whether this is in a range.
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

  /// Determines the text style based on the cell's state.
  ///
  /// Priority order for color:
  /// 1. Selected
  /// 2. Outside month
  /// 3. Holiday
  /// 4. Weekend
  /// 5. Today
  /// 6. Normal
  ///
  /// [theme] - The calendar theme.
  /// [isToday] - Whether this is today.
  /// [isSelected] - Whether this day is selected.
  /// [isWeekend] - Whether this is a weekend.
  /// [isHoliday] - Whether this is a holiday.
  /// [isOutsideMonth] - Whether this is outside the current month.
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
