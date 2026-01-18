import 'package:flutter/material.dart';
import '../core/controllers/calendar_controller.dart';
import '../core/models/calendar_config.dart';
import '../core/models/calendar_event.dart';
import '../themes/calendar_theme.dart';
import '../widgets/event_card.dart';

/// A list-based view displaying events chronologically grouped by date.
///
/// The agenda view provides a scrollable list of upcoming events, organized
/// by date with clear visual separation. It's ideal for viewing events in
/// chronological order without the spatial constraints of a calendar grid.
///
/// Features:
/// - Events grouped by date with clear headers
/// - Shows event count for each day
/// - Highlights today's date
/// - Supports multi-day events
/// - Empty state when no events exist
/// - Customizable date range
///
/// Example:
/// ```dart
/// AgendaView(
///   controller: calendarController,
///   config: CalendarConfig(),
///   theme: CalendarTheme.light(),
///   daysToShow: 30,
///   onEventTap: (event) {
///     print('Tapped: ${event.title}');
///   },
/// )
/// ```
class AgendaView extends StatelessWidget {
  /// Creates an agenda view.
  ///
  /// [controller] - The calendar controller managing state and events.
  /// [config] - Configuration for event display options.
  /// [theme] - Theme configuration for visual styling.
  /// [onEventTap] - Optional callback when an event is tapped.
  /// [daysToShow] - Number of days to display from the focused date. Defaults to 30.
  ///
  /// Example:
  /// ```dart
  /// AgendaView(
  ///   controller: myController,
  ///   config: CalendarConfig(
  ///     showEventTime: true,
  ///     showEventLocation: true,
  ///   ),
  ///   theme: CalendarTheme.dark(),
  ///   daysToShow: 60,
  ///   onEventTap: (event) => Navigator.push(...),
  /// )
  /// ```
  const AgendaView({
    super.key,
    required this.controller,
    required this.config,
    required this.theme,
    this.onEventTap,
    this.daysToShow = 30,
  });

  /// The calendar controller managing state and events.
  final CalendarController controller;

  /// Configuration for event display options.
  final CalendarConfig config;

  /// Theme configuration for visual styling.
  final CalendarTheme theme;

  /// Callback invoked when an event is tapped.
  final void Function(CalendarEvent)? onEventTap;

  /// Number of days to display from the focused date.
  ///
  /// Defaults to 30 days. Increase for longer-term planning,
  /// decrease for a more focused view.
  final int daysToShow;

  @override
  Widget build(BuildContext context) {
    final startDate = controller.focusedDay;
    final endDate = startDate.add(Duration(days: daysToShow));
    final events = controller.getEventsForRange(startDate, endDate);

    if (events.isEmpty) {
      return _buildEmptyState();
    }

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

  /// Builds the empty state when no events are found.
  Widget _buildEmptyState() => Center(
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

  /// Builds a section for a specific date with its events.
  ///
  /// [date] - The date for this section.
  /// [events] - List of events occurring on this date.
  Widget _buildDateSection(DateTime date, List<CalendarEvent> events) {
    final isToday = controller.isToday(date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDateHeader(date, events.length, isToday),
        _buildEventsList(events),
        const SizedBox(height: 16),
      ],
    );
  }

  /// Builds the date header showing the day, weekday, and event count.
  ///
  /// [date] - The date to display.
  /// [eventCount] - Number of events on this date.
  /// [isToday] - Whether this date is today.
  Widget _buildDateHeader(DateTime date, int eventCount, bool isToday) =>
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
                    color:
                        isToday ? theme.todayTextColor : theme.weekdayTextColor,
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
                '$eventCount ${eventCount == 1 ? "event" : "events"}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: theme.eventIndicatorColor,
                ),
              ),
            ),
          ],
        ),
      );

  /// Builds the list of event cards for a date.
  ///
  /// [events] - List of events to display.
  Widget _buildEventsList(List<CalendarEvent> events) => Column(
        children: events
            .map((event) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: EventCard(
                    event: event,
                    theme: theme,
                    showTime: config.showEventTime,
                    showLocation: config.showEventLocation,
                    showIcon: config.showEventIcon,
                    onTap: () => onEventTap?.call(event),
                  ),
                ))
            .toList(),
      );

  /// Groups events by date, handling multi-day events.
  ///
  /// Multi-day events appear under each date they span.
  ///
  /// [events] - List of events to group.
  ///
  /// Returns a sorted map of dates to their events.
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

  /// Gets the full weekday name for a weekday number.
  ///
  /// [weekday] - Weekday number (1=Monday, 7=Sunday).
  ///
  /// Returns the full weekday name (e.g., "Monday").
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

  /// Formats a date as "Month Year" (e.g., "January 2024").
  ///
  /// [date] - The date to format.
  ///
  /// Returns the formatted string.
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
