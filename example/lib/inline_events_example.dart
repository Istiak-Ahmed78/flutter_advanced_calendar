import 'package:flutter/material.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';

class InlineEventsExample extends StatefulWidget {
  const InlineEventsExample({super.key});

  @override
  State<InlineEventsExample> createState() => _InlineEventsExampleState();
}

class _InlineEventsExampleState extends State<InlineEventsExample> {
  late CalendarController _controller;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _selectedDate = DateTime.now();
    _addSampleEvents();
  }

  void _addSampleEvents() {
    _controller.addEvents([
      CalendarEvent(
        id: '1',
        title: 'Meeting',
        startDate: DateTime(2025, 1, 15, 10, 0),
        endDate: DateTime(2025, 1, 15, 11, 0),
        color: Colors.red,
      ),
      CalendarEvent(
        id: '2',
        title: 'Conference',
        startDate: DateTime(2025, 1, 15, 14, 0),
        endDate: DateTime(2025, 1, 15, 15, 0),
        color: Colors.blue,
      ),
      CalendarEvent(
        id: '3',
        title: 'Lunch',
        startDate: DateTime(2025, 1, 16, 12, 0),
        endDate: DateTime(2025, 1, 16, 13, 0),
        color: Colors.orange,
      ),
      CalendarEvent(
        id: '4',
        title: 'Workshop',
        startDate: DateTime(2025, 1, 20, 9, 0),
        endDate: DateTime(2025, 1, 20, 17, 0),
        color: Colors.purple,
      ),
    ]);
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
        title: const Text('Inline Events'),
      ),
      body: Column(
        children: [
          // Calendar at top
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: MonthView(
              controller: _controller,
              config: const CalendarConfig(
                showEventTime: false,
                maxEventsPerDay: 0, // Hide event indicators in calendar
              ),
              theme: CalendarTheme.light(),
              onDaySelected: (date) {
                setState(() {
                  _selectedDate = date;
                  _controller.selectDay(date);
                });
              },
            ),
          ),

          // Events list below
          Expanded(
            child: _buildEventsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList() {
    if (_selectedDate == null) {
      return const Center(child: Text('Select a date'));
    }

    final events = _controller.getEventsForDay(_selectedDate!);

    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No events for this day',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              width: 4,
              height: 40,
              color: event.color,
            ),
            title: Text(
              event.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${_formatTime(event.startDate)} - ${_formatTime(event.endDate)}',
            ),
            trailing: Icon(Icons.chevron_right, color: event.color),
            onTap: () {
              // Show event details
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(event.title),
                  content: Text(
                    'Time: ${_formatTime(event.startDate)} - ${_formatTime(event.endDate)}',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
