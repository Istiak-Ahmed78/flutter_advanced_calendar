<div align="center">

<table>
<tr>
<td width="40%">
<img width="672" height="1237" alt="Gemini_Generated_Image_czif1wczifd1wczif" src="https://github.com/user-attachments/assets/ea975d22-1a4f-4f16-9e74-3bf2d6e81c1f" />

</td>
<td width="60%">

# 📅 Flutter Calendar Pro

### *Build production-ready calendars in minutes*

Powerful calendar toolkit • Effortless integration.

✨ **7 View Modes** • 🎨 **Fully Customizable** • ⚡ **Production Ready**

```yaml
dependencies:
  flutter_calendar_pro: ^1.0.0
```

<div align="center">

[![pub package](https://img.shields.io/pub/v/flutter_calendar_pro.svg?label=pub&color=blue)](https://pub.dev/packages/flutter_calendar_pro)
[![license](https://img.shields.io/badge/license-MIT-green.svg)](https://opensource.org/licenses/MIT)


[📖 Documentation](https://pub.dev/packages/flutter_calendar_pro) • [🚀 Examples](./example)

</div>

</td>
</tr>
</table>

</div>


---

## ✨ Features

- 🎯 **7 Built-in View Modes** – Month, Week, Day, Agenda, Year, Timeline, and Schedule views
- 🎨 **Highly Customizable** – Every color, font, size, and spacing is customizable with 30+ theme properties
- ⚡ **Developer Friendly** – Simple, intuitive API with comprehensive documentation and rich examples
- 🔧 **Complete Event Management** – Built-in controller to add, edit, delete, and query events effortlessly
- 📱 **Fully Responsive** – Works flawlessly across mobile, tablet, and desktop platforms
- 🌈 **Theme Support** – Built-in light and dark themes, plus full custom theme support
- 📅 **Rich Event Model** – Support for all-day events, multi-day events, recurring events, colors, icons, and more
- 🎭 **Interactive Callbacks** – Respond to day selection, event taps, range selection, month changes, and more
- 🏢 **Resource Scheduling** – Timeline view perfect for meeting rooms, equipment booking, and staff scheduling
- 🎪 **Multiple Selection Modes** – Single day, range selection, or multi-select
- 🔍 **Event Filtering** – Built-in search and filter capabilities
- 🌍 **Internationalization** – Full i18n support with customizable locale and date formats
- ♿ **Accessible** – Semantic labels and screen reader support

---

## 📦 Installation

Add `flutter_calendar_pro` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_calendar_pro: ^1.0.0
```

Then run:

```bash
flutter pub get
```

Import the package in your Dart code:

```dart
import 'package:flutter_calendar_pro/flutter_calendar_pro.dart';
```

---

## 🎬 Quick Start

### Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:flutter_calendar_pro/flutter_calendar_pro.dart';

class MyCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = CalendarController();
    
    // Add some events
    controller.addEvent(
      CalendarEvent(
        id: '1',
        title: 'Team Meeting',
        startDate: DateTime.now().add(Duration(hours: 2)),
        endDate: DateTime.now().add(Duration(hours: 3)),
        color: Colors.blue,
      ),
    );

    return Scaffold(
      body: AdvancedCalendar(
        controller: controller,
        onDaySelected: (day) => print('Selected: $day'),
      ),
    );
  }
}
```

---

## 📱 View Examples

> 💡 **Note:** The examples below use a helper class `SampleData` for generating sample events. You can create events inline or use your own data source.

<details>
<summary><b>📦 View SampleData Helper Class</b></summary>

```dart
import 'package:flutter/material.dart';
import 'package:flutter_calendar_pro/flutter_calendar_pro.dart';

class SampleData {
  /// Generate sample events for demonstration
  static List<CalendarEvent> generateSampleEvents() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return [
      // Today's events
      CalendarEvent(
        id: '1',
        title: 'Team Meeting',
        description: 'Weekly team sync',
        startDate: today.add(Duration(hours: 9)),
        endDate: today.add(Duration(hours: 10)),
        color: Colors.blue,
        icon: Icons.people,
        category: 'meeting',
        location: 'Conference Room A',
      ),
      CalendarEvent(
        id: '2',
        title: 'Lunch Break',
        startDate: today.add(Duration(hours: 12)),
        endDate: today.add(Duration(hours: 13)),
        color: Colors.orange,
        icon: Icons.restaurant,
        category: 'personal',
        isAllDay: false,
      ),
      CalendarEvent(
        id: '3',
        title: 'Client Presentation',
        description: 'Q4 results presentation',
        startDate: today.add(Duration(hours: 14)),
        endDate: today.add(Duration(hours: 15, minutes: 30)),
        color: Colors.red,
        icon: Icons.presentation,
        category: 'meeting',
        location: 'Board Room',
      ),
      
      // Tomorrow's events
      CalendarEvent(
        id: '4',
        title: 'Gym Session',
        startDate: today.add(Duration(days: 1, hours: 7)),
        endDate: today.add(Duration(days: 1, hours: 8)),
        color: Colors.green,
        icon: Icons.fitness_center,
        category: 'personal',
      ),
      CalendarEvent(
        id: '5',
        title: 'Code Review',
        startDate: today.add(Duration(days: 1, hours: 10)),
        endDate: today.add(Duration(days: 1, hours: 11)),
        color: Colors.purple,
        icon: Icons.code,
        category: 'work',
      ),
      
      // This week's events
      CalendarEvent(
        id: '6',
        title: 'Project Deadline',
        startDate: today.add(Duration(days: 3)),
        endDate: today.add(Duration(days: 3)),
        color: Colors.red,
        icon: Icons.flag,
        category: 'work',
        isAllDay: true,
      ),
      CalendarEvent(
        id: '7',
        title: 'Team Lunch',
        startDate: today.add(Duration(days: 4, hours: 12)),
        endDate: today.add(Duration(days: 4, hours: 14)),
        color: Colors.amber,
        icon: Icons.restaurant_menu,
        category: 'social',
        location: 'Italian Restaurant',
      ),
      
      // Multi-day event
      CalendarEvent(
        id: '8',
        title: 'Conference',
        description: 'Annual tech conference',
        startDate: today.add(Duration(days: 7)),
        endDate: today.add(Duration(days: 9)),
        color: Colors.indigo,
        icon: Icons.event,
        category: 'conference',
        location: 'Convention Center',
      ),
      
      // Recurring pattern example
      CalendarEvent(
        id: '9',
        title: 'Daily Standup',
        startDate: today.add(Duration(hours: 9, minutes: 30)),
        endDate: today.add(Duration(hours: 9, minutes: 45)),
        color: Colors.teal,
        icon: Icons.groups,
        category: 'meeting',
        isRecurring: true,
      ),
      
      // All-day events
      CalendarEvent(
        id: '10',
        title: 'Company Holiday',
        startDate: today.add(Duration(days: 14)),
        endDate: today.add(Duration(days: 14)),
        color: Colors.pink,
        icon: Icons.celebration,
        category: 'holiday',
        isAllDay: true,
      ),
    ];
  }
  
  /// Generate events for timeline view (resource scheduling)
  static List<CalendarEvent> generateTimelineEvents() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return [
      // Room A bookings
      CalendarEvent(
        id: 't1',
        title: 'Marketing Meeting',
        startDate: today.add(Duration(hours: 9)),
        endDate: today.add(Duration(hours: 10)),
        color: Colors.blue,
        category: 'Room A',
      ),
      CalendarEvent(
        id: 't2',
        title: 'Training Session',
        startDate: today.add(Duration(hours: 14)),
        endDate: today.add(Duration(hours: 16)),
        color: Colors.green,
        category: 'Room A',
      ),
      
      // Room B bookings
      CalendarEvent(
        id: 't3',
        title: 'Client Call',
        startDate: today.add(Duration(hours: 10)),
        endDate: today.add(Duration(hours: 11)),
        color: Colors.orange,
        category: 'Room B',
      ),
      CalendarEvent(
        id: 't4',
        title: 'Interview',
        startDate: today.add(Duration(hours: 15)),
        endDate: today.add(Duration(hours: 16)),
        color: Colors.purple,
        category: 'Room B',
      ),
      
      // Room C bookings
      CalendarEvent(
        id: 't5',
        title: 'Workshop',
        startDate: today.add(Duration(hours: 9)),
        endDate: today.add(Duration(hours: 12)),
        color: Colors.red,
        category: 'Room C',
      ),
    ];
  }
  
  /// Generate a large number of events for performance testing
  static List<CalendarEvent> generateManyEvents(int count) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
    ];
    
    return List.generate(count, (index) {
      final daysOffset = index % 30;
      final hoursOffset = (index % 8) + 9; // 9 AM to 5 PM
      
      return CalendarEvent(
        id: 'event_$index',
        title: 'Event ${index + 1}',
        description: 'Sample event description',
        startDate: today.add(Duration(days: daysOffset, hours: hoursOffset)),
        endDate: today.add(Duration(days: daysOffset, hours: hoursOffset + 1)),
        color: colors[index % colors.length],
        category: 'Category ${index % 5}',
      );
    });
  }
}
```

**Usage in your app:**

```dart
// Use in any view
final controller = CalendarController();
controller.addEvents(SampleData.generateSampleEvents());

// For timeline view
controller.addEvents(SampleData.generateTimelineEvents());

// For performance testing
controller.addEvents(SampleData.generateManyEvents(100));
```

</details>

<br/>


### 1. Basic Month View

<div align="center">
<table>
<tr>
<td width="35%" valign="top" align="center">

<img src="https://github.com/user-attachments/assets/9cb83c72-8a07-4ad8-915b-d90b8c3326c9" alt="Basic Month View" width="280" />

</td>
<td width="65%" valign="top">

The simplest way to get started with Flutter Calendar Pro. This example shows a clean month view with minimal configuration.

**Features:**
- 📅 Classic month grid layout
- 🎯 Day selection support
- 🔄 Month navigation
- 📱 Responsive design

**Perfect for:** Simple date pickers, appointment booking, basic scheduling needs.

<details>
<summary><b>📝 Show minimal code</b></summary>

```dart
import 'package:flutter/material.dart';
import 'package:flutter_calendar_pro/flutter_calendar_pro.dart';

/// The simplest calendar - just the widget!
class MonthViewBasic extends StatelessWidget {
  const MonthViewBasic({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Month View'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: AdvancedCalendar(
        controller: CalendarController(),
      ),
    );
  }
}

```

</details>

</td>
</tr>
</table>
</div>

---

### 2. Month View with Events

<div align="center">
<table>
<tr>
<td width="35%" valign="top" align="center">

<img src="https://github.com/user-attachments/assets/e9d5a592-3a13-4b04-b479-ba8341a0fd5a" alt="Month View with Events" width="280" />

</td>
<td width="65%" valign="top">

Display events in month view with visual indicators. This example demonstrates the core event management features available in the calendar.

**Features:**
- 📌 **Event dots/indicators** - Visual markers on dates with events
- 🎨 **Color-coded events** - Assign custom colors to each event
- 📋 **Multiple events per day** - Support unlimited events on any date
- 🔍 **Event querying** - Get events for specific days using `getEventsForDay()`
- 🎯 **Day selection callback** - `onDaySelected` triggered when user taps a date
- 📅 **Date range selection** - Select start and end dates
- 📅 **Event properties** - Support for title, time, location, description, category, icons
- ⏰ **All-day events** - Mark events as all-day with `isAllDay` property
- 🔄 **Dynamic event updates** - Add/remove events with `addEvent()`, `addEvents()`, `removeEvent()`

**Perfect for:** Event calendars, task management apps, appointment systems, content scheduling, team calendars.

<details>
<summary><b>📝 Show minimal code</b></summary>

```dart
import 'package:flutter/material.dart';
import 'package:flutter_calendar_pro/flutter_calendar_pro.dart';
import '../../shared/sample_data.dart';

/// Month view with simple events
class MonthViewWithEvents extends StatefulWidget {
  const MonthViewWithEvents({super.key});

  @override
  State<MonthViewWithEvents> createState() => _MonthViewWithEventsState();
}

class _MonthViewWithEventsState extends State<MonthViewWithEvents> {
  late CalendarController _controller;
  DateTime _selectedDay = DateTime.now();
  List<CalendarEvent> _selectedDayEvents = [];

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();

    // Add events to controller
    _controller.addEvents(SampleData.getSimpleEvents());

    // Get events for today
    _updateSelectedDayEvents(_selectedDay);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateSelectedDayEvents(DateTime day) {
    setState(() {
      _selectedDay = day;
      _selectedDayEvents = _controller.getEventsForDay(day);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Month View with Events'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Calendar - Fixed height
          SizedBox(
            height: 400, // Fixed height for calendar
            child: AdvancedCalendar(
              controller: _controller,
              showHeader: true,
              onDaySelected: (day) {
                _updateSelectedDayEvents(day);
              },
            ),
          ),

          // Divider
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey.shade300,
          ),

          // Events list - Takes remaining space
          Expanded(
            child: _buildEventsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList() {
    if (_selectedDayEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No events on ${_formatDate(_selectedDay)}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey.shade50,
          child: Row(
            children: [
              Icon(
                Icons.event,
                size: 20,
                color: Colors.grey.shade700,
              ),
              const SizedBox(width: 8),
              Text(
                'Events on ${_formatDate(_selectedDay)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_selectedDayEvents.length}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Events list
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: _selectedDayEvents.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final event = _selectedDayEvents[index];
              return _buildEventCard(event);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard(CalendarEvent event) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          _showEventDetails(event);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Color indicator
              Container(
                width: 4,
                height: 60,
                decoration: BoxDecoration(
                  color: event.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),

              // Event icon (if available)
              if (event.icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: event.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    event.icon,
                    color: event.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
              ],

              // Event details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatEventTime(event),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (event.location != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.location!,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Arrow icon
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
              ),
            ],
          ),
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
            Expanded(
              child: Text(event.title),
            ),
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
            if (event.category != null) ...[
              const SizedBox(height: 12),
              _buildDetailRow(Icons.category, event.category!),
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
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
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

```

</details>

</td>
</tr>
</table>
</div>

---

### 3. Week View

<div align="center">
<table>
<tr>
<td width="35%" valign="top" align="center">

<img src="https://github.com/user-attachments/assets/d5195739-9145-4471-b15a-682c0ebec9b4" alt="Week View" width="280" />

</td>
<td width="65%" valign="top">

Display a full week with hourly time slots and precise event positioning. Perfect for detailed weekly scheduling with time-based event management.

**Features:**
- 📊 **7-day week grid** - Shows full week with customizable start day via `weekStartDay`
- ⏰ **Hourly time slots** - 24-hour timeline with customizable height via `timeSlotHeight`
- 🔴 **Current time indicator** - Real-time red line showing current time position
- 🔄 **Swipe navigation** - PageView-based week navigation with infinite scroll
- 🚫 **Hide weekends** - Optional weekend hiding with `hideWeekends`
- 📏 **Auto-scroll** - Automatically scrolls to current time on load

**Perfect for:** Work schedules, meeting planners, appointment booking, time tracking, weekly agendas, shift management.

<details>
<summary><b>📝 Show minimal code</b></summary>

```dart
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

```

</details>

</td>
</tr>
</table>
</div>

---

### 4. Day View

<div align="center">
<table>
<tr>
<td width="35%" valign="top" align="center">

<img src="https://github.com/user-attachments/assets/92eb3308-229d-46ac-8a76-1b18a8ae8f36" alt="Day View" width="280" />

</td>
<td width="65%" valign="top">

Dive deep into a single day with maximum detail. Ideal for detailed daily planning and hour-by-hour scheduling.

**Features:**
- 📅 **Single day focus** - Display one day at a time with full detail
- ⏱️ **Hourly time slots** - Customizable time range (default 6 AM - 10 PM)
- 📍 **Time slot tap callback** - `onTimeSlotTap` for quick event creation at specific times
- 📏 **Smart event sizing** - Automatic height calculation based on event duration
- 📋 **Event counter** - Header shows total events for the day

**Perfect for:** Daily planners, appointment booking, personal schedules, time blocking.

<details>
<summary><b>📝 Show minimal code</b></summary>

```dart
import 'package:flutter/material.dart';
import 'package:flutter_calendar_pro/flutter_calendar_pro.dart';
import '../../shared/sample_data.dart';

/// Day view example with event management
class DayViewExample extends StatefulWidget {
  const DayViewExample({super.key});

  @override
  State<DayViewExample> createState() => _DayViewExampleState();
}

class _DayViewExampleState extends State<DayViewExample> {
  late CalendarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController(
      initialView: CalendarView.day,
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
        title: const Text('Day View'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddEventDialog,
            tooltip: 'Add Event',
          ),
        ],
      ),
      body: AdvancedCalendar(
        controller: _controller,
        config: const CalendarConfig(
          initialView: CalendarView.day,
          show24HourFormat: false,
          showEventTime: true,
          showEventLocation: true,
        ),
        onEventTap: (event) {
          _showEventDetails(event);
        },
        onTimeSlotTap: (dateTime, resourceId) {
          _showQuickAddDialog(dateTime);
        },
      ),
    );
  }

  void _showAddEventDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    TimeOfDay startTime = TimeOfDay.now();
    TimeOfDay endTime = TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: 0);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Event'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Event Title',
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
                            setDialogState(() {
                              startTime = time;
                            });
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
                            setDialogState(() {
                              endTime = time;
                            });
                          }
                        },
                      ),
                    ),
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
                if (titleController.text.isNotEmpty) {
                  final now = _controller.focusedDay;
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
                    description: descriptionController.text.isEmpty
                        ? null
                        : descriptionController.text,
                    startDate: startDate,
                    endDate: endDate,
                    color: Colors.orange,
                  );

                  _controller.addEvent(event);
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Event added successfully'),
                      backgroundColor: Colors.green,
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

  void _showQuickAddDialog(DateTime dateTime) {
    final titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add event at ${_formatTime(dateTime)}'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'Event Title',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
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
                  startDate: dateTime,
                  endDate: dateTime.add(const Duration(hours: 1)),
                  color: Colors.orange,
                );

                _controller.addEvent(event);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
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
            _buildDetailRow(
              Icons.access_time,
              '${_formatTime(event.startDate)} - ${_formatTime(event.endDate)}',
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
            onPressed: () {
              _controller.removeEvent(event.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Event deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
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


```

</details>

</td>
</tr>
</table>
</div>

---

### 5. Agenda View

<div align="center">
<table>
<tr>
<td width="35%" valign="top" align="center">

<img src="https://github.com/user-attachments/assets/8a3d9f68-fd67-43a3-ad86-cc34256397c1" alt="Agenda View" width="280" />

</td>
<td width="65%" valign="top">

A clean list-based view of upcoming events. Perfect for displaying events in chronological order with full details.

**Features:**
- 📋 **List-style layout** - Events displayed in chronological order
- 📅 **Grouped by date** - Automatic grouping with date headers
- 🔢 **Event counter** - Shows event count per day
- 🎯 **Multi-day event support** - Events appear on each day they span
- 📏 **Customizable range** - Control days to display with `daysToShow` parameter
- 🔍 **Range querying** - Get events for date ranges using `getEventsForRange()`

**Perfect for:** Event listings, upcoming tasks, meeting agendas, conference schedules.

<details>
<summary><b>📝 Show minimal code</b></summary>

```dart
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

```

</details>

</td>
</tr>
</table>
</div>

---

### 6. Timeline View

<div align="center">
<table>
<tr>
<td width="35%" valign="top" align="center">

<img src="https://github.com/user-attachments/assets/54dab143-326b-4a58-b9d2-b9241cc5aa51" alt="Timeline View" width="280" />

</td>
<td width="65%" valign="top">

Advanced resource scheduling view. Perfect for managing multiple resources like meeting rooms, equipment, or team members.

**Features:**
- 🏢 **Multiple resource columns** - Display multiple resources side-by-side with customizable `timelineColumns`
- ⏰ **Hourly time grid** - 24-hour timeline
- 🎯 **Resource-based tap callback** - `onTimeSlotTap(DateTime, String)` includes resource identifier
- 📊 **Event positioning by resource** - Events mapped to columns via `category` or `location` property

**Perfect for:** Room booking, equipment scheduling, staff management, resource allocation.

<details>
<summary><b>📝 Show minimal code</b></summary>

```dart
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

```

</details>

</td>
</tr>
</table>
</div>

## 📚 API Reference


---

### 📦 Core Classes

#### `AdvancedCalendar`

The main calendar widget that displays events in various view modes.

```dart
AdvancedCalendar({
  Key? key,
  required CalendarController controller,
  CalendarViewType initialView = CalendarViewType.month,
  DateTime? initialDate,
  DateTime? minDate,
  DateTime? maxDate,
  CalendarTheme? theme,
  CalendarConfig? config,
  
  // Callbacks
  void Function(DateTime)? onDaySelected,
  void Function(CalendarEvent)? onEventTap,
  void Function(DateTime, DateTime)? onRangeSelected,
  void Function(DateTime)? onMonthChanged,
  void Function(DateTime, [String?])? onTimeSlotTap,
  
  // View-specific options
  int weekStartDay = DateTime.monday,
  bool hideWeekends = false,
  bool show24HourFormat = true,
  bool showEventTime = true,
  bool showEventLocation = true,
  double timeSlotHeight = 60.0,
  int daysToShow = 30,
  List<String>? timelineColumns,
  List<Holiday>? holidays,
})
```

**Properties:**
- `controller` - Controls calendar state and manages events
- `initialView` - Starting view mode (month, week, day, etc.)
- `initialDate` - Date to display on first load
- `minDate` / `maxDate` - Restrict selectable date range
- `theme` - Customize colors, fonts, and styling
- `config` - Additional configuration options

**Callbacks:**
- `onDaySelected` - Triggered when user taps a date
- `onEventTap` - Triggered when user taps an event
- `onRangeSelected` - Triggered when date range is selected
- `onMonthChanged` - Triggered when month changes
- `onTimeSlotTap` - Triggered when time slot is tapped (includes resource ID for timeline view)

---

#### `CalendarController`

Manages calendar state, events, and provides methods for event manipulation.

```dart
final controller = CalendarController();
```

**Methods:**

| Method | Description | Returns |
|--------|-------------|---------|
| `addEvent(CalendarEvent event)` | Add a single event | `void` |
| `addEvents(List<CalendarEvent> events)` | Add multiple events | `void` |
| `removeEvent(String eventId)` | Remove event by ID | `void` |
| `updateEvent(CalendarEvent event)` | Update existing event | `void` |
| `clearEvents()` | Remove all events | `void` |
| `getEventsForDay(DateTime day)` | Get events for specific day | `List<CalendarEvent>` |
| `getEventsForRange(DateTime start, DateTime end)` | Get events in date range | `List<CalendarEvent>` |
| `getAllEvents()` | Get all events | `List<CalendarEvent>` |
| `jumpToDate(DateTime date)` | Navigate to specific date | `void` |
| `nextMonth()` / `previousMonth()` | Navigate months | `void` |
| `nextWeek()` / `previousWeek()` | Navigate weeks | `void` |
| `nextDay()` / `previousDay()` | Navigate days | `void` |
| `changeView(CalendarViewType view)` | Switch view mode | `void` |
| `dispose()` | Clean up resources | `void` |

**Example:**
```dart
// Add events
controller.addEvent(CalendarEvent(
  id: '1',
  title: 'Meeting',
  startDate: DateTime.now(),
  endDate: DateTime.now().add(Duration(hours: 1)),
));

// Query events
final todayEvents = controller.getEventsForDay(DateTime.now());

// Navigate
controller.jumpToDate(DateTime(2024, 12, 25));
controller.changeView(CalendarViewType.week);
```

---

#### `CalendarEvent`

Event model with rich properties for comprehensive event management.

```dart
CalendarEvent({
  required String id,
  required String title,
  required DateTime startDate,
  required DateTime endDate,
  String? description,
  String? location,
  Color? color,
  IconData? icon,
  String? category,
  bool isAllDay = false,
  bool isRecurring = false,
  RecurrenceRule? recurrenceRule,
  Map<String, dynamic>? metadata,
})
```

**Properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | `String` | ✅ | Unique event identifier |
| `title` | `String` | ✅ | Event title/name |
| `startDate` | `DateTime` | ✅ | Event start date/time |
| `endDate` | `DateTime` | ✅ | Event end date/time |
| `description` | `String?` | ❌ | Detailed event description |
| `location` | `String?` | ❌ | Event location/venue |
| `color` | `Color?` | ❌ | Custom event color |
| `icon` | `IconData?` | ❌ | Event icon |
| `category` | `String?` | ❌ | Event category/type |
| `isAllDay` | `bool` | ❌ | All-day event flag |
| `isRecurring` | `bool` | ❌ | Recurring event flag |
| `recurrenceRule` | `RecurrenceRule?` | ❌ | Recurrence pattern |
| `metadata` | `Map<String, dynamic>?` | ❌ | Custom data storage |

**Example:**
```dart
CalendarEvent(
  id: 'meeting-001',
  title: 'Team Standup',
  description: 'Daily team sync meeting',
  startDate: DateTime(2024, 1, 15, 9, 0),
  endDate: DateTime(2024, 1, 15, 9, 30),
  location: 'Conference Room A',
  color: Colors.blue,
  icon: Icons.people,
  category: 'meeting',
  metadata: {'attendees': 5, 'priority': 'high'},
)
```

---

#### `CalendarViewType`

Enum defining available calendar view modes.

```dart
enum CalendarViewType {
  month,      // Monthly grid view
  week,       // Weekly view with time slots
  day,        // Single day detailed view
  agenda,     // List-style event view
  year,       // Yearly overview
  timeline,   // Resource scheduling view
  schedule,   // Compact schedule view
}
```

**Usage:**
```dart
AdvancedCalendar(
  controller: controller,
  initialView: CalendarViewType.week,
)

// Switch views programmatically
controller.changeView(CalendarViewType.day);
```

---

#### `CalendarTheme`

Comprehensive theming options for customizing calendar appearance.

```dart
CalendarTheme({
  // Colors
  Color? primaryColor,
  Color? backgroundColor,
  Color? headerBackgroundColor,
  Color? selectedDayColor,
  Color? todayColor,
  Color? weekendColor,
  Color? eventColor,
  Color? timeSlotColor,
  Color? borderColor,
  
  // Text Styles
  TextStyle? headerTextStyle,
  TextStyle? dayTextStyle,
  TextStyle? weekdayTextStyle,
  TextStyle? eventTextStyle,
  TextStyle? timeTextStyle,
  
  // Sizes
  double? dayHeight,
  double? eventHeight,
  double? borderRadius,
  double? eventBorderRadius,
  
  // Spacing
  EdgeInsets? padding,
  EdgeInsets? eventPadding,
})
```

**Example:**
```dart
CalendarTheme(
  primaryColor: Colors.blue,
  backgroundColor: Colors.white,
  selectedDayColor: Colors.blue.shade100,
  todayColor: Colors.orange,
  headerTextStyle: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
  eventBorderRadius: 8.0,
  eventPadding: EdgeInsets.all(8),
)
```

---

#### `CalendarConfig`

Additional configuration options for calendar behavior.

```dart
CalendarConfig({
  bool enableSwipeNavigation = true,
  bool enableDoubleTapToCreate = false,
  bool enableLongPressToCreate = false,
  bool showWeekNumbers = false,
  bool showCurrentTimeIndicator = true,
  bool allowMultiDaySelection = false,
  int firstDayOfWeek = DateTime.monday,
  String dateFormat = 'MMM d, yyyy',
  String timeFormat = 'HH:mm',
  Locale? locale,
})
```

---

#### `Holiday`

Model for marking holidays and special dates.

```dart
Holiday({
  required DateTime date,
  required String name,
  Color? color,
  bool isNationalHoliday = false,
})
```

**Example:**
```dart
List<Holiday> holidays = [
  Holiday(
    date: DateTime(2024, 1, 1),
    name: 'New Year\'s Day',
    color: Colors.red,
    isNationalHoliday: true,
  ),
  Holiday(
    date: DateTime(2024, 12, 25),
    name: 'Christmas',
    color: Colors.green,
    isNationalHoliday: true,
  ),
];

AdvancedCalendar(
  controller: controller,
  holidays: holidays,
)
```

---

### 🔧 Common Use Cases

#### Creating Events
```dart
// Simple event
controller.addEvent(CalendarEvent(
  id: '1',
  title: 'Meeting',
  startDate: DateTime.now(),
  endDate: DateTime.now().add(Duration(hours: 1)),
));

// All-day event
controller.addEvent(CalendarEvent(
  id: '2',
  title: 'Holiday',
  startDate: DateTime(2024, 12, 25),
  endDate: DateTime(2024, 12, 25),
  isAllDay: true,
));

// Multi-day event
controller.addEvent(CalendarEvent(
  id: '3',
  title: 'Conference',
  startDate: DateTime(2024, 6, 1),
  endDate: DateTime(2024, 6, 3),
));
```

#### Querying Events
```dart
// Get today's events
final today = DateTime.now();
final todayEvents = controller.getEventsForDay(today);

// Get this week's events
final weekStart = today.subtract(Duration(days: today.weekday - 1));
final weekEnd = weekStart.add(Duration(days: 7));
final weekEvents = controller.getEventsForRange(weekStart, weekEnd);

// Get all events
final allEvents = controller.getAllEvents();
```

#### Navigation
```dart
// Jump to specific date
controller.jumpToDate(DateTime(2024, 12, 25));

// Navigate by period
controller.nextMonth();
controller.previousWeek();
controller.nextDay();

// Switch views
controller.changeView(CalendarViewType.week);
```

#### Handling Callbacks
```dart
AdvancedCalendar(
  controller: controller,
  onDaySelected: (date) {
    print('Selected: $date');
    // Show events for this day
    final events = controller.getEventsForDay(date);
  },
  onEventTap: (event) {
    print('Tapped: ${event.title}');
    // Show event details
  },
  onRangeSelected: (start, end) {
    print('Range: $start to $end');
    // Handle date range selection
  },
  onTimeSlotTap: (dateTime, resourceId) {
    print('Time slot: $dateTime, Resource: $resourceId');
    // Create new event at this time
  },
)
```

---


## 🤝 Contributing

Contributions are welcome!

### How to Contribute

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/interesting-feature`)
3. **Commit** your changes using [Conventional Commits](https://www.conventionalcommits.org/)
   - `feat:` New feature
   - `fix:` Bug fix
   - `docs:` Documentation
   - `test:` Tests
   - `refactor:` Code refactoring
4. **Push** to your branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

---

## 📄 License

MIT License - see [LICENSE](./LICENSE) file for details.

---

## 🌟 Show Your Support

If this package helped you, please ⭐ star the repo and 👍 like it on pub.dev!

---
