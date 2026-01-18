import 'package:flutter/material.dart';
import 'package:flutter_calendar_pro/flutter_calendar_pro.dart';
import '../../shared/sample_data.dart';

/// Week view example
class WeekViewExample extends StatefulWidget {
  const WeekViewExample({super.key});

  @override
  State<WeekViewExample> createState() => _WeekViewExampleState();
}

class _WeekViewExampleState extends State<WeekViewExample> {
  late CalendarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController(
      initialView: CalendarView.week,
    );

    // Add events
    _controller.addEvents(SampleData.getSimpleEvents());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Week View'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: AdvancedCalendar(
        controller: _controller,
        config: const CalendarConfig(
          initialView: CalendarView.week,
          weekStartDay: WeekStartDay.monday,
          show24HourFormat: true,
          showEventTime: true,
          showEventLocation: true,
        ),
        onDaySelected: (day) {
          final events = _controller.getEventsForDay(day);
          _showEventsDialog(day, events);
        },
        onEventTap: (event) {
          _showEventDetails(event);
        },
      ),
    );
  }

  void _showEventsDialog(DateTime day, List<CalendarEvent> events) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_formatDate(day)),
        content: events.isEmpty
            ? const Text('No events on this day')
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: events.map((event) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 4,
                      height: 40,
                      color: event.color,
                    ),
                    title: Text(event.title),
                    subtitle: Text(_formatEventTime(event)),
                  );
                }).toList(),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showEventDetails(CalendarEvent event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: event.color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(event.title)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(Icons.access_time, _formatEventTime(event)),
            if (event.description != null) ...[
              const SizedBox(height: 12),
              _buildDetailRow(Icons.description, event.description!),
            ],
            if (event.location != null) ...[
              const SizedBox(height: 12),
              _buildDetailRow(Icons.location_on, event.location!),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade800,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
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
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }

  String _formatEventTime(CalendarEvent event) {
    if (event.isAllDay) {
      return 'All day';
    }
    return '${_formatTime(event.startDate)} - ${_formatTime(event.endDate)}';
  }

  String _formatTime(DateTime time) {
    final hour =
        time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
