import 'package:flutter/material.dart';
import '../core/controllers/calendar_controller.dart';
import '../core/models/calendar_config.dart';
import '../core/models/calendar_event.dart';
import '../themes/calendar_theme.dart';

/// Day view showing hourly time slots for a single day
class DayView extends StatelessWidget {
  const DayView({
    super.key,
    required this.controller,
    required this.config,
    required this.theme,
    this.onEventTap,
    this.onTimeSlotTap,
  });

  final CalendarController controller;
  final CalendarConfig config;
  final CalendarTheme theme;
  final void Function(CalendarEvent)? onEventTap;
  final void Function(DateTime)? onTimeSlotTap;
  @override
  Widget build(BuildContext context) {
    final events = controller.getEventsForDay(controller.focusedDay);

    return Column(
      children: [
        // Date header
        Container(
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
                '${events.length} events',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.headerTextColor.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        // Time slots
        Expanded(
          child: SingleChildScrollView(
            child: _buildTimeSlots(events),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlots(List<CalendarEvent> events) {
    const hourHeight = 60.0;
    const startHour = 6; // 6 AM start
    const endHour = 22; // 10 PM end

    return SizedBox(
      height: (endHour - startHour) * hourHeight,
      child: Stack(
        children: [
          // Time grid
          Column(
            children: List.generate(endHour - startHour, (index) {
              final hour = startHour + index;
              return _buildTimeSlot(hour, hourHeight);
            }),
          ),
          // Events overlay
          ...events
              .map((event) => _buildEventWidget(event, hourHeight, startHour)),
        ],
      ),
    );
  }

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
                padding: const EdgeInsets.only(right: 8, top: 4),
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
            // Time slot area
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

  Widget _buildEventWidget(
      CalendarEvent event, double hourHeight, int startHour) {
    // ✅ Fixed: Use correct property names from CalendarEvent
    final startTime = event.startDate; // Correct property name
    final endTime = event.endDate; // Correct property name

    // Calculate position and size
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;
    final startHourMinutes = startHour * 60;

    final topOffset = ((startMinutes - startHourMinutes) / 60) * hourHeight;
    final height = ((endMinutes - startMinutes) / 60) * hourHeight;

    // ✅ FIX: Ensure minimum height and prevent overflow
    final safeHeight =
        height.clamp(20.0, hourHeight * 2); // Min 20px, max 2 hours

    return Positioned(
      left: 68, // After time label (60 + 8 padding)
      top: topOffset,
      right: 8,
      height: safeHeight,
      child: GestureDetector(
        onTap: () => onEventTap?.call(event),
        child: Container(
          margin:
              const EdgeInsets.only(right: 4, bottom: 1), // ✅ Reduced margin
          decoration: BoxDecoration(
            color: event.color, // ✅ Use event.color directly
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
            padding: const EdgeInsets.symmetric(
                horizontal: 6, vertical: 2), // ✅ Reduced padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // ✅ Prevent expansion
              children: [
                // Event title
                Flexible(
                  // ✅ Use Flexible instead of Expanded
                  child: Text(
                    event.title,
                    style: TextStyle(
                      color: event.textColor ??
                          _getTextColor(event
                              .color), // ✅ Use event.textColor if available
                      fontSize: 12, // ✅ Reduced font size
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Time range (only if height allows)
                if (safeHeight > 35) // ✅ Only show time if enough space
                  Flexible(
                    child: Text(
                      '${_formatTime(startTime)} - ${_formatTime(endTime)}',
                      style: TextStyle(
                        color: (event.textColor ?? _getTextColor(event.color))
                            .withValues(alpha: 0.8),
                        fontSize: 10, // ✅ Smaller font
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                // Description (only if height allows)
                if (event.description != null &&
                    event.description!.isNotEmpty &&
                    safeHeight > 50)
                  Flexible(
                    child: Text(
                      event.description!,
                      style: TextStyle(
                        color: (event.textColor ?? _getTextColor(event.color))
                            .withValues(alpha: 0.7),
                        fontSize: 9, // ✅ Even smaller font
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                // Location (only if height allows and location exists)
                if (event.location != null &&
                    event.location!.isNotEmpty &&
                    safeHeight > 65)
                  Flexible(
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 8,
                          color: (event.textColor ?? _getTextColor(event.color))
                              .withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            event.location!,
                            style: TextStyle(
                              color: (event.textColor ??
                                      _getTextColor(event.color))
                                  .withValues(alpha: 0.6),
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
            ),
          ),
        ),
      ),
    );
  }

  Color _getTextColor(Color backgroundColor) {
    // Calculate luminance to determine if text should be light or dark
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }

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
