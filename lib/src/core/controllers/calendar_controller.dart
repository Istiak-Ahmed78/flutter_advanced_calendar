import 'package:flutter/foundation.dart';
import '../models/calendar_event.dart';
import '../models/enums.dart';
import '../utils/date_utils.dart' as calendar_utils;

/// Controller for managing calendar state and events.
///
/// This controller handles:
/// - Navigation between dates, weeks, months, and years
/// - Event management (add, update, remove, query)
/// - Day selection (single, range, multi-select)
/// - Holiday management
/// - View state management
///
/// Example:
/// ```dart
/// final controller = CalendarController(
///   initialDate: DateTime.now(),
///   initialView: CalendarView.month,
/// );
///
/// // Add events
/// controller.addEvent(CalendarEvent(...));
///
/// // Navigate
/// controller.nextMonth();
///
/// // Query events
/// final events = controller.getEventsForDay(DateTime.now());
/// ```
class CalendarController extends ChangeNotifier {
  /// Creates a calendar controller.
  ///
  /// [initialDate] - The initial date to display. Defaults to current date.
  /// [initialView] - The initial calendar view. Defaults to month view.
  /// [weekStartDay] - The first day of the week (1=Monday, 7=Sunday). Defaults to Monday.
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

  int _weekStartDay = DateTime.monday;
  bool _hideWeekends = false;

  // ==================== Getters ====================

  /// The current focused date (the month/week/day being displayed).
  DateTime get focusedDay => _focusedDay;

  /// The currently selected single day, or null if no day is selected.
  DateTime? get selectedDay => _selectedDay;

  /// The start date of the selected range, or null if no range is selected.
  DateTime? get rangeStart => _rangeStart;

  /// The end date of the selected range, or null if no range is selected.
  DateTime? get rangeEnd => _rangeEnd;

  /// The current calendar view mode.
  CalendarView get currentView => _currentView;

  /// An immutable list of all events in the calendar.
  List<CalendarEvent> get events => List.unmodifiable(_events);

  /// An immutable list of all holidays in the calendar.
  List<DateTime> get holidays => List.unmodifiable(_holidays);

  /// An immutable list of all selected days (for multi-select mode).
  List<DateTime> get selectedDays => List.unmodifiable(_selectedDays);

  /// The first day of the week (1=Monday, 7=Sunday).
  int get weekStartDay => _weekStartDay;

  /// Whether weekends (Saturday and Sunday) are hidden from the calendar.
  bool get hideWeekends => _hideWeekends;

  /// Whether a date range is currently selected.
  bool get hasRangeSelection => _rangeStart != null && _rangeEnd != null;

  /// Returns all dates in the selected range as a list.
  ///
  /// Returns an empty list if no range is selected.
  List<DateTime> get selectedRange {
    if (!hasRangeSelection) {
      return [];
    }
    return calendar_utils.getDateRange(_rangeStart!, _rangeEnd!);
  }

  // ==================== Navigation Methods ====================

  /// Navigates to the next month.
  void nextMonth() {
    _focusedDay = calendar_utils.addMonths(_focusedDay, 1);
    notifyListeners();
  }

  /// Navigates to the previous month.
  void previousMonth() {
    _focusedDay = calendar_utils.addMonths(_focusedDay, -1);
    notifyListeners();
  }

  /// Navigates to the next week.
  void nextWeek() {
    _focusedDay = _focusedDay.add(const Duration(days: 7));
    notifyListeners();
  }

  /// Navigates to the previous week.
  void previousWeek() {
    _focusedDay = _focusedDay.subtract(const Duration(days: 7));
    notifyListeners();
  }

  /// Navigates to the next day.
  void nextDay() {
    _focusedDay = _focusedDay.add(const Duration(days: 1));
    notifyListeners();
  }

  /// Navigates to the previous day.
  void previousDay() {
    _focusedDay = _focusedDay.subtract(const Duration(days: 1));
    notifyListeners();
  }

  /// Navigates to the next year.
  void nextYear() {
    _focusedDay =
        DateTime(_focusedDay.year + 1, _focusedDay.month, _focusedDay.day);
    notifyListeners();
  }

  /// Navigates to the previous year.
  void previousYear() {
    _focusedDay =
        DateTime(_focusedDay.year - 1, _focusedDay.month, _focusedDay.day);
    notifyListeners();
  }

  /// Jumps to a specific date.
  ///
  /// [date] - The date to jump to.
  void jumpToDate(DateTime date) {
    _focusedDay = date;
    notifyListeners();
  }

  /// Jumps to a specific month and year.
  ///
  /// [month] - The month (1-12).
  /// [year] - The year.
  void jumpToMonthYear(int month, int year) {
    _focusedDay = DateTime(year, month);
    notifyListeners();
  }

  /// Jumps to a specific year, keeping the current month.
  ///
  /// [year] - The year to jump to.
  void jumpToYear(int year) {
    _focusedDay = DateTime(year, _focusedDay.month, _focusedDay.day);
    notifyListeners();
  }

  /// Jumps to a specific month, keeping the current year.
  ///
  /// [month] - The month to jump to (1-12).
  void jumpToMonth(int month) {
    _focusedDay = DateTime(_focusedDay.year, month, _focusedDay.day);
    notifyListeners();
  }

  /// Jumps to today's date and selects it.
  void jumpToToday() {
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    notifyListeners();
  }

  /// Navigates forward based on the current view.
  ///
  /// - Month view: moves to next month
  /// - Week view: moves to next week
  /// - Day view: moves to next day
  /// - Year view: moves to next year
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

  /// Navigates backward based on the current view.
  ///
  /// - Month view: moves to previous month
  /// - Week view: moves to previous week
  /// - Day view: moves to previous day
  /// - Year view: moves to previous year
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

  /// Selects a single day.
  ///
  /// [day] - The day to select.
  /// [clearRange] - Whether to clear any existing range selection. Defaults to true.
  void selectDay(DateTime day, {bool clearRange = true}) {
    _selectedDay = day;
    if (clearRange) {
      _rangeStart = null;
      _rangeEnd = null;
    }
    notifyListeners();
  }

  /// Selects a range of dates.
  ///
  /// [start] - The start date of the range.
  /// [end] - The end date of the range.
  ///
  /// If [start] is after [end], they will be automatically swapped.
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

  /// Handles range selection tap with support for same-day ranges.
  ///
  /// [day] - The day that was tapped.
  /// [allowSameDay] - Whether to allow selecting the same day as both start and end. Defaults to true.
  ///
  /// Behavior:
  /// - First tap: sets range start
  /// - Second tap: sets range end
  /// - Third tap: resets and starts new range
  void handleRangeTap(DateTime day, {bool allowSameDay = true}) {
    if (_rangeStart == null) {
      _rangeStart = day;
      _rangeEnd = null;
      _selectedDay = null;
    } else if (_rangeEnd == null) {
      if (calendar_utils.isSameDay(_rangeStart!, day)) {
        if (allowSameDay) {
          _rangeEnd = day;
        } else {
          _rangeStart = null;
        }
      } else {
        _rangeEnd = day;
        if (_rangeStart!.isAfter(_rangeEnd!)) {
          final temp = _rangeStart;
          _rangeStart = _rangeEnd;
          _rangeEnd = temp;
        }
      }
    } else {
      _rangeStart = day;
      _rangeEnd = null;
    }
    notifyListeners();
  }

  /// Clears all selections (single day, range, and multi-select).
  void clearSelection() {
    _selectedDay = null;
    _rangeStart = null;
    _rangeEnd = null;
    _selectedDays.clear();
    notifyListeners();
  }

  /// Adds a day to the multi-select list.
  ///
  /// [day] - The day to add.
  ///
  /// Does nothing if the day is already selected.
  void addSelectedDay(DateTime day) {
    if (!_selectedDays.any((d) => calendar_utils.isSameDay(d, day))) {
      _selectedDays.add(day);
      notifyListeners();
    }
  }

  /// Removes a day from the multi-select list.
  ///
  /// [day] - The day to remove.
  void removeSelectedDay(DateTime day) {
    _selectedDays.removeWhere((d) => calendar_utils.isSameDay(d, day));
    notifyListeners();
  }

  /// Toggles a day in the multi-select list.
  ///
  /// [day] - The day to toggle.
  ///
  /// If the day is selected, it will be removed. If not selected, it will be added.
  void toggleSelectedDay(DateTime day) {
    if (_selectedDays.any((d) => calendar_utils.isSameDay(d, day))) {
      removeSelectedDay(day);
    } else {
      addSelectedDay(day);
    }
  }

  /// Checks if a day is selected (either as single selection or in multi-select).
  ///
  /// [day] - The day to check.
  ///
  /// Returns true if the day is selected.
  bool isDaySelected(DateTime day) {
    if (_selectedDay != null && calendar_utils.isSameDay(_selectedDay!, day)) {
      return true;
    }
    return _selectedDays.any((d) => calendar_utils.isSameDay(d, day));
  }

  /// Checks if a day is within the selected range.
  ///
  /// [day] - The day to check.
  ///
  /// Returns true if the day is in the range, false otherwise.
  bool isDayInRange(DateTime day) {
    if (!hasRangeSelection) {
      return false;
    }
    return !day.isBefore(_rangeStart!) && !day.isAfter(_rangeEnd!);
  }

  /// Checks if a day is the start of the selected range.
  ///
  /// [day] - The day to check.
  bool isRangeStart(DateTime day) =>
      _rangeStart != null && calendar_utils.isSameDay(_rangeStart!, day);

  /// Checks if a day is the end of the selected range.
  ///
  /// [day] - The day to check.
  bool isRangeEnd(DateTime day) =>
      _rangeEnd != null && calendar_utils.isSameDay(_rangeEnd!, day);

  // ==================== View Management ====================

  /// Changes the calendar view.
  ///
  /// [view] - The new view to display.
  void setView(CalendarView view) {
    _currentView = view;
    notifyListeners();
  }

  /// Toggles between month and week view.
  void toggleMonthWeekView() {
    if (_currentView == CalendarView.month) {
      _currentView = CalendarView.week;
    } else {
      _currentView = CalendarView.month;
    }
    notifyListeners();
  }

  // ==================== Event Management ====================

  /// Adds a single event to the calendar.
  ///
  /// [event] - The event to add.
  void addEvent(CalendarEvent event) {
    _events.add(event);
    notifyListeners();
  }

  /// Adds multiple events to the calendar.
  ///
  /// [events] - The list of events to add.
  void addEvents(List<CalendarEvent> events) {
    _events.addAll(events);
    notifyListeners();
  }

  /// Updates an existing event.
  ///
  /// [id] - The ID of the event to update.
  /// [updatedEvent] - The updated event data.
  ///
  /// Does nothing if no event with the given ID is found.
  void updateEvent(String id, CalendarEvent updatedEvent) {
    final index = _events.indexWhere((e) => e.id == id);
    if (index != -1) {
      _events[index] = updatedEvent;
      notifyListeners();
    }
  }

  /// Removes an event from the calendar.
  ///
  /// [id] - The ID of the event to remove.
  void removeEvent(String id) {
    _events.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  /// Removes multiple events from the calendar.
  ///
  /// [ids] - The list of event IDs to remove.
  void removeEvents(List<String> ids) {
    _events.removeWhere((e) => ids.contains(e.id));
    notifyListeners();
  }

  /// Removes all events from the calendar.
  void clearEvents() {
    _events.clear();
    notifyListeners();
  }

  /// Replaces all events in the calendar.
  ///
  /// [events] - The new list of events.
  void setEvents(List<CalendarEvent> events) {
    _events
      ..clear()
      ..addAll(events);
    notifyListeners();
  }

  /// Gets all events that occur on a specific day.
  ///
  /// [day] - The day to query.
  ///
  /// Returns a list of events sorted by start time, with all-day events first.
  List<CalendarEvent> getEventsForDay(DateTime day) =>
      _events.where((event) => event.occursOnDate(day)).toList()
        ..sort((a, b) {
          if (a.isAllDay && !b.isAllDay) {
            return -1;
          }
          if (!a.isAllDay && b.isAllDay) {
            return 1;
          }
          return a.startDate.compareTo(b.startDate);
        });

  /// Gets all events that occur within a date range.
  ///
  /// [start] - The start date of the range.
  /// [end] - The end date of the range.
  ///
  /// Returns a list of unique events sorted by start date.
  List<CalendarEvent> getEventsForRange(DateTime start, DateTime end) {
    final dateRange = calendar_utils.getDateRange(start, end);
    final eventsSet = <CalendarEvent>{};

    for (final date in dateRange) {
      eventsSet.addAll(getEventsForDay(date));
    }

    return eventsSet.toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
  }

  /// Gets all events in the currently focused month.
  List<CalendarEvent> getEventsForMonth() {
    final start = calendar_utils.getStartOfMonth(_focusedDay);
    final end = calendar_utils.getEndOfMonth(_focusedDay);
    return getEventsForRange(start, end);
  }

  /// Gets all events in the currently focused week.
  List<CalendarEvent> getEventsForWeek() {
    final start = calendar_utils.getStartOfWeek(_focusedDay, _weekStartDay);
    final end = calendar_utils.getEndOfWeek(_focusedDay, _weekStartDay);
    return getEventsForRange(start, end);
  }

  /// Gets an event by its ID.
  ///
  /// [id] - The event ID to search for.
  ///
  /// Returns the event if found, null otherwise.
  CalendarEvent? getEventById(String id) {
    try {
      return _events.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Gets all events in a specific category.
  ///
  /// [category] - The category to filter by.
  List<CalendarEvent> getEventsByCategory(String category) =>
      _events.where((e) => e.category == category).toList();

  /// Gets all events with a specific priority.
  ///
  /// [priority] - The priority level to filter by.
  List<CalendarEvent> getEventsByPriority(EventPriority priority) =>
      _events.where((e) => e.priority == priority).toList();

  /// Gets all events with a specific status.
  ///
  /// [status] - The status to filter by.
  List<CalendarEvent> getEventsByStatus(EventStatus status) =>
      _events.where((e) => e.status == status).toList();

  /// Checks if a day has any events.
  ///
  /// [day] - The day to check.
  ///
  /// Returns true if there are events on this day.
  bool hasEventsOnDay(DateTime day) =>
      _events.any((event) => event.occursOnDate(day));

  /// Gets the number of events on a specific day.
  ///
  /// [day] - The day to count events for.
  int getEventCountForDay(DateTime day) => getEventsForDay(day).length;

  // ==================== Holiday Management ====================

  /// Adds a holiday to the calendar.
  ///
  /// [date] - The date to mark as a holiday.
  ///
  /// Does nothing if the date is already marked as a holiday.
  void addHoliday(DateTime date) {
    if (!_holidays.any((d) => calendar_utils.isSameDay(d, date))) {
      _holidays.add(date);
      notifyListeners();
    }
  }

  /// Adds multiple holidays to the calendar.
  ///
  /// [dates] - The list of dates to mark as holidays.
  void addHolidays(List<DateTime> dates) {
    for (final date in dates) {
      if (!_holidays.any((d) => calendar_utils.isSameDay(d, date))) {
        _holidays.add(date);
      }
    }
    notifyListeners();
  }

  /// Removes a holiday from the calendar.
  ///
  /// [date] - The date to remove from holidays.
  void removeHoliday(DateTime date) {
    _holidays.removeWhere((d) => calendar_utils.isSameDay(d, date));
    notifyListeners();
  }

  /// Removes all holidays from the calendar.
  void clearHolidays() {
    _holidays.clear();
    notifyListeners();
  }

  /// Checks if a date is marked as a holiday.
  ///
  /// [date] - The date to check.
  ///
  /// Returns true if the date is a holiday.
  bool isHoliday(DateTime date) =>
      _holidays.any((d) => calendar_utils.isSameDay(d, date));

  /// Checks if today is a holiday.
  bool isTodayHoliday() {
    final today = DateTime.now();
    return isHoliday(today);
  }

  /// Gets all holidays within a date range.
  ///
  /// [start] - The start date of the range.
  /// [end] - The end date of the range.
  List<DateTime> getHolidaysInRange(DateTime start, DateTime end) => _holidays
      .where((holiday) => !holiday.isBefore(start) && !holiday.isAfter(end))
      .toList();

  /// Gets all holidays in the currently focused month.
  List<DateTime> getHolidaysForMonth() {
    final start = calendar_utils.getStartOfMonth(_focusedDay);
    final end = calendar_utils.getEndOfMonth(_focusedDay);
    return getHolidaysInRange(start, end);
  }

  // ==================== Configuration ====================

  /// Sets the first day of the week.
  ///
  /// [weekday] - The weekday to use as the first day (1=Monday, 7=Sunday).
  ///
  /// Throws an assertion error if weekday is not between 1 and 7.
  void setWeekStartDay(int weekday) {
    assert(weekday >= 1 && weekday <= 7, 'Weekday must be between 1 and 7');
    _weekStartDay = weekday;
    notifyListeners();
  }

  /// Sets whether to hide weekends from the calendar.
  ///
  /// [hide] - True to hide weekends, false to show them.
  void setHideWeekends(bool hide) {
    _hideWeekends = hide;
    notifyListeners();
  }

  /// Toggles the visibility of weekends.
  void toggleHideWeekends() {
    _hideWeekends = !_hideWeekends;
    notifyListeners();
  }

  // ==================== Utility Methods ====================

  /// Checks if a date is today.
  ///
  /// [date] - The date to check.
  bool isToday(DateTime date) => calendar_utils.isToday(date);

  /// Checks if a date is in the currently focused month.
  ///
  /// [date] - The date to check.
  bool isInFocusedMonth(DateTime date) =>
      calendar_utils.isSameMonth(date, _focusedDay);

  /// Checks if a date is a weekend (Saturday or Sunday).
  ///
  /// [date] - The date to check.
  bool isWeekend(DateTime date) => calendar_utils.isWeekend(date);

  /// Gets all visible days for the current month view.
  ///
  /// This includes days from previous/next months to fill the calendar grid.
  List<DateTime> getVisibleDays() => calendar_utils.getVisibleDays(
        _focusedDay,
        _weekStartDay,
        hideWeekends: _hideWeekends,
      );

  /// Gets all days in the currently focused week.
  ///
  /// Excludes weekends if [hideWeekends] is true.
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

  /// Gets the focused month and year as a formatted string.
  ///
  /// Returns format: "January 2024"
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

  @override
  void dispose() {
    _events.clear();
    _holidays.clear();
    _selectedDays.clear();
    super.dispose();
  }
}
