import 'package:flutter/material.dart';
import '../core/models/calendar_event.dart';
import '../themes/calendar_theme.dart';

/// A card widget for displaying calendar events with various display modes.
///
/// The event card can display events in two modes:
/// - **Compact mode**: Single-line display with minimal information
/// - **Full mode**: Multi-line display with detailed information
///
/// Features:
/// - Two display modes (compact/full)
/// - Event title with optional icon
/// - Time display (start/end or all-day)
/// - Location display
/// - Description preview
/// - Multi-day indicator
/// - Cancelled event badge
/// - Custom colors and styling
/// - Tap and long-press handling
/// - Configurable information display
///
/// Example:
/// ```dart
/// EventCard(
///   event: myEvent,
///   theme: CalendarTheme.light(),
///   showTime: true,
///   showLocation: true,
///   compact: false,
///   onTap: () => showEventDetails(myEvent),
/// )
/// ```
class EventCard extends StatelessWidget {
  /// Creates an event card.
  ///
  /// [event] - The calendar event to display.
  /// [theme] - Optional theme configuration. Defaults to light theme.
  /// [onTap] - Optional callback when the card is tapped.
  /// [onLongPress] - Optional callback when the card is long-pressed.
  /// [showTime] - Whether to show event time. Defaults to true.
  /// [showLocation] - Whether to show event location. Defaults to false.
  /// [showIcon] - Whether to show event icon. Defaults to true.
  /// [compact] - Whether to use compact display mode. Defaults to false.
  ///
  /// **Compact Mode:**
  /// Single-line display with title, optional icon, and start time.
  /// Ideal for month view or dense layouts.
  ///
  /// **Full Mode:**
  /// Multi-line display with title, time range, location, description,
  /// multi-day indicator, and cancelled badge. Ideal for agenda or day view.
  ///
  /// Example:
  /// ```dart
  /// // Compact mode for month view
  /// EventCard(
  ///   event: meeting,
  ///   compact: true,
  ///   showTime: true,
  ///   onTap: () => print('Event tapped'),
  /// )
  ///
  /// // Full mode for agenda view
  /// EventCard(
  ///   event: meeting,
  ///   compact: false,
  ///   showTime: true,
  ///   showLocation: true,
  ///   onLongPress: () => showEventMenu(meeting),
  /// )
  /// ```
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

  /// The calendar event to display.
  final CalendarEvent event;

  /// Theme configuration for visual styling.
  ///
  /// If not provided, defaults to [CalendarTheme.light()].
  final CalendarTheme? theme;

  /// Callback invoked when the card is tapped.
  final VoidCallback? onTap;

  /// Callback invoked when the card is long-pressed.
  final VoidCallback? onLongPress;

  /// Whether to show event time.
  ///
  /// In compact mode, shows start time only.
  /// In full mode, shows start-end time range or "All day".
  final bool showTime;

  /// Whether to show event location.
  ///
  /// Only visible in full mode when [CalendarEvent.location] is not null.
  final bool showLocation;

  /// Whether to show event icon.
  ///
  /// Only visible when [CalendarEvent.icon] is not null.
  final bool showIcon;

  /// Whether to use compact display mode.
  ///
  /// - **true**: Single-line compact display
  /// - **false**: Multi-line full display with all details
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final calendarTheme = theme ?? CalendarTheme.light();

    if (compact) {
      return _buildCompactCard(calendarTheme);
    }

    return _buildFullCard(calendarTheme);
  }

  /// Builds the compact card layout.
  ///
  /// Shows title, optional icon, and start time in a single line.
  ///
  /// [theme] - The calendar theme.
  Widget _buildCompactCard(CalendarTheme theme) => InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
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

  /// Builds the full card layout.
  ///
  /// Shows all event details including title, time, location, description,
  /// multi-day indicator, and cancelled badge.
  ///
  /// [theme] - The calendar theme.
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
              _buildTitleRow(),
              if (showTime && !event.isAllDay) _buildTimeRow(),
              if (event.isAllDay) _buildAllDayRow(),
              if (event.isMultiDay) _buildMultiDayBadge(),
              if (showLocation && event.location != null) _buildLocationRow(),
              if (event.description != null && event.description!.isNotEmpty)
                _buildDescriptionRow(),
            ],
          ),
        ),
      );

  /// Builds the title row with optional icon and cancelled badge.
  Widget _buildTitleRow() => Row(
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
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
      );

  /// Builds the time row showing start and end times.
  Widget _buildTimeRow() => Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
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
      );

  /// Builds the all-day indicator row.
  Widget _buildAllDayRow() => Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
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
      );

  /// Builds the multi-day indicator badge.
  Widget _buildMultiDayBadge() => Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
      );

  /// Builds the location row with icon.
  Widget _buildLocationRow() => Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
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
      );

  /// Builds the description row (preview).
  Widget _buildDescriptionRow() => Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          event.description!,
          style: TextStyle(
            fontSize: 11,
            color: event.color.withValues(alpha: 0.7),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      );

  /// Formats a DateTime as "HH:MM" in 24-hour format.
  ///
  /// [time] - The time to format.
  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

/// A compact circular indicator for events.
///
/// Displays a colored dot to indicate the presence of an event.
/// Typically used in month view cells or as event markers.
///
/// Example:
/// ```dart
/// EventIndicator(
///   color: Colors.blue,
///   size: 8,
/// )
/// ```
class EventIndicator extends StatelessWidget {
  /// Creates an event indicator.
  ///
  /// [color] - The color of the indicator dot.
  /// [size] - The diameter of the indicator dot. Defaults to 6.
  ///
  /// Example:
  /// ```dart
  /// EventIndicator(
  ///   color: event.color,
  ///   size: 10,
  /// )
  /// ```
  const EventIndicator({
    super.key,
    required this.color,
    this.size = 6,
  });

  /// The color of the indicator dot.
  final Color color;

  /// The diameter of the indicator dot in logical pixels.
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
