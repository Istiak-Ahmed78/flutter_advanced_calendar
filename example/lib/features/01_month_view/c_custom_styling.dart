import 'package:flutter/material.dart';
import 'package:flutter_calendar_pro/flutter_calendar_pro.dart';
import '../../shared/sample_data.dart';

/// Month view with custom styling
class MonthViewCustomStyling extends StatefulWidget {
  const MonthViewCustomStyling({super.key});

  @override
  State<MonthViewCustomStyling> createState() => _MonthViewCustomStylingState();
}

class _MonthViewCustomStylingState extends State<MonthViewCustomStyling> {
  late CalendarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
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
        title: const Text('Custom Styling'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: AdvancedCalendar(
        controller: _controller,

        // Custom purple theme
        theme: CalendarTheme(
          // Background colors
          backgroundColor: Colors.purple.shade50,
          headerBackgroundColor: Colors.purple,
          weekdayBackgroundColor: Colors.purple.shade100,

          // Text colors
          headerTextColor: Colors.white,
          weekdayTextColor: Colors.purple.shade900,
          dayTextColor: Colors.black87,
          selectedDayTextColor: Colors.white,
          todayTextColor: Colors.purple.shade900,
          outsideMonthTextColor: Colors.grey.shade400,
          disabledTextColor: Colors.grey.shade300,

          // Day colors
          todayBackgroundColor: Colors.purple.shade100,
          selectedDayBackgroundColor: Colors.purple,
          rangeStartBackgroundColor: Colors.purple,
          rangeEndBackgroundColor: Colors.purple,
          rangeMiddleBackgroundColor: Colors.purple.shade200,
          weekendTextColor: Colors.red.shade400,
          holidayTextColor: Colors.red.shade600,
          holidayBackgroundColor: Colors.red.shade50,

          // Border colors
          borderColor: Colors.purple.shade200,
          selectedBorderColor: Colors.purple.shade700,
          todayBorderColor: Colors.purple,

          // Event colors
          eventIndicatorColor: Colors.purple,
          eventBackgroundColor: Colors.purple.shade100,
          eventTextColor: Colors.purple.shade900,

          // Sizes
          dayCellHeight: 56.0,
          dayCellWidth: 56.0,
          borderRadius: 12.0,
          eventIndicatorSize: 7.0,

          // Text styles
          headerTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          weekdayTextStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.purple.shade900,
          ),
          dayTextStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),

        config: const CalendarConfig(
          weekStartDay:
              WeekStartDay.monday, // Changed from WeekDay to WeekStartDay
          showWeekNumbers: true,
        ),

        onDaySelected: (day) {
          debugPrint('Selected: $day');
        },
      ),
    );
  }
}
