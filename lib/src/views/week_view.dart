import 'package:flutter/material.dart';

import '../core/controllers/calendar_controller.dart';
import '../core/models/calendar_config.dart';
import '../core/models/calendar_event.dart';
import '../core/utils/date_utils.dart' as date_utils;
import '../themes/calendar_theme.dart';

/// A week-based calendar view displaying events across 7 days with hourly time slots.
///
/// The week view shows a horizontal grid with days of the week as columns and
/// 24-hour time slots as rows. Events are positioned based on their start time
/// and duration. Supports horizontal swipe navigation between weeks.
///
/// Features:
/// - 7-day (or 5-day) week grid with hourly slots
/// - Swipeable week navigation (infinite scroll)
/// - Synchronized vertical scrolling
/// - Current time indicator
/// - Events positioned by time and duration
/// - Day headers with date highlighting
/// - Holiday highlighting
/// - Weekend hiding option
/// - Auto-scroll to current time
/// - 12/24 hour format support
///
/// Example:
/// ```dart
/// WeekView(
///   controller: calendarController,
///   config: CalendarConfig(
///     show24HourFormat: true,
///     showEventTime: true,
///   ),
///   theme: CalendarTheme.light(),
///   onDaySelected: (date) {
///     print('Selected: $date');
///   },
///   onEventTap: (event) {
///     print('Event: ${event.title}');
///   },
/// )
/// ```
class WeekView extends StatefulWidget {
  /// Creates a week view.
  ///
  /// [controller] - The calendar controller managing state and events.
  /// [config] - Configuration for display and interaction options.
  /// [theme] - Theme configuration for visual styling.
  /// [onDaySelected] - Optional callback when a day header is tapped.
  /// [onEventTap] - Optional callback when an event is tapped.
  ///
  /// Example:
  /// ```dart
  /// WeekView(
  ///   controller: myController,
  ///   config: CalendarConfig(
  ///     hideWeekends: true,
  ///     showHolidays: true,
  ///   ),
  ///   theme: CalendarTheme.dark(),
  ///   onDaySelected: (date) => showDayDetails(date),
  ///   onEventTap: (event) => showEventDetails(event),
  /// )
  /// ```
  const WeekView({
    super.key,
    required this.controller,
    required this.config,
    required this.theme,
    this.onDaySelected,
    this.onEventTap,
  });

  /// The calendar controller managing state and events.
  final CalendarController controller;

  /// Configuration for display and interaction options.
  final CalendarConfig config;

  /// Theme configuration for visual styling.
  final CalendarTheme theme;

  /// Callback invoked when a day header is tapped.
  final void Function(DateTime)? onDaySelected;

  /// Callback invoked when an event is tapped.
  final void Function(CalendarEvent)? onEventTap;

  @override
  State<WeekView> createState() => _WeekViewState();
}

class _WeekViewState extends State<WeekView> {
  late final ScrollController _scrollController;
  late final ScrollController _timeScrollController;
  late final PageController _pageController;

  /// Starting page index for infinite scroll (middle of a large range)
  static const int _initialPage = 12000;

  /// Flag to prevent recursive updates during page changes
  bool _isPageChanging = false;

  @override
  void initState() {
    super.initState();

    // Initialize scroll controllers
    _scrollController = ScrollController();
    _timeScrollController = ScrollController();
    _pageController = PageController(initialPage: _initialPage);

    // Sync vertical scrolling between time column and content
    _scrollController.addListener(_syncScrollControllers);

    // Listen to controller changes for programmatic navigation
    widget.controller.addListener(_onControllerChanged);

    // Auto-scroll to current time (2 hours before current hour)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final now = DateTime.now();
        final scrollToHour = now.hour > 0 ? now.hour - 2 : 0;
        _scrollController.jumpTo(scrollToHour * 60.0);
      }
    });
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

  /// Synchronizes time column scroll with content scroll.
  void _syncScrollControllers() {
    if (_timeScrollController.hasClients && _scrollController.hasClients) {
      _timeScrollController.jumpTo(_scrollController.offset);
    }
  }

  /// Handles controller changes to sync PageView with programmatic navigation.
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

  /// Calculates the page index for a given date.
  ///
  /// [date] - The date to calculate the page for.
  ///
  /// Returns the page index where this date's week should be displayed.
  int _getPageForDate(DateTime date) {
    final now = DateTime.now();
    final weekOffset = date.difference(now).inDays ~/ 7;
    return _initialPage + weekOffset;
  }

  /// Calculates the date for a given page index.
  ///
  /// [page] - The page index to calculate the date for.
  ///
  /// Returns the date that should be displayed on this page.
  DateTime _getDateForPage(int page) {
    final offset = page - _initialPage;
    final now = DateTime.now();
    return now.add(Duration(days: offset * 7));
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          _buildWeekHeader(),
          Expanded(
            child: _buildWeekPageView(),
          ),
        ],
      );

  /// Builds the PageView for swipeable week navigation.
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

  /// Builds the week content for a specific date.
  ///
  /// [date] - The date representing the week to display.
  Widget _buildWeekContentForDate(DateTime date) {
    final weekDays = _getFilteredWeekDaysForDate(date);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time column (synchronized scrolling)
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

  /// Builds the week header showing day names and dates.
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
                  child: _buildDayHeader(day, isToday, isHoliday),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a single day header with weekday name and date.
  ///
  /// [day] - The date for this header.
  /// [isToday] - Whether this is today's date.
  /// [isHoliday] - Whether this is a holiday.
  Widget _buildDayHeader(DateTime day, bool isToday, bool isHoliday) =>
      Container(
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
                    color: _getDayHeaderTextColor(isToday, isHoliday),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  /// Determines the background color for a day header.
  ///
  /// [isToday] - Whether this is today's date.
  /// [isHoliday] - Whether this is a holiday.
  Color _getDayHeaderColor(bool isToday, bool isHoliday) {
    if (isToday) {
      return widget.theme.todayBackgroundColor;
    } else if (isHoliday && widget.config.showHolidays) {
      return widget.theme.holidayBackgroundColor;
    }
    return Colors.transparent;
  }

  /// Determines the text color for a day header.
  ///
  /// [isToday] - Whether this is today's date.
  /// [isHoliday] - Whether this is a holiday.
  Color _getDayHeaderTextColor(bool isToday, bool isHoliday) {
    if (isToday) {
      return widget.theme.todayTextColor;
    } else if (isHoliday && widget.config.showHolidays) {
      return widget.theme.holidayTextColor;
    }
    return widget.theme.dayTextColor;
  }

  /// Builds the time column showing hourly labels (00:00 - 23:00).
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

  /// Builds a single day column with time slots and events.
  ///
  /// [day] - The date for this column.
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
          _buildHourLines(),
          if (date_utils.isSameDay(day, DateTime.now()))
            _buildCurrentTimeIndicator(),
          ...events.map((event) => _buildEventWidget(event, day)),
        ],
      ),
    );
  }

  /// Builds the horizontal hour lines for the time grid.
  Widget _buildHourLines() => Column(
        children: List.generate(
            24,
            (hour) => Container(
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: widget.theme.borderColor.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                )),
      );

  /// Builds the current time indicator line.
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

  /// Builds an event widget positioned at its scheduled time.
  ///
  /// [event] - The event to display.
  /// [day] - The day this event is displayed on.
  Widget _buildEventWidget(CalendarEvent event, DateTime day) {
    final startHour = event.startDate.hour + (event.startDate.minute / 60);
    final duration = event.endDate.difference(event.startDate).inMinutes / 60;

    return Positioned(
      top: startHour * 60,
      left: 4,
      right: 4,
      height: (duration * 60) - 2, // Prevent overflow
      child: GestureDetector(
        onTap: () => widget.onEventTap?.call(event),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: event.color.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: event.color),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
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

  /// Gets the week days for the controller's focused date.
  ///
  /// Filters out weekends if [CalendarConfig.hideWeekends] is true.
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

  /// Gets the week days for a specific date.
  ///
  /// [date] - The date to get the week for.
  ///
  /// Filters out weekends if [CalendarConfig.hideWeekends] is true.
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

  /// Gets the abbreviated weekday name for a weekday number.
  ///
  /// [weekday] - Weekday number (1=Monday, 7=Sunday).
  String _getWeekdayName(int weekday) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[weekday - 1];
  }

  /// Formats an hour in 12 or 24-hour format based on config.
  ///
  /// [hour] - The hour to format (0-23).
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

  /// Formats a time in 12 or 24-hour format based on config.
  ///
  /// [time] - The time to format.
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
}
