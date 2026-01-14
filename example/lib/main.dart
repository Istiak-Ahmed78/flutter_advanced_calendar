import 'package:flutter/material.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Calendar Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const CalendarDemoPage(),
    );
  }
}

class CalendarDemoPage extends StatefulWidget {
  const CalendarDemoPage({super.key});

  @override
  State<CalendarDemoPage> createState() => _CalendarDemoPageState();
}

class _CalendarDemoPageState extends State<CalendarDemoPage> {
  late CalendarController _controller;
  late CalendarConfig _config;
  CalendarTheme _theme = CalendarTheme.light();
  final bool _hideWeekends = false;
  final bool _showHolidays = true;
  final bool _showEventDots = true;
  final bool _enableRangeSelection = false;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController(
      initialDate: DateTime.now(),
      initialView: CalendarView.month,
    );

    final holidayDates = _getHolidayDates();
    final holidayNames = _getHolidayNames();

    _config = CalendarConfig(
      enableRangeSelection: _enableRangeSelection,
      hideWeekends: _hideWeekends,
      showHolidays: _showHolidays,
      showEventDots: _showEventDots,
      maxEventDotsPerDay: 3,
      allowSameDayRange: true,
      enableVerticalScroll: false,
      show24HourFormat: false,
      showEventTime: true,
      holidays: holidayDates,
      holidayNames: holidayNames,
    );

    _addSampleEvents();
    _addHolidaysToController(holidayDates);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addSampleEvents() {
    final now = DateTime.now();

    _controller.addEvents([
      CalendarEvent(
        id: '1',
        title: 'Team Meeting',
        startDate: DateTime(now.year, now.month, now.day, 10, 0),
        endDate: DateTime(now.year, now.month, now.day, 11, 0),
        color: Colors.blue,
        dotColor: Colors.blue.shade700,
        category: 'Work',
        priority: EventPriority.high,
      ),
      CalendarEvent(
        id: '2',
        title: 'Lunch Break',
        startDate: DateTime(now.year, now.month, now.day, 12, 0),
        endDate: DateTime(now.year, now.month, now.day, 13, 0),
        color: Colors.orange,
        dotColor: Colors.deepOrange,
        category: 'Personal',
      ),
      CalendarEvent(
        id: '3',
        title: 'Project Deadline',
        startDate: DateTime(now.year, now.month, now.day + 2, 9, 0),
        endDate: DateTime(now.year, now.month, now.day + 2, 17, 0),
        color: Colors.red,
        dotColor: Colors.red.shade900,
        priority: EventPriority.urgent,
        category: 'Work',
      ),
      CalendarEvent(
        id: '4',
        title: 'Conference',
        startDate: DateTime(now.year, now.month, now.day + 5),
        endDate: DateTime(now.year, now.month, now.day + 7),
        color: Colors.purple,
        dotColor: Colors.deepPurple,
        isAllDay: true,
        category: 'Work',
      ),
      CalendarEvent(
        id: '5',
        title: 'Gym',
        startDate: DateTime(now.year, now.month, now.day + 1, 18, 0),
        endDate: DateTime(now.year, now.month, now.day + 1, 19, 30),
        color: Colors.green,
        dotColor: Colors.teal,
        category: 'Health',
        recurrenceRule: RecurrenceRule(
          frequency: RecurrenceFrequency.daily,
          interval: 1,
          endCondition: RecurrenceEnd.count(10),
        ),
      ),
      CalendarEvent(
        id: '6',
        title: 'Birthday Party 🎉',
        startDate: DateTime(now.year, now.month, now.day + 3),
        endDate: DateTime(now.year, now.month, now.day + 3),
        color: Colors.pink,
        dotColor: Colors.pink.shade700,
        isAllDay: true,
        category: 'Personal',
      ),
      CalendarEvent(
        id: '7',
        title: 'Team Standup',
        startDate: DateTime(now.year, now.month, now.day, 9, 0),
        endDate: DateTime(now.year, now.month, now.day, 9, 30),
        color: Colors.indigo,
        dotColor: Colors.indigo.shade800,
        category: 'Work',
        recurrenceRule: RecurrenceRule(
          frequency: RecurrenceFrequency.weekly,
          interval: 1,
          endCondition: RecurrenceEnd.count(4),
        ),
      ),
      CalendarEvent(
        id: '8',
        title: 'Workout',
        startDate: DateTime(now.year, now.month, now.day, 7, 0),
        endDate: DateTime(now.year, now.month, now.day, 8, 0),
        color: Colors.cyan,
        dotColor: Colors.cyan.shade700,
        category: 'Health',
        recurrenceRule: RecurrenceRule(
          frequency: RecurrenceFrequency.weekly,
          interval: 1,
          byWeekDay: [1, 3, 5],
          endCondition: RecurrenceEnd.count(12),
        ),
      ),
      CalendarEvent(
        id: '9',
        title: 'Monthly Review',
        startDate: DateTime(now.year, now.month, 1, 14, 0),
        endDate: DateTime(now.year, now.month, 1, 15, 0),
        color: Colors.deepOrange,
        dotColor: Colors.deepOrange.shade800,
        category: 'Work',
        priority: EventPriority.high,
        recurrenceRule: RecurrenceRule(
          frequency: RecurrenceFrequency.monthly,
          interval: 1,
          byMonthDay: [1],
          endCondition: RecurrenceEnd.count(6),
        ),
      ),
    ]);
  }

  List<DateTime> _getHolidayDates() {
    final now = DateTime.now();
    return [
      DateTime(now.year, 1, 1),
      DateTime(now.year, 12, 25),
      DateTime(now.year, now.month, now.day + 10),
    ];
  }

  Map<DateTime, String> _getHolidayNames() {
    final now = DateTime.now();
    return {
      DateTime(now.year, 1, 1): 'New Year\'s Day',
      DateTime(now.year, 12, 25): 'Christmas',
      DateTime(now.year, now.month, now.day + 10): 'Sample Holiday',
    };
  }

  void _addHolidaysToController(List<DateTime> holidays) {
    _controller.addHolidays(holidays);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Advanced Calendar Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsDialog,
            tooltip: 'Settings',
          ),
          IconButton(
            icon: const Icon(Icons.palette),
            onPressed: _showThemeDialog,
            tooltip: 'Change Theme',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: AdvancedCalendar(
              controller: _controller,
              config: _config,
              theme: _theme,
              onDaySelected: (date) {
                _showDayDetails(date);
              },
              onEventTap: (event) {
                _showEventDetails(event);
              },
              onRangeSelected: (start, end) {
                _showRangeDetails(start, end);
              },
            ),
          ),
          _buildInfoBar(),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70.0),
        child: FloatingActionButton(
          onPressed: _showAddEventDialog,
          tooltip: 'Add Event',
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildInfoBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border(top: BorderSide(color: Colors.blue[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildInfoItem(
              icon: Icons.event,
              label: 'Selected',
              value: _getSelectedInfo(),
            ),
          ),
          Expanded(
            child: _buildInfoItem(
              icon: Icons.calendar_today,
              label: 'Events',
              value: '${_controller.events.length}',
            ),
          ),
          Expanded(
            child: _buildInfoItem(
              icon: Icons.view_module,
              label: 'View',
              value: _controller.currentView.name.toUpperCase(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: Colors.blue[700]),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey[600]),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _getSelectedInfo() {
    if (_controller.hasRangeSelection) {
      final days = _controller.selectedRange.length;
      return '$days days';
    } else if (_controller.selectedDay != null) {
      return '1 day';
    }
    return 'None';
  }

  void _showDayDetails(DateTime date) {
    final events = _controller.getEventsForDay(date);
    final isHoliday = _config.isHoliday(date);
    final holidayName = _config.getHolidayName(date);

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: isHoliday ? Colors.red : Colors.blue,
                ),
                const SizedBox(width: 8),
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (isHoliday && holidayName != null) ...[
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.celebration, size: 16, color: Colors.red),
                    const SizedBox(width: 4),
                    Text(
                      holidayName,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              '${events.length} Event(s)',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...events.map((event) => ListTile(
                  leading: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: event.effectiveDotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: Text(event.title),
                  subtitle: Text(
                    event.isAllDay
                        ? 'All Day'
                        : '${event.startDate.hour}:${event.startDate.minute.toString().padLeft(2, '0')}',
                  ),
                  trailing: event.recurrenceRule != null
                      ? const Icon(Icons.repeat, size: 16)
                      : Icon(
                          _getPriorityIcon(event.priority),
                          color: _getPriorityColor(event.priority),
                        ),
                  onTap: () {
                    Navigator.pop(context);
                    _showEventDetails(event);
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showEventDetails(CalendarEvent event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(
              Icons.access_time,
              'Time',
              event.isAllDay
                  ? 'All Day'
                  : '${event.startDate.hour}:${event.startDate.minute.toString().padLeft(2, '0')} - ${event.endDate.hour}:${event.endDate.minute.toString().padLeft(2, '0')}',
            ),
            _buildDetailRow(
                Icons.category, 'Category', event.category ?? 'None'),
            _buildDetailRow(Icons.priority_high, 'Priority',
                event.priority.name.toUpperCase()),
            if (event.isMultiDay) ...[
              _buildDetailRow(
                Icons.date_range,
                'Duration',
                '${event.getTotalDays} days',
              ),
            ],
            if (event.recurrenceRule != null) ...[
              _buildDetailRow(
                Icons.repeat,
                'Recurring',
                event.recurrenceRule!.toString(),
              ),
            ],
            const SizedBox(height: 8),
            _buildDetailRow(Icons.palette, 'Colors', ''),
            Row(
              children: [
                const SizedBox(width: 32),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: event.color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 8),
                const Text('→'),
                const SizedBox(width: 8),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: event.effectiveDotColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 8),
                const Text('(Dot)'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _controller.removeEvent(event.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Event deleted')),
              );
            },
            child: const Text('Delete'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showRangeDetails(DateTime start, DateTime end) {
    final days = end.difference(start).inDays + 1;
    final events = _controller.getEventsForRange(start, end);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Range Selected'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('From: ${start.day}/${start.month}/${start.year}'),
            Text('To: ${end.day}/${end.month}/${end.year}'),
            const SizedBox(height: 8),
            Text(
              '$days day(s) selected',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('${events.length} event(s) in range'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _controller.clearSelection();
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAddEventDialog() {
    final titleController = TextEditingController();
    DateTime startDate = _controller.selectedDay ?? DateTime.now();
    DateTime endDate = startDate;
    TimeOfDay startTime = TimeOfDay.now();
    TimeOfDay endTime = TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: 0);
    Color selectedColor = Colors.blue;
    Color selectedDotColor = Colors.blue.shade700;
    bool isAllDay = false;
    bool isMultiDay = false;

    showDialog(
      context: context,
      useSafeArea: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Event'),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Event Title',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.title),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('All Day Event'),
                    subtitle: const Text('Event lasts the entire day'),
                    value: isAllDay,
                    onChanged: (value) {
                      setDialogState(() => isAllDay = value);
                    },
                    secondary: const Icon(Icons.wb_sunny),
                  ),
                  SwitchListTile(
                    title: const Text('Multi-Day Event'),
                    subtitle: const Text('Event spans multiple days'),
                    value: isMultiDay,
                    onChanged: (value) {
                      setDialogState(() {
                        isMultiDay = value;
                        if (value) {
                          isAllDay = true;
                        }
                      });
                    },
                    secondary: const Icon(Icons.date_range),
                  ),
                  const Divider(height: 24),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: Text(isMultiDay ? 'Start Date' : 'Date'),
                    subtitle: Text(
                        '${startDate.day}/${startDate.month}/${startDate.year}'),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: startDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (date != null) {
                        setDialogState(() {
                          startDate = date;
                          if (!isMultiDay) {
                            endDate = date;
                          } else if (endDate.isBefore(date)) {
                            endDate = date;
                          }
                        });
                      }
                    },
                  ),
                  if (isMultiDay)
                    ListTile(
                      leading: const Icon(Icons.event),
                      title: const Text('End Date'),
                      subtitle: Text(
                          '${endDate.day}/${endDate.month}/${endDate.year}'),
                      trailing: Text(
                        '${endDate.difference(startDate).inDays + 1} days',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate:
                              endDate.isAfter(startDate) ? endDate : startDate,
                          firstDate: startDate,
                          lastDate: DateTime(2030),
                        );
                        if (date != null) {
                          setDialogState(() => endDate = date);
                        }
                      },
                    ),
                  if (!isAllDay) ...[
                    const Divider(height: 24),
                    ListTile(
                      leading: const Icon(Icons.access_time),
                      title: const Text('Start Time'),
                      subtitle: Text(startTime.format(context)),
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: startTime,
                        );
                        if (time != null) {
                          setDialogState(() => startTime = time);
                        }
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.access_time_filled),
                      title: const Text('End Time'),
                      subtitle: Text(endTime.format(context)),
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: endTime,
                        );
                        if (time != null) {
                          setDialogState(() => endTime = time);
                        }
                      },
                    ),
                  ],
                  const Divider(height: 24),
                  ListTile(
                    leading: const Icon(Icons.palette),
                    title: const Text('Event Color'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: selectedColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text('→'),
                        const SizedBox(width: 4),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: selectedDotColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      _showColorPicker(context, selectedColor, (color) {
                        setDialogState(() {
                          selectedColor = color;
                          selectedDotColor = color.withValues(alpha: 0.7);
                        });
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          actionsOverflowButtonSpacing: 8,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  final event = CalendarEvent(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleController.text,
                    startDate: isAllDay
                        ? DateTime(
                            startDate.year, startDate.month, startDate.day)
                        : DateTime(
                            startDate.year,
                            startDate.month,
                            startDate.day,
                            startTime.hour,
                            startTime.minute,
                          ),
                    endDate: isAllDay
                        ? DateTime(endDate.year, endDate.month, endDate.day)
                        : DateTime(
                            endDate.year,
                            endDate.month,
                            endDate.day,
                            endTime.hour,
                            endTime.minute,
                          ),
                    isAllDay: isAllDay,
                    color: selectedColor,
                    dotColor: selectedDotColor,
                  );
                  _controller.addEvent(event);
                  Navigator.pop(context);

                  final daysCount = endDate.difference(startDate).inDays + 1;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isMultiDay
                            ? 'Multi-day event added ($daysCount days)'
                            : 'Event added',
                      ),
                      action: SnackBarAction(
                        label: 'View',
                        onPressed: () => _showEventDetails(event),
                      ),
                    ),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPicker(
      BuildContext context, Color current, ValueChanged<Color> onColorChanged) {
    final colors = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Color'),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: colors.map((color) {
            return InkWell(
              onTap: () {
                onColorChanged(color);
                Navigator.pop(context);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color == current ? Colors.black : Colors.grey,
                    width: color == current ? 3 : 1,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption('Light', CalendarTheme.light()),
            _buildThemeOption('Dark', CalendarTheme.dark()),
            _buildThemeOption('Colorful', CalendarTheme.colorful()),
            _buildThemeOption('Minimal', CalendarTheme.minimal()),
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

  Widget _buildThemeOption(String name, CalendarTheme theme) {
    final isSelected =
        _theme.headerBackgroundColor == theme.headerBackgroundColor;

    return ListTile(
      title: Text(
        name,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      leading: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: theme.headerBackgroundColor,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.blue, width: 3) : null,
        ),
      ),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
      onTap: () {
        setState(() {
          _theme = theme;
        });
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Theme changed to $name'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Calendar Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('24-Hour Format'),
              value: _config.show24HourFormat,
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(show24HourFormat: value);
                });
                Navigator.pop(context);
              },
            ),
            SwitchListTile(
              title: const Text('Show Event Time'),
              value: _config.showEventTime,
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(showEventTime: value);
                });
                Navigator.pop(context);
              },
            ),
            SwitchListTile(
              title: const Text('Vertical Scroll'),
              value: _config.enableVerticalScroll,
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(enableVerticalScroll: value);
                });
                Navigator.pop(context);
              },
            ),
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

  IconData _getPriorityIcon(EventPriority priority) {
    switch (priority) {
      case EventPriority.urgent:
        return Icons.warning;
      case EventPriority.high:
        return Icons.priority_high;
      case EventPriority.normal:
        return Icons.check_circle_outline;
      case EventPriority.low:
        return Icons.low_priority;
    }
  }

  Color _getPriorityColor(EventPriority priority) {
    switch (priority) {
      case EventPriority.urgent:
        return Colors.red;
      case EventPriority.high:
        return Colors.orange;
      case EventPriority.normal:
        return Colors.blue;
      case EventPriority.low:
        return Colors.grey;
    }
  }
}
// End of example code
