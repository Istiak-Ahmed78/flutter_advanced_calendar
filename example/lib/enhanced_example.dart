import 'package:flutter/material.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';

class EnhancedCalendarExample extends StatefulWidget {
  const EnhancedCalendarExample({super.key});

  @override
  State<EnhancedCalendarExample> createState() =>
      _EnhancedCalendarExampleState();
}

class _EnhancedCalendarExampleState extends State<EnhancedCalendarExample> {
  late CalendarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _addSampleEvents();
  }

  void _addSampleEvents() {
    _controller.addEvents([
      CalendarEvent(
        id: '1',
        title: 'Team Meeting',
        description: 'Weekly team sync-up',
        startDate: DateTime.now().add(const Duration(days: 1, hours: 10)),
        endDate: DateTime.now().add(const Duration(days: 1, hours: 11)),
        color: Colors.blue,
        icon: Icons.people,
        location: 'Conference Room A',
      ),
      CalendarEvent(
        id: '2',
        title: 'Lunch Break',
        description: 'Time to eat!',
        startDate: DateTime.now().add(const Duration(hours: 12)),
        endDate: DateTime.now().add(const Duration(hours: 13)),
        color: Colors.orange,
        icon: Icons.restaurant,
        isAllDay: false,
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
        title: const Text('Enhanced Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEventDialog(context),
            tooltip: 'Add Event',
          ),
        ],
      ),
      body: AdvancedCalendar(
        controller: _controller,
        config: const CalendarConfig(
          showEventTime: true,
          showEventLocation: true,
          showEventIcon: true,
          enableLongPress: true,
        ),
        onDaySelected: (date) {
          // Show events for selected day
          _showDayEventsBottomSheet(context, date);
        },
        onDayLongPressed: (date) {
          // Quick add event on long press
          _showAddEventDialog(context, preselectedDate: date);
        },
        onEventTap: (event) {
          // Show event details
          _showEventDetailsDialog(context, event);
        },
      ),
    );
  }

  // ==================== Show Day Events Bottom Sheet ====================
  void _showDayEventsBottomSheet(BuildContext context, DateTime date) {
    final events = _controller.getEventsForDay(date);

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.pop(context);
                    _showAddEventDialog(context, preselectedDate: date);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (events.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'No events for this day',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ...events.map((event) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: event.color,
                      child:
                          Icon(event.icon ?? Icons.event, color: Colors.white),
                    ),
                    title: Text(event.title),
                    subtitle: Text(
                      event.isAllDay
                          ? 'All day'
                          : '${_formatTime(event.startDate)} - ${_formatTime(event.endDate)}',
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showEventDetailsDialog(context, event);
                    },
                  )),
          ],
        ),
      ),
    );
  }

  // ==================== Show Event Details Dialog ====================
  void _showEventDetailsDialog(BuildContext context, CalendarEvent event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(event.icon ?? Icons.event, color: event.color),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                event.title,
                style: TextStyle(color: event.color),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (event.description != null &&
                  event.description!.isNotEmpty) ...[
                const Text(
                  'Description',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(event.description!),
                const SizedBox(height: 16),
              ],
              const Text(
                'Time',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                event.isAllDay
                    ? 'All day'
                    : '${_formatDateTime(event.startDate)} - ${_formatDateTime(event.endDate)}',
              ),
              if (event.location != null) ...[
                const SizedBox(height: 16),
                const Text(
                  'Location',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(event.location!),
              ],
              if (event.isMultiDay) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: event.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Multi-day event (${event.getTotalDays} days)',
                    style: TextStyle(
                      color: event.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showEditEventDialog(context, event);
            },
            child: const Text('Edit'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteEvent(event.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // ==================== Show Add Event Dialog ====================
  void _showAddEventDialog(BuildContext context, {DateTime? preselectedDate}) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final locationController = TextEditingController();

    DateTime selectedStartDate = preselectedDate ?? _controller.focusedDay;
    DateTime selectedEndDate = selectedStartDate.add(const Duration(hours: 1));
    TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 0);
    TimeOfDay endTime = const TimeOfDay(hour: 10, minute: 0);
    bool isAllDay = false;
    bool isMultiDay = false; // NEW
    Color selectedColor = Colors.blue;
    IconData selectedIcon = Icons.event;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Event'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
                const SizedBox(height: 16),

                // NEW: Multi-day toggle
                SwitchListTile(
                  title: const Text('Multi-day event'),
                  value: isMultiDay,
                  onChanged: (value) => setState(() => isMultiDay = value),
                ),

                if (isMultiDay) ...[
                  // Date range picker
                  ListTile(
                    title: const Text('Date Range'),
                    subtitle: Text(
                      '${selectedStartDate.day}/${selectedStartDate.month}/${selectedStartDate.year} - '
                      '${selectedEndDate.day}/${selectedEndDate.month}/${selectedEndDate.year}',
                    ),
                    trailing: const Icon(Icons.date_range),
                    onTap: () async {
                      final range = await _showDateRangePicker(
                          context, selectedStartDate);
                      if (range != null) {
                        setState(() {
                          selectedStartDate = range.start;
                          selectedEndDate = range.end;
                        });
                      }
                    },
                  ),
                ] else ...[
                  // Single date picker
                  ListTile(
                    title: const Text('Date'),
                    subtitle: Text(
                      '${selectedStartDate.day}/${selectedStartDate.month}/${selectedStartDate.year}',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedStartDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (date != null) {
                        setState(() {
                          selectedStartDate = date;
                          selectedEndDate = date;
                        });
                      }
                    },
                  ),
                ],

                SwitchListTile(
                  title: const Text('All day'),
                  value: isAllDay,
                  onChanged: (value) => setState(() => isAllDay = value),
                ),

                if (!isAllDay && !isMultiDay) ...[
                  ListTile(
                    title: const Text('Start time'),
                    subtitle: Text(startTime.format(context)),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: startTime,
                      );
                      if (time != null) {
                        setState(() => startTime = time);
                      }
                    },
                  ),
                  ListTile(
                    title: const Text('End time'),
                    subtitle: Text(endTime.format(context)),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: endTime,
                      );
                      if (time != null) {
                        setState(() => endTime = time);
                      }
                    },
                  ),
                ],

                const SizedBox(height: 16),
                const Text('Color:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Colors.blue,
                    Colors.green,
                    Colors.orange,
                    Colors.red,
                    Colors.purple,
                    Colors.teal,
                  ]
                      .map((color) => GestureDetector(
                            onTap: () => setState(() => selectedColor = color),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: selectedColor == color
                                    ? Border.all(color: Colors.black, width: 2)
                                    : null,
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),
                const Text('Icon:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Icons.event,
                    Icons.work,
                    Icons.people,
                    Icons.restaurant,
                    Icons.sports_soccer,
                    Icons.flight,
                  ]
                      .map((icon) => GestureDetector(
                            onTap: () => setState(() => selectedIcon = icon),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: selectedIcon == icon
                                    ? selectedColor.withValues(alpha: 0.2)
                                    : Colors.grey.shade200,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(icon, size: 18),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a title')),
                  );
                  return;
                }

                DateTime finalStartDate;
                DateTime finalEndDate;

                if (isMultiDay) {
                  finalStartDate = selectedStartDate;
                  finalEndDate = DateTime(
                    selectedEndDate.year,
                    selectedEndDate.month,
                    selectedEndDate.day,
                    23,
                    59,
                  );
                } else if (isAllDay) {
                  finalStartDate = DateTime(
                    selectedStartDate.year,
                    selectedStartDate.month,
                    selectedStartDate.day,
                  );
                  finalEndDate = DateTime(
                    selectedStartDate.year,
                    selectedStartDate.month,
                    selectedStartDate.day,
                    23,
                    59,
                  );
                } else {
                  finalStartDate = DateTime(
                    selectedStartDate.year,
                    selectedStartDate.month,
                    selectedStartDate.day,
                    startTime.hour,
                    startTime.minute,
                  );
                  finalEndDate = DateTime(
                    selectedStartDate.year,
                    selectedStartDate.month,
                    selectedStartDate.day,
                    endTime.hour,
                    endTime.minute,
                  );
                }

                final event = CalendarEvent(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  description: descriptionController.text.isEmpty
                      ? null
                      : descriptionController.text,
                  location: locationController.text.isEmpty
                      ? null
                      : locationController.text,
                  startDate: finalStartDate,
                  endDate: finalEndDate,
                  isAllDay: isAllDay,
                  color: selectedColor,
                  icon: selectedIcon,
                );

                _controller.addEvent(event);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Event added successfully')),
                );
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== Show Edit Event Dialog ====================
  void _showEditEventDialog(BuildContext context, CalendarEvent event) {
    final titleController = TextEditingController(text: event.title);
    final descriptionController =
        TextEditingController(text: event.description ?? '');
    final locationController =
        TextEditingController(text: event.location ?? '');

    DateTime selectedDate = event.startDate;
    TimeOfDay startTime = TimeOfDay.fromDateTime(event.startDate);
    TimeOfDay endTime = TimeOfDay.fromDateTime(event.endDate);
    bool isAllDay = event.isAllDay;
    Color selectedColor = event.color;
    IconData selectedIcon = event.icon ?? Icons.event;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Event'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Date'),
                  subtitle: Text(
                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (date != null) {
                      setState(() => selectedDate = date);
                    }
                  },
                ),
                SwitchListTile(
                  title: const Text('All day'),
                  value: isAllDay,
                  onChanged: (value) => setState(() => isAllDay = value),
                ),
                if (!isAllDay) ...[
                  ListTile(
                    title: const Text('Start time'),
                    subtitle: Text(startTime.format(context)),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: startTime,
                      );
                      if (time != null) {
                        setState(() => startTime = time);
                      }
                    },
                  ),
                  ListTile(
                    title: const Text('End time'),
                    subtitle: Text(endTime.format(context)),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: endTime,
                      );
                      if (time != null) {
                        setState(() => endTime = time);
                      }
                    },
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Color: '),
                    const SizedBox(width: 8),
                    ...[
                      Colors.blue,
                      Colors.green,
                      Colors.orange,
                      Colors.red,
                      Colors.purple,
                      Colors.teal,
                    ].map((color) => GestureDetector(
                          onTap: () => setState(() => selectedColor = color),
                          child: Container(
                            width: 32,
                            height: 32,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: selectedColor == color
                                  ? Border.all(color: Colors.black, width: 2)
                                  : null,
                            ),
                          ),
                        )),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Icon: '),
                    const SizedBox(width: 8),
                    ...[
                      Icons.event,
                      Icons.work,
                      Icons.people,
                      Icons.restaurant,
                      Icons.sports_soccer,
                      Icons.flight,
                    ].map((icon) => GestureDetector(
                          onTap: () => setState(() => selectedIcon = icon),
                          child: Container(
                            width: 32,
                            height: 32,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: selectedIcon == icon
                                  ? selectedColor.withValues(alpha: 0.2)
                                  : Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(icon, size: 18),
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a title')),
                  );
                  return;
                }

                final startDateTime = isAllDay
                    ? DateTime(
                        selectedDate.year, selectedDate.month, selectedDate.day)
                    : DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        startTime.hour,
                        startTime.minute,
                      );

                final endDateTime = isAllDay
                    ? DateTime(selectedDate.year, selectedDate.month,
                        selectedDate.day, 23, 59)
                    : DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        endTime.hour,
                        endTime.minute,
                      );

                final updatedEvent = event.copyWith(
                  title: titleController.text,
                  description: descriptionController.text.isEmpty
                      ? null
                      : descriptionController.text,
                  location: locationController.text.isEmpty
                      ? null
                      : locationController.text,
                  startDate: startDateTime,
                  endDate: endDateTime,
                  isAllDay: isAllDay,
                  color: selectedColor,
                  icon: selectedIcon,
                );

                _controller.updateEvent(event.id, updatedEvent);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Event updated successfully')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== Delete Event ====================
  void _deleteEvent(String eventId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _controller.removeEvent(eventId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Event deleted')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // ==================== Helper Methods ====================
  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${_formatTime(dateTime)}';
  }
}
// Add this method to enhanced_example.dart

Future<DateTimeRange?> _showDateRangePicker(
    BuildContext context, DateTime initialDate) async {
  return await showDateRangePicker(
    context: context,
    firstDate: DateTime(2020),
    lastDate: DateTime(2030),
    initialDateRange: DateTimeRange(
      start: initialDate,
      end: initialDate.add(const Duration(days: 1)),
    ),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors.blue,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Colors.black,
          ),
        ),
        child: child!,
      );
    },
  );
}
