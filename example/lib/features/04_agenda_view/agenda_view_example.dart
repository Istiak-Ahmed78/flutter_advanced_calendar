import 'package:flutter/material.dart';
import 'package:flutter_calendar_pro/flutter_calendar_pro.dart';
import '../../shared/sample_data.dart';

/// Agenda view example - List of upcoming events
class AgendaViewExample extends StatefulWidget {
  const AgendaViewExample({super.key});

  @override
  State<AgendaViewExample> createState() => _AgendaViewExampleState();
}

class _AgendaViewExampleState extends State<AgendaViewExample> {
  late CalendarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController(
      initialView: CalendarView.agenda,
    );

    // Load static events
    _controller.addEvents(SampleData.getEvents());
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
        title: const Text('Agenda View'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: AdvancedCalendar(
        controller: _controller,
        config: const CalendarConfig(
          initialView: CalendarView.agenda,
          showEventTime: true,
          showEventLocation: true,
        ),
        onEventTap: (event) {
          _showEventDetails(event);
        },
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
            _buildDetailRow(
              Icons.calendar_today,
              _formatDate(event.startDate),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              Icons.access_time,
              event.isAllDay
                  ? 'All day'
                  : '${_formatTime(event.startDate)} - ${_formatTime(event.endDate)}',
            ),
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
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTime(DateTime time) {
    final hour =
        time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
