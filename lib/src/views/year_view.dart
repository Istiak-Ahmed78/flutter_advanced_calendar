import 'package:flutter/material.dart';

import '../core/controllers/calendar_controller.dart';
import '../core/models/calendar_config.dart';
import '../core/utils/date_utils.dart' as calendar_utils;
import '../themes/calendar_theme.dart';

/// Year view displaying 12 months
class YearView extends StatelessWidget {
  const YearView({
    super.key,
    required this.controller,
    required this.config,
    required this.theme,
    this.onMonthTap,
  });

  final CalendarController controller;
  final CalendarConfig config;
  final CalendarTheme theme;
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
            // Month name
            Container(
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
            ),

            // Mini calendar
            Expanded(
              child: _buildMiniCalendar(monthDate),
            ),
          ],
        ),
      ),
    );
  }

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
          if (index < startWeekday - 1) {
            return const SizedBox.shrink();
          }

          final day = index - startWeekday + 2;
          final date = DateTime(month.year, month.month, day);
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
                Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 10,
                    color: isToday ? theme.todayTextColor : theme.dayTextColor,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
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
        },
      ),
    );
  }

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
