import 'package:flutter/material.dart';
import '../core/models/calendar_event.dart';
import '../themes/calendar_theme.dart';

/// Widget for displaying a calendar event
class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
    this.theme,
    this.onTap,
    this.onLongPress,
    this.showTime = true,
    this.showLocation = false,
    this.showIcon = true,
    this.compact = false,
  });
  final CalendarEvent event;
  final CalendarTheme? theme;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool showTime;
  final bool showLocation;
  final bool showIcon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final calendarTheme = theme ?? CalendarTheme.light();

    if (compact) {
      return _buildCompactCard(calendarTheme);
    }

    return _buildFullCard(calendarTheme);
  }

  Widget _buildCompactCard(CalendarTheme theme) => InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: event.color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
            border: Border(
              left: BorderSide(
                color: event.color,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              if (showIcon && event.icon != null) ...[
                Icon(
                  event.icon,
                  size: 12,
                  color: event.color,
                ),
                const SizedBox(width: 4),
              ],
              Expanded(
                child: Text(
                  event.title,
                  style: TextStyle(
                    fontSize: 11,
                    color: event.textColor ?? event.color,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (showTime && !event.isAllDay) ...[
                const SizedBox(width: 4),
                Text(
                  _formatTime(event.startDate),
                  style: TextStyle(
                    fontSize: 10,
                    color: event.color.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ],
          ),
        ),
      );

  Widget _buildFullCard(CalendarTheme theme) => InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(theme.borderRadius),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: event.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(theme.borderRadius),
            border: Border.all(
              color: event.color.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title row
              Row(
                children: [
                  if (showIcon && event.icon != null) ...[
                    Icon(
                      event.icon,
                      size: 16,
                      color: event.color,
                    ),
                    const SizedBox(width: 6),
                  ],
                  Expanded(
                    child: Text(
                      event.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: event.textColor ?? event.color,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (event.isCancelled)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Cancelled',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),

              // Time
              if (showTime && !event.isAllDay) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: event.color.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_formatTime(event.startDate)} - ${_formatTime(event.endDate)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: event.color.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ],

              // All-day indicator
              if (event.isAllDay) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.event,
                      size: 12,
                      color: event.color.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'All day',
                      style: TextStyle(
                        fontSize: 12,
                        color: event.color.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ],

              // Multi-day indicator
              if (event.isMultiDay) ...[
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: event.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${event.getTotalDays} days',
                    style: TextStyle(
                      fontSize: 11,
                      color: event.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],

              // Location
              if (showLocation && event.location != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 12,
                      color: event.color.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event.location!,
                        style: TextStyle(
                          fontSize: 12,
                          color: event.color.withValues(alpha: 0.8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],

              // Description
              if (event.description != null &&
                  event.description!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  event.description!,
                  style: TextStyle(
                    fontSize: 11,
                    color: event.color.withValues(alpha: 0.7),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      );

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

/// Compact event indicator (dot)
class EventIndicator extends StatelessWidget {
  const EventIndicator({
    super.key,
    required this.color,
    this.size = 6,
  });
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      );
}
