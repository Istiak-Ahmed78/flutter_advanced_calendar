import 'package:flutter/material.dart';
import '../core/controllers/calendar_controller.dart';
import '../core/models/calendar_config.dart';
import '../core/models/calendar_event.dart';
import '../themes/calendar_theme.dart';
import '../widgets/event_card.dart';

/// Agenda view displaying events in a list grouped by date
class AgendaView extends StatelessWidget {
  const AgendaView({
    super.key,
    required this.controller,
    required this.config,
    required this.theme,
    this.onEventTap,
    this.daysToShow = 30,
  });

  final CalendarController controller;
  final CalendarConfig config;
  final CalendarTheme theme;
  final void Function(CalendarEvent)? onEventTap;
  final int daysToShow;

  @override
  Widget build(BuildContext context) {
    final startDate = controller.focusedDay;
    final endDate = startDate.add(Duration(days: daysToShow));
    final events = controller.getEventsForRange(startDate, endDate);

    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: theme.dayTextColor.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No upcoming events',
              style: TextStyle(
                fontSize: 16,
                color: theme.dayTextColor.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }

    // Group events by date
    final groupedEvents = _groupEventsByDate(events);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groupedEvents.length,
      itemBuilder: (context, index) {
        final date = groupedEvents.keys.elementAt(index);
        final dateEvents = groupedEvents[date]!;

        return _buildDateSection(date, dateEvents);
      },
    );
  }

  Widget _buildDateSection(DateTime date, List<CalendarEvent> events) {
    final isToday = controller.isToday(date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: isToday
                ? theme.todayBackgroundColor
                : theme.weekdayBackgroundColor,
            borderRadius: BorderRadius.circular(theme.borderRadius),
            border: isToday
                ? Border.all(
                    color: theme.todayBorderColor,
                    width: theme.borderWidth,
                  )
                : null,
          ),
          child: Row(
            children: [
              Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isToday ? theme.todayTextColor : theme.dayTextColor,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getWeekdayName(date.weekday),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isToday
                          ? theme.todayTextColor
                          : theme.weekdayTextColor,
                    ),
                  ),
                  Text(
                    _getMonthYear(date),
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.weekdayTextColor.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.eventIndicatorColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${events.length} ${events.length == 1 ? "event" : "events"}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: theme.eventIndicatorColor,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Events
        ...events.map((event) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: EventCard(
                event: event,
                theme: theme,
                showTime: config.showEventTime,
                showLocation: config.showEventLocation,
                showIcon: config.showEventIcon,
                onTap: () => onEventTap?.call(event),
              ),
            )),

        const SizedBox(height: 16),
      ],
    );
  }

  Map<DateTime, List<CalendarEvent>> _groupEventsByDate(
      List<CalendarEvent> events) {
    final grouped = <DateTime, List<CalendarEvent>>{};

    for (final event in events) {
      // For multi-day events, add to each day
      for (final date in event.dateRange) {
        final dateKey = DateTime(date.year, date.month, date.day);
        grouped.putIfAbsent(dateKey, () => []).add(event);
      }
    }

    // Sort by date
    final sortedKeys = grouped.keys.toList()..sort();
    final sortedMap = <DateTime, List<CalendarEvent>>{};
    for (final key in sortedKeys) {
      sortedMap[key] = grouped[key]!;
    }

    return sortedMap;
  }

  String _getWeekdayName(int weekday) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return weekdays[weekday - 1];
  }

  String _getMonthYear(DateTime date) {
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
    return '${months[date.month - 1]} ${date.year}';
  }
}
