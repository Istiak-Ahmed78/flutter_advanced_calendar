import 'package:flutter/foundation.dart';
import '../models/calendar_event.dart';
import '../models/enums.dart';
import '../utils/date_utils.dart' as calendar_utils;

/// Controller for managing calendar state and events
class CalendarController extends ChangeNotifier {
  CalendarController({
    DateTime? initialDate,
    CalendarView initialView = CalendarView.month,
    int weekStartDay = DateTime.monday,
  })  : _focusedDay = initialDate ?? DateTime.now(),
        _currentView = initialView,
        _weekStartDay = weekStartDay;
  DateTime _focusedDay;
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  CalendarView _currentView;

  final List<CalendarEvent> _events = [];
  final List<DateTime> _holidays = [];
  final List<DateTime> _selectedDays = [];

  // Configuration
  int _weekStartDay = DateTime.monday;
  bool _hideWeekends = false;

  // ==================== Getters ====================

  /// Current focused date (the month/week/day being displayed)
  DateTime get focusedDay => _focusedDay;

  /// Currently selected single day
  DateTime? get selectedDay => _selectedDay;

  /// Start of selected range
  DateTime? get rangeStart => _rangeStart;

  /// End of selected range
  DateTime? get rangeEnd => _rangeEnd;

  /// Current calendar view
  CalendarView get currentView => _currentView;

  /// All events (immutable)
  List<CalendarEvent> get events => List.unmodifiable(_events);

  /// All holidays (immutable)
  List<DateTime> get holidays => List.unmodifiable(_holidays);

  /// All selected days (for multi-select mode)
  List<DateTime> get selectedDays => List.unmodifiable(_selectedDays);

  /// Week start day (1=Monday, 7=Sunday)
  int get weekStartDay => _weekStartDay;

  /// Whether weekends are hidden
  bool get hideWeekends => _hideWeekends;

  /// Check if a range is selected
  bool get hasRangeSelection => _rangeStart != null && _rangeEnd != null;

  /// Get the selected range as a list of dates
  List<DateTime> get selectedRange {
    if (!hasRangeSelection) {
      return [];
    }
    return calendar_utils.getDateRange(_rangeStart!, _rangeEnd!);
  }

  // ==================== Navigation Methods ====================

  /// Move to next month
  void nextMonth() {
    _focusedDay = calendar_utils.addMonths(_focusedDay, 1);
    notifyListeners();
  }

  /// Move to previous month
  void previousMonth() {
    _focusedDay = calendar_utils.addMonths(_focusedDay, -1);
    notifyListeners();
  }

  /// Move to next week
  void nextWeek() {
    _focusedDay = _focusedDay.add(const Duration(days: 7));
    notifyListeners();
  }

  /// Move to previous week
  void previousWeek() {
    _focusedDay = _focusedDay.subtract(const Duration(days: 7));
    notifyListeners();
  }

  /// Move to next day
  void nextDay() {
    _focusedDay = _focusedDay.add(const Duration(days: 1));
    notifyListeners();
  }

  /// Move to previous day
  void previousDay() {
    _focusedDay = _focusedDay.subtract(const Duration(days: 1));
    notifyListeners();
  }

  /// Move to next year
  void nextYear() {
    _focusedDay =
        DateTime(_focusedDay.year + 1, _focusedDay.month, _focusedDay.day);
    notifyListeners();
  }

  /// Move to previous year
  void previousYear() {
    _focusedDay =
        DateTime(_focusedDay.year - 1, _focusedDay.month, _focusedDay.day);
    notifyListeners();
  }

  /// Issue #4: Jump to specific date
  void jumpToDate(DateTime date) {
    _focusedDay = date;
    notifyListeners();
  }

  /// Issue #4: Jump to specific month and year
  void jumpToMonthYear(int month, int year) {
    _focusedDay = DateTime(year, month);
    notifyListeners();
  }

  /// Issue #4: Jump to specific year (keeps current month)
  void jumpToYear(int year) {
    _focusedDay = DateTime(year, _focusedDay.month, _focusedDay.day);
    notifyListeners();
  }

  /// Issue #4: Jump to specific month (keeps current year)
  void jumpToMonth(int month) {
    _focusedDay = DateTime(_focusedDay.year, month, _focusedDay.day);
    notifyListeners();
  }

  /// Jump to today
  void jumpToToday() {
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    notifyListeners();
  }

  /// Navigate based on current view
  void navigateNext() {
    switch (_currentView) {
      case CalendarView.month:
        nextMonth();
        break;
      case CalendarView.week:
        nextWeek();
        break;
      case CalendarView.day:
        nextDay();
        break;
      case CalendarView.year:
        nextYear();
        break;
      default:
        nextMonth();
    }
  }

  /// Navigate previous based on current view
  void navigatePrevious() {
    switch (_currentView) {
      case CalendarView.month:
        previousMonth();
        break;
      case CalendarView.week:
        previousWeek();
        break;
      case CalendarView.day:
        previousDay();
        break;
      case CalendarView.year:
        previousYear();
        break;
      default:
        previousMonth();
    }
  }

  // ==================== Selection Methods ====================

  /// Select a single day
  void selectDay(DateTime day, {bool clearRange = true}) {
    _selectedDay = day;
    if (clearRange) {
      _rangeStart = null;
      _rangeEnd = null;
    }
    notifyListeners();
  }

  /// Select a range of dates
  void selectRange(DateTime start, DateTime end) {
    if (start.isAfter(end)) {
      _rangeStart = end;
      _rangeEnd = start;
    } else {
      _rangeStart = start;
      _rangeEnd = end;
    }
    _selectedDay = null;
    notifyListeners();
  }

  /// Issue #6: Handle range selection tap with same-day support
  void handleRangeTap(DateTime day, {bool allowSameDay = true}) {
    if (_rangeStart == null) {
      // First tap - set range start
      _rangeStart = day;
      _rangeEnd = null;
      _selectedDay = null;
    } else if (_rangeEnd == null) {
      // Second tap - set range end
      if (calendar_utils.isSameDay(_rangeStart!, day)) {
        // Same day tapped
        if (allowSameDay) {
          // Issue #6: Allow same-day range
          _rangeEnd = day;
        } else {
          // Reset selection if same day not allowed
          _rangeStart = null;
        }
      } else {
        _rangeEnd = day;
        // Ensure start is before end
        if (_rangeStart!.isAfter(_rangeEnd!)) {
          final temp = _rangeStart;
          _rangeStart = _rangeEnd;
          _rangeEnd = temp;
        }
      }
    } else {
      // Third tap - reset and start new range
      _rangeStart = day;
      _rangeEnd = null;
    }
    notifyListeners();
  }

  /// Clear all selections
  void clearSelection() {
    _selectedDay = null;
    _rangeStart = null;
    _rangeEnd = null;
    _selectedDays.clear();
    notifyListeners();
  }

  /// Add day to multi-select
  void addSelectedDay(DateTime day) {
    if (!_selectedDays.any((d) => calendar_utils.isSameDay(d, day))) {
      _selectedDays.add(day);
      notifyListeners();
    }
  }

  /// Remove day from multi-select
  void removeSelectedDay(DateTime day) {
    _selectedDays.removeWhere((d) => calendar_utils.isSameDay(d, day));
    notifyListeners();
  }

  /// Toggle day in multi-select
  void toggleSelectedDay(DateTime day) {
    if (_selectedDays.any((d) => calendar_utils.isSameDay(d, day))) {
      removeSelectedDay(day);
    } else {
      addSelectedDay(day);
    }
  }

  /// Check if day is selected
  bool isDaySelected(DateTime day) {
    if (_selectedDay != null && calendar_utils.isSameDay(_selectedDay!, day)) {
      return true;
    }
    return _selectedDays.any((d) => calendar_utils.isSameDay(d, day));
  }

  /// Check if day is in selected range
  bool isDayInRange(DateTime day) {
    if (!hasRangeSelection) {
      return false;
    }
    return !day.isBefore(_rangeStart!) && !day.isAfter(_rangeEnd!);
  }

  /// Check if day is range start
  bool isRangeStart(DateTime day) =>
      _rangeStart != null && calendar_utils.isSameDay(_rangeStart!, day);

  /// Check if day is range end
  bool isRangeEnd(DateTime day) =>
      _rangeEnd != null && calendar_utils.isSameDay(_rangeEnd!, day);

  // ==================== View Management ====================

  /// Change calendar view
  void setView(CalendarView view) {
    _currentView = view;
    notifyListeners();
  }

  /// Toggle between month and week view
  void toggleMonthWeekView() {
    if (_currentView == CalendarView.month) {
      _currentView = CalendarView.week;
    } else {
      _currentView = CalendarView.month;
    }
    notifyListeners();
  }

  // ==================== Event Management ====================

  /// Add a single event
  void addEvent(CalendarEvent event) {
    _events.add(event);
    notifyListeners();
  }

  /// Add multiple events
  void addEvents(List<CalendarEvent> events) {
    _events.addAll(events);
    notifyListeners();
  }

  /// Update an event
  void updateEvent(String id, CalendarEvent updatedEvent) {
    final index = _events.indexWhere((e) => e.id == id);
    if (index != -1) {
      _events[index] = updatedEvent;
      notifyListeners();
    }
  }

  /// Remove an event
  void removeEvent(String id) {
    _events.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  /// Remove multiple events
  void removeEvents(List<String> ids) {
    _events.removeWhere((e) => ids.contains(e.id));
    notifyListeners();
  }

  /// Clear all events
  void clearEvents() {
    _events.clear();
    notifyListeners();
  }

  /// Replace all events
  void setEvents(List<CalendarEvent> events) {
    _events
      ..clear()
      ..addAll(events);
    notifyListeners();
  }

  /// Get events for a specific day
  List<CalendarEvent> getEventsForDay(DateTime day) =>
      _events.where((event) => event.occursOnDate(day)).toList()
        ..sort((a, b) {
          // Sort by start time
          if (a.isAllDay && !b.isAllDay) {
            return -1;
          }
          if (!a.isAllDay && b.isAllDay) {
            return 1;
          }
          return a.startDate.compareTo(b.startDate);
        });

  /// Get events for a date range
  List<CalendarEvent> getEventsForRange(DateTime start, DateTime end) {
    final dateRange = calendar_utils.getDateRange(start, end);
    final eventsSet = <CalendarEvent>{};

    for (final date in dateRange) {
      eventsSet.addAll(getEventsForDay(date));
    }

    return eventsSet.toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
  }

  /// Get events for current focused month
  List<CalendarEvent> getEventsForMonth() {
    final start = calendar_utils.getStartOfMonth(_focusedDay);
    final end = calendar_utils.getEndOfMonth(_focusedDay);
    return getEventsForRange(start, end);
  }

  /// Get events for current focused week
  List<CalendarEvent> getEventsForWeek() {
    final start = calendar_utils.getStartOfWeek(_focusedDay, _weekStartDay);
    final end = calendar_utils.getEndOfWeek(_focusedDay, _weekStartDay);
    return getEventsForRange(start, end);
  }

  /// Get event by ID
  CalendarEvent? getEventById(String id) {
    try {
      return _events.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get events by category
  List<CalendarEvent> getEventsByCategory(String category) =>
      _events.where((e) => e.category == category).toList();

  /// Get events by priority
  List<CalendarEvent> getEventsByPriority(EventPriority priority) =>
      _events.where((e) => e.priority == priority).toList();

  /// Get events by status
  List<CalendarEvent> getEventsByStatus(EventStatus status) =>
      _events.where((e) => e.status == status).toList();

  /// Check if day has events
  bool hasEventsOnDay(DateTime day) =>
      _events.any((event) => event.occursOnDate(day));

  /// Get event count for day
  int getEventCountForDay(DateTime day) => getEventsForDay(day).length;

  // ==================== Holiday Management ====================

  /// Add a holiday
  void addHoliday(DateTime date) {
    if (!_holidays.any((d) => calendar_utils.isSameDay(d, date))) {
      _holidays.add(date);
      notifyListeners();
    }
  }

  /// Add multiple holidays
  void addHolidays(List<DateTime> dates) {
    for (final date in dates) {
      if (!_holidays.any((d) => calendar_utils.isSameDay(d, date))) {
        _holidays.add(date);
      }
    }
    notifyListeners();
  }

  /// Remove a holiday
  void removeHoliday(DateTime date) {
    _holidays.removeWhere((d) => calendar_utils.isSameDay(d, date));
    notifyListeners();
  }

  /// Clear all holidays
  void clearHolidays() {
    _holidays.clear();
    notifyListeners();
  }

  /// Check if date is a holiday
  bool isHoliday(DateTime date) =>
      _holidays.any((d) => calendar_utils.isSameDay(d, date));

  /// Issue #8: Check if today is a holiday
  bool isTodayHoliday() {
    final today = DateTime.now();
    return isHoliday(today);
  }

  /// Get holidays in a date range
  List<DateTime> getHolidaysInRange(DateTime start, DateTime end) => _holidays
      .where((holiday) => !holiday.isBefore(start) && !holiday.isAfter(end))
      .toList();

  /// Get holidays for current month
  List<DateTime> getHolidaysForMonth() {
    final start = calendar_utils.getStartOfMonth(_focusedDay);
    final end = calendar_utils.getEndOfMonth(_focusedDay);
    return getHolidaysInRange(start, end);
  }

  // ==================== Configuration ====================

  /// Set week start day
  void setWeekStartDay(int weekday) {
    assert(weekday >= 1 && weekday <= 7, 'Weekday must be between 1 and 7');
    _weekStartDay = weekday;
    notifyListeners();
  }

  /// Issue #5: Toggle hide weekends
  // ignore: avoid_positional_boolean_parameters
  void setHideWeekends(bool hide) {
    _hideWeekends = hide;
    notifyListeners();
  }

  /// Toggle hide weekends
  void toggleHideWeekends() {
    _hideWeekends = !_hideWeekends;
    notifyListeners();
  }

  // ==================== Utility Methods ====================

  /// Check if date is today
  bool isToday(DateTime date) => calendar_utils.isToday(date);

  /// Check if date is in focused month
  bool isInFocusedMonth(DateTime date) =>
      calendar_utils.isSameMonth(date, _focusedDay);

  /// Check if date is weekend
  bool isWeekend(DateTime date) => calendar_utils.isWeekend(date);

  /// Get visible days for current month view
  List<DateTime> getVisibleDays() => calendar_utils.getVisibleDays(
        _focusedDay,
        _weekStartDay,
        hideWeekends: _hideWeekends,
      );

  /// Get days in current week
  List<DateTime> getDaysInWeek() {
    final start = calendar_utils.getStartOfWeek(_focusedDay, _weekStartDay);
    final days = <DateTime>[];

    for (var i = 0; i < 7; i++) {
      final day = start.add(Duration(days: i));
      if (!_hideWeekends || !calendar_utils.isWeekend(day)) {
        days.add(day);
      }
    }

    return days;
  }

  /// Get formatted month-year string
  String getFormattedMonthYear() {
    final months = [
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
    return '${months[_focusedDay.month - 1]} ${_focusedDay.year}';
  }

  // ==================== Dispose ====================

  @override
  void dispose() {
    _events.clear();
    _holidays.clear();
    _selectedDays.clear();
    super.dispose();
  }
}
