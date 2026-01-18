import 'package:flutter/material.dart';

import '../core/controllers/calendar_controller.dart';
import '../core/models/calendar_config.dart';
import '../core/utils/date_utils.dart' as calendar_utils;
import '../themes/calendar_theme.dart';

/// A year overview displaying all 12 months in a grid layout.
///
/// The year view shows a 3x4 grid of month cards, each containing a mini
/// calendar with day numbers and event indicators. Users can tap any month
/// to navigate to it in the main calendar view.
///
/// Features:
/// - 12 month cards in a 3-column grid
/// - Mini calendar for each month showing all days
/// - Current month highlighting
/// - Today's date highlighting
/// - Event indicators (dots) on days with events
/// - Tap to navigate to specific month
/// - Responsive layout with proper spacing
///
/// Use Cases:
/// - Quick year overview
/// - Fast navigation to any month
/// - Visual event distribution across the year
/// - Annual planning view
///
/// Example:
/// ```dart
/// YearView(
///   controller: calendarController,
///   config: CalendarConfig(),
///   theme: CalendarTheme.light(),
///   onMonthTap: (monthDate) {
///     print('Navigated to: ${monthDate.month}/${monthDate.year}');
///   },
/// )
/// ```
class YearView extends StatelessWidget {
  /// Creates a year view.
  ///
  /// [controller] - The calendar controller managing state and events.
  /// [config] - Configuration for display options.
  /// [theme] - Theme configuration for visual styling.
  /// [onMonthTap] - Optional callback when a month card is tapped.
  ///   Receives the first day of the tapped month.
  ///
  /// Example:
  /// ```dart
  /// YearView(
  ///   controller: myController,
  ///   config: CalendarConfig(),
  ///   theme: CalendarTheme.dark(),
  ///   onMonthTap: (monthDate) {
  ///     // Navigate to month view
  ///     Navigator.push(
  ///       context,
  ///       MaterialPageRoute(
  ///         builder: (_) => MonthDetailPage(date: monthDate),
  ///       ),
  ///     );
  ///   },
  /// )
  /// ```
  const YearView({
    super.key,
    required this.controller,
    required this.config,
    required this.theme,
    this.onMonthTap,
  });

  /// The calendar controller managing state and events.
  final CalendarController controller;

  /// Configuration for display options.
  final CalendarConfig config;

  /// Theme configuration for visual styling.
  final CalendarTheme theme;

  /// Callback invoked when a month card is tapped.
  ///
  /// The DateTime parameter represents the first day of the tapped month.
  /// The controller automatically navigates to this month when tapped.
  final void Function(DateTime)? onMonthTap;

  @override
  Widget build(BuildContext context) => GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 12,
        itemBuilder: (context, index) => _buildMonthCard(index + 1),
      );

  /// Builds a single month card with mini calendar.
  ///
  /// [month] - The month number (1-12).
  Widget _buildMonthCard(int month) {
    final monthDate = DateTime(controller.focusedDay.year, month);
    final isCurrentMonth = controller.focusedDay.month == month;

    return InkWell(
      onTap: () {
        controller.jumpToDate(monthDate);
        onMonthTap?.call(monthDate);
      },
      borderRadius: BorderRadius.circular(theme.borderRadius),
      child: Container(
        decoration: BoxDecoration(
          color: isCurrentMonth
              ? theme.selectedDayBackgroundColor.withValues(alpha: 0.1)
              : theme.backgroundColor,
          border: Border.all(
            color:
                isCurrentMonth ? theme.selectedBorderColor : theme.borderColor,
            width: isCurrentMonth ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(theme.borderRadius),
        ),
        child: Column(
          children: [
            _buildMonthHeader(month, isCurrentMonth),
            Expanded(
              child: _buildMiniCalendar(monthDate),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the month header showing the month name.
  ///
  /// [month] - The month number (1-12).
  /// [isCurrentMonth] - Whether this is the currently focused month.
  Widget _buildMonthHeader(int month, bool isCurrentMonth) => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isCurrentMonth
              ? theme.selectedDayBackgroundColor
              : theme.weekdayBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(theme.borderRadius),
            topRight: Radius.circular(theme.borderRadius),
          ),
        ),
        child: Center(
          child: Text(
            _getMonthName(month),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isCurrentMonth
                  ? theme.selectedDayTextColor
                  : theme.weekdayTextColor,
            ),
          ),
        ),
      );

  /// Builds a mini calendar grid for a specific month.
  ///
  /// Shows all days in the month with event indicators and today highlighting.
  ///
  /// [month] - The month date to display.
  Widget _buildMiniCalendar(DateTime month) {
    final daysInMonth = calendar_utils.getDaysInMonth(month);
    final firstDayOfMonth = DateTime(month.year, month.month);
    final startWeekday = firstDayOfMonth.weekday;

    return Padding(
      padding: const EdgeInsets.all(4),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
        ),
        itemCount: daysInMonth + startWeekday - 1,
        itemBuilder: (context, index) {
          // Empty cells before the first day of the month
          if (index < startWeekday - 1) {
            return const SizedBox.shrink();
          }

          final day = index - startWeekday + 2;
          final date = DateTime(month.year, month.month, day);

          return _buildMiniDayCell(date);
        },
      ),
    );
  }

  /// Builds a single day cell in the mini calendar.
  ///
  /// [date] - The date for this cell.
  Widget _buildMiniDayCell(DateTime date) {
    final isToday = controller.isToday(date);
    final hasEvents = controller.hasEventsOnDay(date);

    return Container(
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: isToday ? theme.todayBackgroundColor : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Day number
          Text(
            '${date.day}',
            style: TextStyle(
              fontSize: 10,
              color: isToday ? theme.todayTextColor : theme.dayTextColor,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          // Event indicator dot
          if (hasEvents)
            Positioned(
              bottom: 2,
              child: Container(
                width: 3,
                height: 3,
                decoration: BoxDecoration(
                  color: theme.eventIndicatorColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Gets the full month name for a month number.
  ///
  /// [month] - The month number (1-12).
  ///
  /// Returns the full month name (e.g., "January").
  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}
