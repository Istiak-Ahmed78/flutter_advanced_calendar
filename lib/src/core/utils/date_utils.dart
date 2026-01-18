/// Date utility functions for calendar operations.
///
/// This library provides a comprehensive set of date manipulation and
/// comparison functions specifically designed for calendar applications.
///
/// Example:
/// ```dart
/// import 'date_utils.dart' as calendar_utils;
///
/// final today = DateTime.now();
/// final isWeekend = calendar_utils.isWeekend(today);
/// final weekDays = calendar_utils.getWeekDays(today, DateTime.monday);
/// ```
library;

/// Checks if two dates represent the same calendar day.
///
/// Ignores time components and only compares year, month, and day.
///
/// [a] - The first date to compare.
/// [b] - The second date to compare.
///
/// Returns true if both dates are on the same day.
///
/// Example:
/// ```dart
/// final date1 = DateTime(2024, 1, 15, 10, 30);
/// final date2 = DateTime(2024, 1, 15, 18, 45);
/// print(isSameDay(date1, date2)); // true
/// ```
bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Checks if two dates are in the same week.
///
/// [a] - The first date to compare.
/// [b] - The second date to compare.
/// [weekStartDay] - The first day of the week (1=Monday, 7=Sunday).
///
/// Returns true if both dates fall within the same week.
///
/// Example:
/// ```dart
/// final monday = DateTime(2024, 1, 15);
/// final friday = DateTime(2024, 1, 19);
/// print(isSameWeek(monday, friday, DateTime.monday)); // true
/// ```
bool isSameWeek(DateTime a, DateTime b, int weekStartDay) {
  final startOfWeekA = getStartOfWeek(a, weekStartDay);
  final startOfWeekB = getStartOfWeek(b, weekStartDay);
  return isSameDay(startOfWeekA, startOfWeekB);
}

/// Checks if two dates are in the same month.
///
/// Ignores day and time components.
///
/// [a] - The first date to compare.
/// [b] - The second date to compare.
///
/// Returns true if both dates are in the same month and year.
///
/// Example:
/// ```dart
/// final date1 = DateTime(2024, 1, 1);
/// final date2 = DateTime(2024, 1, 31);
/// print(isSameMonth(date1, date2)); // true
/// ```
bool isSameMonth(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month;

/// Gets the first day of the week containing the given date.
///
/// [date] - The date to find the week start for.
/// [weekStartDay] - The first day of the week (1=Monday, 7=Sunday).
///
/// Returns a DateTime representing the start of the week at 00:00:00.
///
/// Example:
/// ```dart
/// final wednesday = DateTime(2024, 1, 17);
/// final monday = getStartOfWeek(wednesday, DateTime.monday);
/// print(monday); // 2024-01-15 00:00:00
/// ```
DateTime getStartOfWeek(DateTime date, int weekStartDay) {
  final daysFromStart = (date.weekday - weekStartDay + 7) % 7;
  return DateTime(date.year, date.month, date.day).subtract(
    Duration(days: daysFromStart),
  );
}

/// Gets the last day of the week containing the given date.
///
/// [date] - The date to find the week end for.
/// [weekStartDay] - The first day of the week (1=Monday, 7=Sunday).
///
/// Returns a DateTime representing the end of the week at 00:00:00.
///
/// Example:
/// ```dart
/// final wednesday = DateTime(2024, 1, 17);
/// final sunday = getEndOfWeek(wednesday, DateTime.monday);
/// print(sunday); // 2024-01-21 00:00:00
/// ```
DateTime getEndOfWeek(DateTime date, int weekStartDay) {
  final startOfWeek = getStartOfWeek(date, weekStartDay);
  return startOfWeek.add(const Duration(days: 6));
}

/// Gets all seven days in the week containing the given date.
///
/// [date] - Any date within the desired week.
/// [weekStartDay] - The first day of the week (1=Monday, 7=Sunday).
///
/// Returns a list of 7 DateTime objects representing each day of the week.
///
/// Example:
/// ```dart
/// final wednesday = DateTime(2024, 1, 17);
/// final weekDays = getWeekDays(wednesday, DateTime.monday);
/// // Returns [Mon 15, Tue 16, Wed 17, Thu 18, Fri 19, Sat 20, Sun 21]
/// ```
List<DateTime> getWeekDays(DateTime date, int weekStartDay) {
  final startOfWeek = getStartOfWeek(date, weekStartDay);
  return List.generate(
    7,
    (index) => startOfWeek.add(Duration(days: index)),
  );
}

/// Gets the first day of the month containing the given date.
///
/// [date] - Any date within the desired month.
///
/// Returns a DateTime representing the first day of the month at 00:00:00.
///
/// Example:
/// ```dart
/// final anyDay = DateTime(2024, 1, 15);
/// final firstDay = getStartOfMonth(anyDay);
/// print(firstDay); // 2024-01-01 00:00:00
/// ```
DateTime getStartOfMonth(DateTime date) => DateTime(date.year, date.month);

/// Gets the last day of the month containing the given date.
///
/// [date] - Any date within the desired month.
///
/// Returns a DateTime representing the last day of the month at 00:00:00.
///
/// Example:
/// ```dart
/// final anyDay = DateTime(2024, 1, 15);
/// final lastDay = getEndOfMonth(anyDay);
/// print(lastDay); // 2024-01-31 00:00:00
/// ```
DateTime getEndOfMonth(DateTime date) => DateTime(date.year, date.month + 1, 0);

/// Gets the number of days in the month containing the given date.
///
/// [date] - Any date within the desired month.
///
/// Returns the number of days (28-31).
///
/// Example:
/// ```dart
/// final january = DateTime(2024, 1, 15);
/// print(getDaysInMonth(january)); // 31
///
/// final february = DateTime(2024, 2, 15);
/// print(getDaysInMonth(february)); // 29 (leap year)
/// ```
int getDaysInMonth(DateTime date) => DateTime(date.year, date.month + 1, 0).day;

/// Gets a list of all days in the month containing the given date.
///
/// [date] - Any date within the desired month.
///
/// Returns a list of DateTime objects for each day in the month.
///
/// Example:
/// ```dart
/// final january = DateTime(2024, 1, 15);
/// final days = getDaysInMonthList(january);
/// print(days.length); // 31
/// ```
List<DateTime> getDaysInMonthList(DateTime date) {
  final daysInMonth = getDaysInMonth(date);
  return List.generate(
    daysInMonth,
    (index) => DateTime(date.year, date.month, index + 1),
  );
}

/// Gets all visible days for a month view calendar.
///
/// Includes padding days from the previous and next months to fill
/// complete weeks, ensuring the calendar grid is complete.
///
/// [month] - Any date within the desired month.
/// [weekStartDay] - The first day of the week (1=Monday, 7=Sunday).
/// [hideWeekends] - Whether to exclude Saturday and Sunday. Defaults to false.
///
/// Returns a list of DateTime objects representing all visible days.
///
/// Example:
/// ```dart
/// final january = DateTime(2024, 1, 15);
/// final visibleDays = getVisibleDays(january, DateTime.monday);
/// // Returns ~35-42 days including padding from Dec and Feb
/// ```
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

/// Gets the ISO week number for a given date.
///
/// Week 1 is the week containing the first Thursday of the year.
///
/// [date] - The date to get the week number for.
///
/// Returns the week number (1-53).
///
/// Example:
/// ```dart
/// final date = DateTime(2024, 1, 15);
/// print(getWeekNumber(date)); // 3
/// ```
int getWeekNumber(DateTime date) {
  final firstDayOfYear = DateTime(date.year);
  final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
  return ((daysSinceFirstDay + firstDayOfYear.weekday) / 7).ceil();
}

/// Checks if the given date is today.
///
/// Compares only the date components, ignoring time.
///
/// [date] - The date to check.
///
/// Returns true if the date is today.
///
/// Example:
/// ```dart
/// final now = DateTime.now();
/// print(isToday(now)); // true
///
/// final yesterday = now.subtract(Duration(days: 1));
/// print(isToday(yesterday)); // false
/// ```
bool isToday(DateTime date) {
  final now = DateTime.now();
  return isSameDay(date, now);
}

/// Checks if the given date is in the past.
///
/// Compares only the date components, ignoring time.
/// Today is not considered past.
///
/// [date] - The date to check.
///
/// Returns true if the date is before today.
///
/// Example:
/// ```dart
/// final yesterday = DateTime.now().subtract(Duration(days: 1));
/// print(isPast(yesterday)); // true
/// ```
bool isPast(DateTime date) {
  final now = DateTime.now();
  return date.isBefore(DateTime(now.year, now.month, now.day));
}

/// Checks if the given date is in the future.
///
/// Compares only the date components, ignoring time.
/// Today is not considered future.
///
/// [date] - The date to check.
///
/// Returns true if the date is after today.
///
/// Example:
/// ```dart
/// final tomorrow = DateTime.now().add(Duration(days: 1));
/// print(isFuture(tomorrow)); // true
/// ```
bool isFuture(DateTime date) {
  final now = DateTime.now();
  return date.isAfter(DateTime(now.year, now.month, now.day));
}

/// Checks if the given date falls on a weekend (Saturday or Sunday).
///
/// [date] - The date to check.
///
/// Returns true if the date is Saturday or Sunday.
///
/// Example:
/// ```dart
/// final saturday = DateTime(2024, 1, 20);
/// print(isWeekend(saturday)); // true
///
/// final monday = DateTime(2024, 1, 15);
/// print(isWeekend(monday)); // false
/// ```
bool isWeekend(DateTime date) =>
    date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;

/// Gets all dates between two dates (inclusive).
///
/// [start] - The start date of the range.
/// [end] - The end date of the range.
///
/// Returns a list of DateTime objects for each day in the range.
/// Time components are normalized to 00:00:00.
///
/// Example:
/// ```dart
/// final start = DateTime(2024, 1, 15);
/// final end = DateTime(2024, 1, 18);
/// final range = getDateRange(start, end);
/// print(range.length); // 4 (includes both start and end)
/// ```
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

/// Adds a specified number of months to a date.
///
/// Handles month/year overflow correctly and adjusts the day if it
/// exceeds the number of days in the target month.
///
/// [date] - The starting date.
/// [months] - The number of months to add (can be negative).
///
/// Returns a new DateTime with the months added.
///
/// Example:
/// ```dart
/// final jan31 = DateTime(2024, 1, 31);
/// final feb = addMonths(jan31, 1);
/// print(feb); // 2024-02-29 (adjusted from 31 to 29)
///
/// final dec = addMonths(jan31, -1);
/// print(dec); // 2023-12-31
/// ```
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

/// Copies the time components from one DateTime to another.
///
/// Takes the date components (year, month, day) from [date] and
/// the time components (hour, minute, second, etc.) from [time].
///
/// [date] - The DateTime to take the date from.
/// [time] - The DateTime to take the time from.
///
/// Returns a new DateTime combining both.
///
/// Example:
/// ```dart
/// final date = DateTime(2024, 1, 15);
/// final time = DateTime(2024, 1, 1, 14, 30, 45);
/// final combined = copyTimeToDate(date, time);
/// print(combined); // 2024-01-15 14:30:45
/// ```
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

/// Gets a DateTime representing the start of the day (00:00:00.000).
///
/// [date] - The date to get the start of.
///
/// Returns a new DateTime with time set to midnight.
///
/// Example:
/// ```dart
/// final now = DateTime.now(); // 2024-01-15 14:30:45
/// final startOfDay = getStartOfDay(now);
/// print(startOfDay); // 2024-01-15 00:00:00.000
/// ```
DateTime getStartOfDay(DateTime date) =>
    DateTime(date.year, date.month, date.day);

/// Gets a DateTime representing the end of the day (23:59:59.999).
///
/// [date] - The date to get the end of.
///
/// Returns a new DateTime with time set to the last millisecond of the day.
///
/// Example:
/// ```dart
/// final now = DateTime.now(); // 2024-01-15 14:30:45
/// final endOfDay = getEndOfDay(now);
/// print(endOfDay); // 2024-01-15 23:59:59.999
/// ```
DateTime getEndOfDay(DateTime date) =>
    DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
