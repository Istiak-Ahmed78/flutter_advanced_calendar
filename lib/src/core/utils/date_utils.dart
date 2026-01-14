/// Date utility functions for calendar operations
library date_utils;

/// Check if two dates are the same day
bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Check if two dates are in the same week
bool isSameWeek(DateTime a, DateTime b, int weekStartDay) {
  final startOfWeekA = getStartOfWeek(a, weekStartDay);
  final startOfWeekB = getStartOfWeek(b, weekStartDay);
  return isSameDay(startOfWeekA, startOfWeekB);
}

/// Check if two dates are in the same month
bool isSameMonth(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month;

/// Get the start of the week for a given date
DateTime getStartOfWeek(DateTime date, int weekStartDay) {
  final daysFromStart = (date.weekday - weekStartDay + 7) % 7;
  return DateTime(date.year, date.month, date.day).subtract(
    Duration(days: daysFromStart),
  );
}

/// Get the end of the week for a given date
DateTime getEndOfWeek(DateTime date, int weekStartDay) {
  final startOfWeek = getStartOfWeek(date, weekStartDay);
  return startOfWeek.add(const Duration(days: 6));
}

/// Get all days in a week starting from the given date
List<DateTime> getWeekDays(DateTime date, int weekStartDay) {
  final startOfWeek = getStartOfWeek(date, weekStartDay);
  return List.generate(
    7,
    (index) => startOfWeek.add(Duration(days: index)),
  );
}

/// Get the start of the month
DateTime getStartOfMonth(DateTime date) => DateTime(date.year, date.month);

/// Get the end of the month
DateTime getEndOfMonth(DateTime date) => DateTime(date.year, date.month + 1, 0);

/// Get the number of days in a month
int getDaysInMonth(DateTime date) => DateTime(date.year, date.month + 1, 0).day;

/// Get all days in a month
List<DateTime> getDaysInMonthList(DateTime date) {
  final daysInMonth = getDaysInMonth(date);
  return List.generate(
    daysInMonth,
    (index) => DateTime(date.year, date.month, index + 1),
  );
}

/// Get visible days for month view (including padding days from prev/next month)
List<DateTime> getVisibleDays(DateTime month, int weekStartDay,
    {bool hideWeekends = false}) {
  final firstDayOfMonth = getStartOfMonth(month);
  final lastDayOfMonth = getEndOfMonth(month);

  final startOfCalendar = getStartOfWeek(firstDayOfMonth, weekStartDay);
  final endOfCalendar = getEndOfWeek(lastDayOfMonth, weekStartDay);

  final days = <DateTime>[];
  var current = startOfCalendar;

  while (!current.isAfter(endOfCalendar)) {
    if (!hideWeekends ||
        (current.weekday != DateTime.saturday &&
            current.weekday != DateTime.sunday)) {
      days.add(current);
    }
    current = current.add(const Duration(days: 1));
  }

  return days;
}

/// Get week number in year
int getWeekNumber(DateTime date) {
  final firstDayOfYear = DateTime(date.year);
  final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
  return ((daysSinceFirstDay + firstDayOfYear.weekday) / 7).ceil();
}

/// Check if date is today
bool isToday(DateTime date) {
  final now = DateTime.now();
  return isSameDay(date, now);
}

/// Check if date is in the past
bool isPast(DateTime date) {
  final now = DateTime.now();
  return date.isBefore(DateTime(now.year, now.month, now.day));
}

/// Check if date is in the future
bool isFuture(DateTime date) {
  final now = DateTime.now();
  return date.isAfter(DateTime(now.year, now.month, now.day));
}

/// Check if date is weekend
bool isWeekend(DateTime date) =>
    date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;

/// Get date range between two dates
List<DateTime> getDateRange(DateTime start, DateTime end) {
  final days = <DateTime>[];
  var current = DateTime(start.year, start.month, start.day);
  final endDate = DateTime(end.year, end.month, end.day);

  while (!current.isAfter(endDate)) {
    days.add(current);
    current = current.add(const Duration(days: 1));
  }

  return days;
}

/// Add months to a date
DateTime addMonths(DateTime date, int months) {
  var newYear = date.year;
  var newMonth = date.month + months;

  while (newMonth > 12) {
    newMonth -= 12;
    newYear++;
  }

  while (newMonth < 1) {
    newMonth += 12;
    newYear--;
  }

  final daysInNewMonth = getDaysInMonth(DateTime(newYear, newMonth));
  final newDay = date.day > daysInNewMonth ? daysInNewMonth : date.day;

  return DateTime(
      newYear, newMonth, newDay, date.hour, date.minute, date.second);
}

/// Copy time from one DateTime to another
DateTime copyTimeToDate(DateTime date, DateTime time) => DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
      time.second,
      time.millisecond,
      time.microsecond,
    );

/// Get DateTime at start of day (00:00:00)
DateTime getStartOfDay(DateTime date) =>
    DateTime(date.year, date.month, date.day);

/// Get DateTime at end of day (23:59:59)
DateTime getEndOfDay(DateTime date) =>
    DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
