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
