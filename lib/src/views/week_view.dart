import 'package:flutter/material.dart';

import '../core/controllers/calendar_controller.dart';
import '../core/models/calendar_config.dart';
import '../core/models/calendar_event.dart';
import '../core/utils/date_utils.dart' as date_utils;
import '../themes/calendar_theme.dart';

class WeekView extends StatefulWidget {
  const WeekView({
    super.key,
    required this.controller,
    required this.config,
    required this.theme,
    this.onDaySelected,
    this.onEventTap,
  });

  final CalendarController controller;
  final CalendarConfig config;
  final CalendarTheme theme;
  final void Function(DateTime)? onDaySelected;
  final void Function(CalendarEvent)? onEventTap;

  @override
  State<WeekView> createState() => _WeekViewState();
}

class _WeekViewState extends State<WeekView> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _timeScrollController = ScrollController();

  // ✅ NEW: PageView controller for week navigation
  late PageController _pageController;
  final int _initialPage = 12000; // Start in the middle for infinite scroll
  bool _isPageChanging = false;

  @override
  void initState() {
    super.initState();
    // Sync scroll controllers
    _scrollController.addListener(_syncScrollControllers);

    // ✅ NEW: Initialize PageController
    _pageController = PageController(initialPage: _initialPage);

    // ✅ NEW: Listen to controller changes
    widget.controller.addListener(_onControllerChanged);

    // Auto-scroll to current time (8 AM by default)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final now = DateTime.now();
        final scrollToHour = now.hour > 0 ? now.hour - 2 : 0;
        _scrollController.jumpTo(scrollToHour * 60.0);
      }
    });
  }

  void _syncScrollControllers() {
    if (_timeScrollController.hasClients && _scrollController.hasClients) {
      _timeScrollController.jumpTo(_scrollController.offset);
    }
  }

  // ✅ NEW: Sync PageView when controller changes
  void _onControllerChanged() {
    if (_isPageChanging) {
      return;
    }

    final targetPage = _getPageForDate(widget.controller.focusedDay);
    if (_pageController.hasClients &&
        _pageController.page?.round() != targetPage) {
      _pageController.animateToPage(
        targetPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // ✅ NEW: Calculate page index for a given date
  int _getPageForDate(DateTime date) {
    final now = DateTime.now();
    final weekOffset = date.difference(now).inDays ~/ 7;
    return _initialPage + weekOffset;
  }

  // ✅ NEW: Calculate date for a given page index
  DateTime _getDateForPage(int page) {
    final offset = page - _initialPage;
    final now = DateTime.now();
    return now.add(Duration(days: offset * 7));
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _scrollController
      ..removeListener(_syncScrollControllers)
      ..dispose();
    _timeScrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          _buildWeekHeader(),
          Expanded(
            child: _buildWeekPageView(), // ✅ UPDATED: Use PageView
          ),
        ],
      );

  // ✅ NEW: Build PageView for week navigation
  Widget _buildWeekPageView() => PageView.builder(
        controller: _pageController,
        onPageChanged: (page) {
          _isPageChanging = true;
          final newDate = _getDateForPage(page);
          widget.controller.jumpToDate(newDate);
          _isPageChanging = false;
        },
        itemBuilder: (context, index) {
          final displayDate = _getDateForPage(index);
          return _buildWeekContentForDate(displayDate);
        },
      );

  // ✅ NEW: Build week content for a specific date
  Widget _buildWeekContentForDate(DateTime date) {
    final weekDays = _getFilteredWeekDaysForDate(date);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time column - synchronized scrolling
        SizedBox(
          width: 60,
          child: SingleChildScrollView(
            controller: _timeScrollController,
            physics: const NeverScrollableScrollPhysics(),
            child: _buildTimeColumn(),
          ),
        ),
        // Week days content
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: weekDays
                    .map((day) => Expanded(
                          child: _buildDayColumn(day),
                        ))
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeekHeader() {
    final weekDays = _getFilteredWeekDays();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: widget.theme.weekdayBackgroundColor,
        border: Border(
          bottom: BorderSide(color: widget.theme.borderColor),
        ),
      ),
      child: Row(
        children: [
          // Time column placeholder
          const SizedBox(width: 60),
          // Week days
          Expanded(
            child: Row(
              children: weekDays.map((day) {
                final isToday = date_utils.isSameDay(day, DateTime.now());
                final isHoliday = widget.config.isHoliday(day);

                return Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        Text(
                          _getWeekdayName(day.weekday),
                          style: TextStyle(
                            fontSize: 12,
                            color: isHoliday && widget.config.showHolidays
                                ? widget.theme.holidayTextColor
                                : widget.theme.weekdayTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: _getDayHeaderColor(isToday, isHoliday),
                            shape: BoxShape.circle,
                            border: isToday && isHoliday
                                ? Border.all(
                                    color: widget.theme.holidayTextColor,
                                    width: 2,
                                  )
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:
                                    _getDayHeaderTextColor(isToday, isHoliday),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Color _getDayHeaderColor(bool isToday, bool isHoliday) {
    if (isToday && isHoliday && widget.config.showHolidays) {
      return widget.theme.todayBackgroundColor;
    } else if (isToday) {
      return widget.theme.todayBackgroundColor;
    } else if (isHoliday && widget.config.showHolidays) {
      return widget.theme.holidayBackgroundColor;
    }
    return Colors.transparent;
  }

  Color _getDayHeaderTextColor(bool isToday, bool isHoliday) {
    if (isToday) {
      return widget.theme.todayTextColor;
    } else if (isHoliday && widget.config.showHolidays) {
      return widget.theme.holidayTextColor;
    }
    return widget.theme.dayTextColor;
  }

  Widget _buildTimeColumn() => Container(
        decoration: BoxDecoration(
          color: widget.theme.weekdayBackgroundColor,
          border: Border(
            right: BorderSide(color: widget.theme.borderColor),
          ),
        ),
        child: Column(
          children: List.generate(
              24,
              (hour) => Container(
                    height: 60,
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      _formatHour(hour),
                      style: TextStyle(
                        fontSize: 10,
                        color: widget.theme.weekdayTextColor,
                      ),
                    ),
                  )),
        ),
      );

  Widget _buildDayColumn(DateTime day) {
    final events = widget.controller.getEventsForDay(day);
    final isHoliday = widget.config.isHoliday(day);

    return Container(
      decoration: BoxDecoration(
        color: isHoliday && widget.config.showHolidays
            ? widget.theme.holidayBackgroundColor.withValues(alpha: 0.1)
            : null,
        border: Border(
          right: BorderSide(
              color: widget.theme.borderColor.withValues(alpha: 0.3)),
        ),
      ),
      child: Stack(
        children: [
          // Hour lines
          Column(
            children: List.generate(
                24,
                (hour) => Container(
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color:
                                widget.theme.borderColor.withValues(alpha: 0.2),
                          ),
                        ),
                      ),
                    )),
          ),
          // Current time indicator
          if (date_utils.isSameDay(day, DateTime.now()))
            _buildCurrentTimeIndicator(),
          // Events
          ...events.map((event) => _buildEventWidget(event, day)),
        ],
      ),
    );
  }

  Widget _buildCurrentTimeIndicator() {
    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;

    return Positioned(
      top: currentMinutes.toDouble(),
      left: 0,
      right: 0,
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: widget.theme.todayBorderColor,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Container(
              height: 2,
              color: widget.theme.todayBorderColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventWidget(CalendarEvent event, DateTime day) {
    final startHour = event.startDate.hour + (event.startDate.minute / 60);
    final duration = event.endDate.difference(event.startDate).inMinutes / 60;

    // ✅ FIX #1: Reduce padding to prevent overflow
    return Positioned(
      top: startHour * 60,
      left: 4, // ✅ Increased from 2 to 4
      right: 4, // ✅ Increased from 2 to 4
      height: (duration * 60) - 2, // ✅ Subtract 2px to prevent overflow
      child: GestureDetector(
        onTap: () => widget.onEventTap?.call(event),
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 4, vertical: 2), // ✅ Reduced padding
          decoration: BoxDecoration(
            color: event.color.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: event.color),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // ✅ Prevent overflow
            children: [
              Flexible(
                // ✅ Wrap in Flexible
                child: Text(
                  event.title,
                  style: TextStyle(
                    color: event.textColor ?? Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.config.showEventTime && duration > 0.5)
                Flexible(
                  // ✅ Wrap in Flexible
                  child: Text(
                    '${_formatEventTime(event.startDate)} - ${_formatEventTime(event.endDate)}',
                    style: TextStyle(
                      color: (event.textColor ?? Colors.white)
                          .withValues(alpha: 0.8),
                      fontSize: 9,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatEventTime(DateTime time) {
    if (widget.config.show24HourFormat) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      final hour =
          time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour);
      final period = time.hour >= 12 ? 'PM' : 'AM';
      return '$hour:${time.minute.toString().padLeft(2, '0')} $period';
    }
  }

  /// Get week days filtered by hideWeekends option
  List<DateTime> _getFilteredWeekDays() {
    final allDays = date_utils.getWeekDays(
      widget.controller.focusedDay,
      widget.controller.weekStartDay,
    );

    if (!widget.config.hideWeekends) {
      return allDays;
    }

    return allDays
        .where((day) =>
            day.weekday != DateTime.saturday && day.weekday != DateTime.sunday)
        .toList();
  }

  // ✅ NEW: Get week days for a specific date
  List<DateTime> _getFilteredWeekDaysForDate(DateTime date) {
    final allDays = date_utils.getWeekDays(
      date,
      widget.controller.weekStartDay,
    );

    if (!widget.config.hideWeekends) {
      return allDays;
    }

    return allDays
        .where((day) =>
            day.weekday != DateTime.saturday && day.weekday != DateTime.sunday)
        .toList();
  }

  String _getWeekdayName(int weekday) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[weekday - 1];
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
}
