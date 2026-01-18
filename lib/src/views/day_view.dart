import 'package:flutter/material.dart';
import '../core/controllers/calendar_controller.dart';
import '../core/models/calendar_config.dart';
import '../core/models/calendar_event.dart';
import '../themes/calendar_theme.dart';

/// A detailed hourly view displaying events for a single day.
///
/// The day view provides a time-based layout showing events positioned
/// according to their start and end times. It displays hourly time slots
/// from 6 AM to 10 PM with events overlaid at their scheduled times.
///
/// Features:
/// - Hourly time slots with clear visual separation
/// - Events positioned by start/end time
/// - Event details (title, time, description, location)
/// - Tap handling for events and time slots
/// - 12/24 hour format support
/// - Automatic text color contrast
/// - Responsive event sizing based on duration
///
/// Example:
/// ```dart
/// DayView(
///   controller: calendarController,
///   config: CalendarConfig(show24HourFormat: true),
///   theme: CalendarTheme.light(),
///   onEventTap: (event) {
///     print('Tapped: ${event.title}');
///   },
///   onTimeSlotTap: (time) {
///     print('Create event at: $time');
///   },
/// )
/// ```
class DayView extends StatelessWidget {
  /// Creates a day view.
  ///
  /// [controller] - The calendar controller managing state and events.
  /// [config] - Configuration for display options (time format, etc.).
  /// [theme] - Theme configuration for visual styling.
  /// [onEventTap] - Optional callback when an event is tapped.
  /// [onTimeSlotTap] - Optional callback when an empty time slot is tapped.
  ///
  /// Example:
  /// ```dart
  /// DayView(
  ///   controller: myController,
  ///   config: CalendarConfig(
  ///     show24HourFormat: false,
  ///   ),
  ///   theme: CalendarTheme.dark(),
  ///   onEventTap: (event) => showEventDetails(event),
  ///   onTimeSlotTap: (time) => createNewEvent(time),
  /// )
  /// ```
  const DayView({
    super.key,
    required this.controller,
    required this.config,
    required this.theme,
    this.onEventTap,
    this.onTimeSlotTap,
  });

  /// The calendar controller managing state and events.
  final CalendarController controller;

  /// Configuration for display options.
  final CalendarConfig config;

  /// Theme configuration for visual styling.
  final CalendarTheme theme;

  /// Callback invoked when an event is tapped.
  final void Function(CalendarEvent)? onEventTap;

  /// Callback invoked when an empty time slot is tapped.
  ///
  /// The DateTime parameter represents the start of the tapped hour.
  final void Function(DateTime)? onTimeSlotTap;

  @override
  Widget build(BuildContext context) {
    final events = controller.getEventsForDay(controller.focusedDay);

    return Column(
      children: [
        _buildDateHeader(events.length),
        Expanded(
          child: SingleChildScrollView(
            child: _buildTimeSlots(events),
          ),
        ),
      ],
    );
  }

  /// Builds the date header showing the current date and event count.
  ///
  /// [eventCount] - Number of events on this day.
  Widget _buildDateHeader(int eventCount) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.headerBackgroundColor,
          border: Border(
            bottom: BorderSide(color: theme.borderColor),
          ),
        ),
        child: Row(
          children: [
            Text(
              _formatDate(controller.focusedDay),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.headerTextColor,
              ),
            ),
            const Spacer(),
            Text(
              '$eventCount ${eventCount == 1 ? "event" : "events"}',
              style: TextStyle(
                fontSize: 14,
                color: theme.headerTextColor.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );

  /// Builds the time slots grid with events overlaid.
  ///
  /// [events] - List of events to display.
  Widget _buildTimeSlots(List<CalendarEvent> events) {
    const hourHeight = 60.0;
    const startHour = 6; // 6 AM start
    const endHour = 22; // 10 PM end

    return SizedBox(
      height: (endHour - startHour) * hourHeight + 20,
      child: Stack(
        children: [
          // Time grid
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: List.generate(endHour - startHour, (index) {
                final hour = startHour + index;
                return _buildTimeSlot(hour, hourHeight);
              }),
            ),
          ),
          // Events overlay
          ...events
              .map((event) => _buildEventWidget(event, hourHeight, startHour)),
        ],
      ),
    );
  }

  /// Builds a single hour time slot.
  ///
  /// [hour] - The hour to display (0-23).
  /// [hourHeight] - Height of the time slot in pixels.
  Widget _buildTimeSlot(int hour, double hourHeight) => Container(
        height: hourHeight,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.borderColor.withValues(alpha: 0.3),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            // Time label
            SizedBox(
              width: 60,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Transform.translate(
                    offset: const Offset(0, -8),
                    child: Text(
                      _formatHour(hour),
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.weekdayTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ),
            ),
            // Time slot area (tappable)
            Expanded(
              child: GestureDetector(
                onTap: () {
                  final timeSlot = DateTime(
                    controller.focusedDay.year,
                    controller.focusedDay.month,
                    controller.focusedDay.day,
                    hour,
                  );
                  onTimeSlotTap?.call(timeSlot);
                },
                child: Container(
                  height: hourHeight,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: theme.borderColor.withValues(alpha: 0.3),
                        width: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  /// Builds an event widget positioned at its scheduled time.
  ///
  /// [event] - The event to display.
  /// [hourHeight] - Height of each hour slot in pixels.
  /// [startHour] - The first hour displayed in the view.
  Widget _buildEventWidget(
      CalendarEvent event, double hourHeight, int startHour) {
    final startTime = event.startDate;
    final endTime = event.endDate;

    // Calculate position and size based on time
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;
    final startHourMinutes = startHour * 60;

    final topOffset =
        ((startMinutes - startHourMinutes) / 60) * hourHeight + 10;
    final height = ((endMinutes - startMinutes) / 60) * hourHeight;

    // Ensure minimum and maximum height for readability
    final safeHeight = height.clamp(20.0, hourHeight * 2);

    return Positioned(
      left: 68,
      top: topOffset,
      right: 8,
      height: safeHeight,
      child: GestureDetector(
        onTap: () => onEventTap?.call(event),
        child: Container(
          margin: const EdgeInsets.only(right: 4, bottom: 1),
          decoration: BoxDecoration(
            color: event.color,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: _buildEventContent(event, safeHeight),
          ),
        ),
      ),
    );
  }

  /// Builds the content of an event card.
  ///
  /// Shows different levels of detail based on available height.
  ///
  /// [event] - The event to display.
  /// [height] - Available height for the event card.
  Widget _buildEventContent(CalendarEvent event, double height) {
    final textColor = event.textColor ?? _getTextColor(event.color);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title (always shown)
        Flexible(
          child: Text(
            event.title,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Time (shown if height > 35)
        if (height > 35)
          Flexible(
            child: Text(
              '${_formatTime(event.startDate)} - ${_formatTime(event.endDate)}',
              style: TextStyle(
                color: textColor.withValues(alpha: 0.8),
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        // Description (shown if height > 50)
        if (event.description != null &&
            event.description!.isNotEmpty &&
            height > 50)
          Flexible(
            child: Text(
              event.description!,
              style: TextStyle(
                color: textColor.withValues(alpha: 0.7),
                fontSize: 9,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        // Location (shown if height > 65)
        if (event.location != null && event.location!.isNotEmpty && height > 65)
          Flexible(
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 8,
                  color: textColor.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 2),
                Expanded(
                  child: Text(
                    event.location!,
                    style: TextStyle(
                      color: textColor.withValues(alpha: 0.6),
                      fontSize: 8,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// Determines appropriate text color based on background color luminance.
  ///
  /// [backgroundColor] - The background color to contrast against.
  ///
  /// Returns black for light backgrounds, white for dark backgrounds.
  Color _getTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }

  /// Formats a date as "Weekday, Month Day" (e.g., "Mon, Jan 15").
  ///
  /// [date] - The date to format.
  String _formatDate(DateTime date) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }

  /// Formats an hour in 12 or 24-hour format based on config.
  ///
  /// [hour] - The hour to format (0-23).
  ///
  /// Returns formatted hour string (e.g., "9 AM" or "09:00").
  String _formatHour(int hour) {
    if (config.show24HourFormat) {
      return '${hour.toString().padLeft(2, '0')}:00';
    } else {
      if (hour == 0) {
        return '12 AM';
      }
      if (hour < 12) {
        return '$hour AM';
      }
      if (hour == 12) {
        return '12 PM';
      }
      return '${hour - 12} PM';
    }
  }

  /// Formats a time in 12 or 24-hour format based on config.
  ///
  /// [time] - The time to format.
  ///
  /// Returns formatted time string (e.g., "9:30 AM" or "09:30").
  String _formatTime(DateTime time) {
    if (config.show24HourFormat) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      final hour = time.hour;
      final minute = time.minute.toString().padLeft(2, '0');

      if (hour == 0) {
        return '12:$minute AM';
      }
      if (hour < 12) {
        return '$hour:$minute AM';
      }
      if (hour == 12) {
        return '12:$minute PM';
      }
      return '${hour - 12}:$minute PM';
    }
  }
}
