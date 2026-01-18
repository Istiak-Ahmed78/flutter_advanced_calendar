import 'package:flutter/material.dart';
import '../core/controllers/calendar_controller.dart';
import '../core/models/calendar_config.dart';
import '../core/models/calendar_event.dart';
import '../themes/calendar_theme.dart';

/// A multi-column timeline view displaying events across different resources.
///
/// The timeline view shows a horizontal grid with time slots on the vertical
/// axis and custom columns (e.g., rooms, resources, people) on the horizontal
/// axis. Events are positioned based on their time and assigned column.
///
/// Features:
/// - Multiple columns for different resources/categories
/// - 24-hour time grid (hourly slots)
/// - Synchronized horizontal scrolling
/// - Events positioned by time and column
/// - Event duration visualization
/// - Tap handling for events and empty slots
/// - 12/24 hour format support
/// - Automatic text color contrast
///
/// Use Cases:
/// - Room booking systems
/// - Resource scheduling
/// - Multi-person calendars
/// - Equipment reservation
/// - Meeting room management
///
/// Example:
/// ```dart
/// TimelineView(
///   controller: calendarController,
///   config: CalendarConfig(show24HourFormat: true),
///   theme: CalendarTheme.light(),
///   columns: ['Conference Room A', 'Conference Room B', 'Meeting Room 1'],
///   onEventTap: (event) {
///     print('Event: ${event.title}');
///   },
///   onTimeSlotTap: (time, column) {
///     print('Create booking at $time in $column');
///   },
/// )
/// ```
class TimelineView extends StatefulWidget {
  /// Creates a timeline view.
  ///
  /// [controller] - The calendar controller managing state and events.
  /// [config] - Configuration for display options (time format, etc.).
  /// [theme] - Theme configuration for visual styling.
  /// [onEventTap] - Optional callback when an event is tapped.
  /// [onTimeSlotTap] - Optional callback when an empty time slot is tapped.
  ///   Receives the DateTime and column name.
  /// [columns] - List of column names to display (e.g., room names).
  ///   Defaults to 4 generic rooms.
  ///
  /// **Column Matching:**
  /// Events are assigned to columns based on their `category` or `location`
  /// property matching a column name.
  ///
  /// Example:
  /// ```dart
  /// TimelineView(
  ///   controller: myController,
  ///   config: CalendarConfig(show24HourFormat: false),
  ///   theme: CalendarTheme.dark(),
  ///   columns: ['Dr. Smith', 'Dr. Jones', 'Dr. Brown'],
  ///   onEventTap: (event) => showEventDetails(event),
  ///   onTimeSlotTap: (time, doctor) {
  ///     createAppointment(time, doctor);
  ///   },
  /// )
  /// ```
  const TimelineView({
    super.key,
    required this.controller,
    required this.config,
    required this.theme,
    this.onEventTap,
    this.onTimeSlotTap,
    this.columns = const ['Room #1', 'Room #2', 'Room #3', 'Room #4'],
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
  /// Parameters:
  /// - DateTime: The start time of the tapped hour slot
  /// - String: The column name where the slot was tapped
  final void Function(DateTime, String)? onTimeSlotTap;

  /// List of column names to display horizontally.
  ///
  /// Each column typically represents a resource, room, person, or category.
  /// Events are matched to columns based on their `category` or `location`.
  final List<String> columns;

  @override
  State<TimelineView> createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView> {
  late final ScrollController _horizontalScrollController;
  late final ScrollController _contentHorizontalScrollController;
  bool _isHorizontalScrolling = false;

  @override
  void initState() {
    super.initState();
    _horizontalScrollController = ScrollController();
    _contentHorizontalScrollController = ScrollController();
    _horizontalScrollController.addListener(_onHeaderScroll);
    _contentHorizontalScrollController.addListener(_onContentScroll);
  }

  @override
  void dispose() {
    _horizontalScrollController.removeListener(_onHeaderScroll);
    _contentHorizontalScrollController.removeListener(_onContentScroll);
    _horizontalScrollController.dispose();
    _contentHorizontalScrollController.dispose();
    super.dispose();
  }

  /// Synchronizes header scroll with content scroll.
  void _onHeaderScroll() {
    if (!_isHorizontalScrolling &&
        _contentHorizontalScrollController.hasClients) {
      _isHorizontalScrolling = true;
      _contentHorizontalScrollController
          .jumpTo(_horizontalScrollController.offset);
      _isHorizontalScrolling = false;
    }
  }

  /// Synchronizes content scroll with header scroll.
  void _onContentScroll() {
    if (!_isHorizontalScrolling && _horizontalScrollController.hasClients) {
      _isHorizontalScrolling = true;
      _horizontalScrollController
          .jumpTo(_contentHorizontalScrollController.offset);
      _isHorizontalScrolling = false;
    }
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          _buildColumnHeaders(),
          Expanded(child: _buildTimelineBody()),
        ],
      );

  /// Builds the column headers row showing resource/room names.
  Widget _buildColumnHeaders() => Container(
        height: 50,
        decoration: BoxDecoration(
          color: widget.theme.headerBackgroundColor,
          border: Border(
            bottom: BorderSide(color: widget.theme.borderColor),
          ),
        ),
        child: Row(
          children: [
            // Time label
            SizedBox(
              width: 60,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: widget.theme.borderColor),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Time',
                    style: TextStyle(
                      color: widget.theme.headerTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
            // Column headers (scrollable)
            Expanded(
              child: SingleChildScrollView(
                controller: _horizontalScrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: widget.columns
                      .map((column) => Container(
                            width: 150,
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                    color: widget.theme.borderColor,
                                    width: 0.5),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                column,
                                style: TextStyle(
                                  color: widget.theme.headerTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      );

  /// Builds the main timeline body with time slots and events.
  Widget _buildTimelineBody() => SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimeColumn(),
            _buildContentArea(),
          ],
        ),
      );

  /// Builds the time column showing hourly labels (00:00 - 23:00).
  Widget _buildTimeColumn() => Container(
        width: 60,
        decoration: BoxDecoration(
          color: widget.theme.weekdayBackgroundColor,
          border: Border(
            right: BorderSide(color: widget.theme.borderColor),
          ),
        ),
        child: Column(
          children: List.generate(
              24,
              (hour) => Container(
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color:
                              widget.theme.borderColor.withValues(alpha: 0.3),
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _formatHour(hour),
                        style: TextStyle(
                          fontSize: 11,
                          color: widget.theme.weekdayTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )),
        ),
      );

  /// Builds the scrollable content area with grid and events.
  Widget _buildContentArea() => Expanded(
        child: SingleChildScrollView(
          controller: _contentHorizontalScrollController,
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: widget.columns.length * 150.0,
            child: Stack(
              children: [
                _buildBackgroundGrid(),
                ..._buildAllSpanningEvents(),
              ],
            ),
          ),
        ),
      );

  /// Builds the background grid of empty time slots.
  Widget _buildBackgroundGrid() => Column(
        children: List.generate(
            24,
            (hour) => SizedBox(
                  height: 60,
                  child: Row(
                    children: widget.columns
                        .map((column) => _buildEmptyTimeSlot(hour, column))
                        .toList(),
                  ),
                )),
      );

  /// Builds an empty time slot cell with tap handling.
  ///
  /// [hour] - The hour (0-23) for this slot.
  /// [column] - The column name for this slot.
  Widget _buildEmptyTimeSlot(int hour, String column) => InkWell(
        onTap: () {
          final timeSlot = DateTime(
            widget.controller.focusedDay.year,
            widget.controller.focusedDay.month,
            widget.controller.focusedDay.day,
            hour,
          );
          widget.onTimeSlotTap?.call(timeSlot, column);
        },
        child: Container(
          width: 150,
          height: 60,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                  color: widget.theme.borderColor.withValues(alpha: 0.3),
                  width: 0.5),
              bottom: BorderSide(
                  color: widget.theme.borderColor.withValues(alpha: 0.3),
                  width: 0.5),
            ),
          ),
        ),
      );

  /// Builds all events as positioned widgets overlaying the grid.
  ///
  /// Events are matched to columns based on their `category` or `location`.
  List<Widget> _buildAllSpanningEvents() {
    final allEvents =
        widget.controller.getEventsForDay(widget.controller.focusedDay);
    final spanningEvents = <Widget>[];

    for (var columnIndex = 0;
        columnIndex < widget.columns.length;
        columnIndex++) {
      final column = widget.columns[columnIndex];

      // Filter events for this column
      final columnEvents = allEvents
          .where((event) =>
              (event.category == column) || (event.location == column))
          .toList();

      // Create positioned widgets for each event
      for (final event in columnEvents) {
        spanningEvents.add(_buildSpanningEventWidget(event, columnIndex));
      }
    }

    return spanningEvents;
  }

  /// Builds an individual event widget with proper time-based positioning.
  ///
  /// [event] - The event to display.
  /// [columnIndex] - The column index (0-based) where the event belongs.
  Widget _buildSpanningEventWidget(CalendarEvent event, int columnIndex) {
    final eventStartHour = event.startDate.hour;
    final eventStartMinute = event.startDate.minute;
    final eventEndHour = event.endDate.hour;
    final eventEndMinute = event.endDate.minute;

    // Calculate horizontal position
    final leftOffset = columnIndex * 150.0 + 2;

    // Calculate vertical position (aligned with time slot centers)
    final baseTopOffset =
        (eventStartHour * 60.0) + (eventStartMinute / 60.0 * 60.0);
    const centerOffset = 30.0; // Half of time slot height
    final topOffset = baseTopOffset + centerOffset;

    // Calculate event height based on duration
    final startTotalMinutes = (eventStartHour * 60) + eventStartMinute;
    final endTotalMinutes = (eventEndHour * 60) + eventEndMinute;
    final durationMinutes = endTotalMinutes - startTotalMinutes;
    var totalHeight = (durationMinutes / 60.0) * 60.0;

    // Ensure minimum height for visibility
    if (totalHeight < 15) {
      totalHeight = 15;
    }

    return Positioned(
      left: leftOffset,
      top: topOffset,
      width: 150 - 4, // Column width minus padding
      height: totalHeight,
      child: InkWell(
        onTap: () => widget.onEventTap?.call(event),
        child: Container(
          decoration: BoxDecoration(
            color: event.color.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: event.color),
          ),
          padding: const EdgeInsets.all(4),
          child: _buildEventContent(event, totalHeight),
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
      children: [
        // Title (always shown)
        Text(
          event.title,
          style: TextStyle(
            color: textColor,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        // Time (shown if height > 25)
        if (!event.isAllDay && height > 25) ...[
          const SizedBox(height: 2),
          Text(
            '${_formatTime(event.startDate)} - ${_formatTime(event.endDate)}',
            style: TextStyle(
              color: textColor.withValues(alpha: 0.8),
              fontSize: 9,
            ),
          ),
        ],
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

  /// Formats an hour in 12 or 24-hour format based on config.
  ///
  /// [hour] - The hour to format (0-23).
  ///
  /// Returns formatted hour string (e.g., "9 AM" or "09:00").
  String _formatHour(int hour) {
    if (widget.config.show24HourFormat) {
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

  /// Formats a time as "HH:MM" in 24-hour format.
  ///
  /// [time] - The time to format.
  ///
  /// Returns formatted time string (e.g., "09:30").
  String _formatTime(DateTime time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}
