import 'package:flutter/material.dart';
import '../core/controllers/calendar_controller.dart';
import '../core/models/calendar_config.dart';
import '../core/models/calendar_event.dart';
import '../themes/calendar_theme.dart';

class TimelineView extends StatefulWidget {
  const TimelineView({
    super.key,
    required this.controller,
    required this.config,
    required this.theme,
    this.onEventTap,
    this.onTimeSlotTap,
    this.columns = const ['Room #1', 'Room #2', 'Room #3', 'Room #4'],
  });

  final CalendarController controller;
  final CalendarConfig config;
  final CalendarTheme theme;
  final void Function(CalendarEvent)? onEventTap;
  final void Function(DateTime, String)? onTimeSlotTap;
  final List<String> columns;

  @override
  State<TimelineView> createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView> {
  // ✅ Shared scroll controllers to keep time and content in sync
  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void dispose() {
    _verticalScrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          _buildColumnHeaders(),
          Expanded(
            child: Row(
              children: [
                _buildTimeColumn(), // ✅ Fixed time column (no scroll)
                Expanded(
                  child: _buildScrollableContent(), // ✅ Only content scrolls
                ),
              ],
            ),
          ),
        ],
      );

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
            // ✅ Fixed time header
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
            // ✅ Scrollable column headers (synced with content)
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

  Widget _buildTimeColumn() => Container(
        width: 60,
        decoration: BoxDecoration(
          color: widget.theme.weekdayBackgroundColor,
          border: Border(
            right: BorderSide(color: widget.theme.borderColor),
          ),
        ),
        // ✅ Fixed time column - uses same scroll controller as content
        child: ListView.builder(
          controller: _verticalScrollController, // ✅ Synced with content
          itemCount: 24,
          itemBuilder: (context, hour) => Container(
            height: 60,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: widget.theme.borderColor.withValues(alpha: 0.3),
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
          ),
        ),
      );

  Widget _buildScrollableContent() => SingleChildScrollView(
        controller: _horizontalScrollController, // ✅ Synced with headers
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: widget.columns.length * 150.0,
          child: ListView.builder(
            controller: _verticalScrollController, // ✅ Synced with time column
            itemCount: 24,
            itemBuilder: (context, hour) => SizedBox(
              height: 60,
              child: Row(
                children: widget.columns
                    .map((column) => _buildTimeSlot(hour, column))
                    .toList(),
              ),
            ),
          ),
        ),
      );

  Widget _buildTimeSlot(int hour, String column) {
    final events = widget.controller
        .getEventsForDay(widget.controller.focusedDay)
        .where((event) =>
            event.startDate.hour == hour &&
            (event.category == column || event.location == column))
        .toList();

    return InkWell(
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
        child: events.isEmpty
            ? const SizedBox.shrink()
            : Stack(
                children: events
                    .map((event) => Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: InkWell(
                              onTap: () => widget.onEventTap?.call(event),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: event.color.withValues(alpha: 0.8),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                padding: const EdgeInsets.all(4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      // ✅ Prevent overflow
                                      child: Text(
                                        event.title,
                                        style: TextStyle(
                                          color: event.textColor ??
                                              _getTextColor(event.color),
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (!event.isAllDay)
                                      Flexible(
                                        // ✅ Prevent overflow
                                        child: Text(
                                          _formatTime(event.startDate),
                                          style: TextStyle(
                                            color: (event.textColor ??
                                                    _getTextColor(event.color))
                                                .withValues(alpha: 0.8),
                                            fontSize: 9,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
      ),
    );
  }

  // ✅ Helper method for text color
  Color _getTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }

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

  String _formatTime(DateTime time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}
