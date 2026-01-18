import 'package:flutter/material.dart';
import 'package:flutter_calendar_pro/flutter_calendar_pro.dart';

/// Timeline view example - Resource scheduling and booking
class TimelineViewExample extends StatefulWidget {
  const TimelineViewExample({super.key});

  @override
  State<TimelineViewExample> createState() => _TimelineViewExampleState();
}

class _TimelineViewExampleState extends State<TimelineViewExample> {
  late CalendarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController(
      initialView: CalendarView.timeline,
    );

    // Add sample events for different resources
    _controller.addEvents(_getTimelineEvents());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<CalendarEvent> _getTimelineEvents() {
    final today = DateTime.now();
    return [
      CalendarEvent(
        id: 'meeting_room_a_1',
        title: 'Team Standup',
        startDate: DateTime(today.year, today.month, today.day, 9, 0),
        endDate: DateTime(today.year, today.month, today.day, 10, 0),
        color: Colors.blue,
        category: 'Meeting Room A',
      ),
      CalendarEvent(
        id: 'meeting_room_b_1',
        title: 'Client Call',
        startDate: DateTime(today.year, today.month, today.day, 11, 0),
        endDate: DateTime(today.year, today.month, today.day, 12, 0),
        color: Colors.green,
        category: 'Meeting Room B',
      ),
      CalendarEvent(
        id: 'conference_hall_1',
        title: 'All Hands Meeting',
        startDate: DateTime(today.year, today.month, today.day, 14, 0),
        endDate: DateTime(today.year, today.month, today.day, 16, 0),
        color: Colors.purple,
        category: 'Conference Hall',
      ),
      CalendarEvent(
        id: 'training_room_1',
        title: 'Flutter Workshop',
        startDate: DateTime(today.year, today.month, today.day, 10, 0),
        endDate: DateTime(today.year, today.month, today.day, 12, 0),
        color: Colors.orange,
        category: 'Training Room',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timeline View'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfo,
            tooltip: 'About Timeline View',
          ),
        ],
      ),
      body: AdvancedCalendar(
        controller: _controller,
        config: const CalendarConfig(
          initialView: CalendarView.timeline,
          show24HourFormat: true,
          showEventTime: true,
          showEventLocation: false,
        ),
        timelineColumns: const [
          'Meeting Room A',
          'Meeting Room B',
          'Conference Hall',
          'Training Room',
        ],
        onEventTap: (event) {
          _showEventDetails(event);
        },
        onTimeSlotTap: (dateTime, resource) {
          _showBookingDialog(dateTime, resource);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBookingDialog(DateTime.now(), 'Meeting Room A'),
        backgroundColor: Colors.deepPurple,
        tooltip: 'Quick Book',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.view_timeline, color: Colors.deepPurple),
            SizedBox(width: 12),
            Text('Timeline View'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Perfect for:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text('• Resource booking & scheduling'),
            Text('• Meeting room management'),
            Text('• Equipment reservations'),
            Text('• Staff shift planning'),
            Text('• Event venue coordination'),
            SizedBox(height: 12),
            Text(
              'Tap any time slot to book a resource!',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showBookingDialog(DateTime dateTime, String resource) {
    final titleController = TextEditingController();
    TimeOfDay startTime = TimeOfDay.fromDateTime(dateTime);
    TimeOfDay endTime = TimeOfDay(
      hour: startTime.hour + 1,
      minute: startTime.minute,
    );

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Book $resource'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Event Title',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.access_time),
                      label: Text(_formatTimeOfDay(startTime)),
                      onPressed: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: startTime,
                        );
                        if (time != null) {
                          setDialogState(() => startTime = time);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('to'),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.access_time),
                      label: Text(_formatTimeOfDay(endTime)),
                      onPressed: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: endTime,
                        );
                        if (time != null) {
                          setDialogState(() => endTime = time);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  final now = DateTime.now();
                  final startDate = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    startTime.hour,
                    startTime.minute,
                  );
                  final endDate = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    endTime.hour,
                    endTime.minute,
                  );

                  final event = CalendarEvent(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleController.text,
                    startDate: startDate,
                    endDate: endDate,
                    color: _getResourceColor(resource),
                    category: resource,
                  );

                  _controller.addEvent(event);
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$resource booked successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text('Book', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
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
            _buildDetailRow(Icons.meeting_room, event.category ?? 'Unknown'),
            const SizedBox(height: 12),
            _buildDetailRow(
              Icons.access_time,
              '${_formatTime(event.startDate)} - ${_formatTime(event.endDate)}',
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              Icons.schedule,
              '${event.durationInMinutes} minutes',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _controller.removeEvent(event.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Booking cancelled'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Cancel Booking',
                style: TextStyle(color: Colors.red)),
          ),
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

  Color _getResourceColor(String resource) {
    switch (resource) {
      case 'Meeting Room A':
        return Colors.blue;
      case 'Meeting Room B':
        return Colors.green;
      case 'Conference Hall':
        return Colors.purple;
      case 'Training Room':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime time) {
    final hour =
        time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}
