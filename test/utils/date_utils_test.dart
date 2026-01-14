import 'package:flutter_advanced_calendar/src/core/utils/date_utils.dart'
    as calendar_utils;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Date Utils Tests', () {
    group('isSameDay', () {
      test('returns true for same day', () {
        final date1 = DateTime(2024, 1, 15, 10, 30);
        final date2 = DateTime(2024, 1, 15, 14, 45);

        expect(calendar_utils.isSameDay(date1, date2), true);
      });

      test('returns false for different days', () {
        final date1 = DateTime(2024, 1, 15);
        final date2 = DateTime(2024, 1, 16);

        expect(calendar_utils.isSameDay(date1, date2), false);
      });

      test('returns false for different months', () {
        final date1 = DateTime(2024, 1, 15);
        final date2 = DateTime(2024, 2, 15);

        expect(calendar_utils.isSameDay(date1, date2), false);
      });

      test('returns false for different years', () {
        final date1 = DateTime(2024, 1, 15);
        final date2 = DateTime(2025, 1, 15);

        expect(calendar_utils.isSameDay(date1, date2), false);
      });
    });

    group('isSameWeek', () {
      test('returns true for dates in same week (Monday start)', () {
        final monday = DateTime(2024, 1, 15);
        final friday = DateTime(2024, 1, 19);

        expect(
          calendar_utils.isSameWeek(monday, friday, DateTime.monday),
          true,
        );
      });

      test('returns false for dates in different weeks (Monday start)', () {
        final date1 = DateTime(2024, 1, 15);
        final date2 = DateTime(2024, 1, 22);

        expect(
          calendar_utils.isSameWeek(date1, date2, DateTime.monday),
          false,
        );
      });

      test('returns true for dates in same week (Sunday start)', () {
        final sunday = DateTime(2024, 1, 14);
        final saturday = DateTime(2024, 1, 20);

        expect(
          calendar_utils.isSameWeek(sunday, saturday, DateTime.sunday),
          true,
        );
      });
    });

    group('isSameMonth', () {
      test('returns true for same month and year', () {
        final date1 = DateTime(2024, 1, 15);
        final date2 = DateTime(2024, 1, 25);

        expect(calendar_utils.isSameMonth(date1, date2), true);
      });

      test('returns false for different months', () {
        final date1 = DateTime(2024, 1, 15);
        final date2 = DateTime(2024, 2, 15);

        expect(calendar_utils.isSameMonth(date1, date2), false);
      });

      test('returns false for same month but different years', () {
        final date1 = DateTime(2024, 1, 15);
        final date2 = DateTime(2025, 1, 15);

        expect(calendar_utils.isSameMonth(date1, date2), false);
      });
    });

    group('getStartOfWeek', () {
      test('returns correct start of week for Monday start', () {
        final date = DateTime(2024, 1, 17);
        final startOfWeek =
            calendar_utils.getStartOfWeek(date, DateTime.monday);

        expect(startOfWeek.day, 15);
        expect(startOfWeek.weekday, DateTime.monday);
      });

      test('returns correct start of week for Sunday start', () {
        final date = DateTime(2024, 1, 17);
        final startOfWeek =
            calendar_utils.getStartOfWeek(date, DateTime.sunday);

        expect(startOfWeek.day, 14);
        expect(startOfWeek.weekday, DateTime.sunday);
      });

      test('returns same date if already at start of week', () {
        final monday = DateTime(2024, 1, 15);
        final startOfWeek =
            calendar_utils.getStartOfWeek(monday, DateTime.monday);

        expect(calendar_utils.isSameDay(monday, startOfWeek), true);
      });
    });

    group('getEndOfWeek', () {
      test('returns correct end of week for Monday start', () {
        final date = DateTime(2024, 1, 15);
        final endOfWeek = calendar_utils.getEndOfWeek(date, DateTime.monday);

        expect(endOfWeek.day, 21);
        expect(endOfWeek.weekday, DateTime.sunday);
      });

      test('returns correct end of week for Sunday start', () {
        final date = DateTime(2024, 1, 14);
        final endOfWeek = calendar_utils.getEndOfWeek(date, DateTime.sunday);

        expect(endOfWeek.day, 20);
        expect(endOfWeek.weekday, DateTime.saturday);
      });
    });

    group('getWeekDays', () {
      test('returns 7 days starting from Monday', () {
        final date = DateTime(2024, 1, 15);
        final weekDays = calendar_utils.getWeekDays(date, DateTime.monday);

        expect(weekDays.length, 7);
        expect(weekDays.first.weekday, DateTime.monday);
        expect(weekDays.last.weekday, DateTime.sunday);
      });

      test('returns 7 days starting from Sunday', () {
        final date = DateTime(2024, 1, 14);
        final weekDays = calendar_utils.getWeekDays(date, DateTime.sunday);

        expect(weekDays.length, 7);
        expect(weekDays.first.weekday, DateTime.sunday);
        expect(weekDays.last.weekday, DateTime.saturday);
      });

      test('returns consecutive days', () {
        final date = DateTime(2024, 1, 15);
        final weekDays = calendar_utils.getWeekDays(date, DateTime.monday);

        for (var i = 0; i < weekDays.length - 1; i++) {
          expect(
            weekDays[i + 1].difference(weekDays[i]).inDays,
            1,
          );
        }
      });
    });

    group('getStartOfMonth', () {
      test('returns first day of month', () {
        final date = DateTime(2024, 1, 15);
        final startOfMonth = calendar_utils.getStartOfMonth(date);

        expect(startOfMonth.year, 2024);
        expect(startOfMonth.month, 1);
        expect(startOfMonth.day, 1);
      });

      test('returns first day for last day of month', () {
        final date = DateTime(2024, 1, 31);
        final startOfMonth = calendar_utils.getStartOfMonth(date);

        expect(startOfMonth.day, 1);
      });
    });

    group('getEndOfMonth', () {
      test('returns last day of January', () {
        final date = DateTime(2024, 1, 15);
        final endOfMonth = calendar_utils.getEndOfMonth(date);

        expect(endOfMonth.day, 31);
      });

      test('returns last day of February in leap year', () {
        final date = DateTime(2024, 2, 15);
        final endOfMonth = calendar_utils.getEndOfMonth(date);

        expect(endOfMonth.day, 29);
      });

      test('returns last day of February in non-leap year', () {
        final date = DateTime(2023, 2, 15);
        final endOfMonth = calendar_utils.getEndOfMonth(date);

        expect(endOfMonth.day, 28);
      });

      test('returns last day of April', () {
        final date = DateTime(2024, 4, 15);
        final endOfMonth = calendar_utils.getEndOfMonth(date);

        expect(endOfMonth.day, 30);
      });
    });

    group('getDaysInMonth', () {
      test('returns 31 for January', () {
        final date = DateTime(2024, 1, 15);
        expect(calendar_utils.getDaysInMonth(date), 31);
      });

      test('returns 29 for February in leap year', () {
        final date = DateTime(2024, 2, 15);
        expect(calendar_utils.getDaysInMonth(date), 29);
      });

      test('returns 28 for February in non-leap year', () {
        final date = DateTime(2023, 2, 15);
        expect(calendar_utils.getDaysInMonth(date), 28);
      });

      test('returns 30 for April', () {
        final date = DateTime(2024, 4, 15);
        expect(calendar_utils.getDaysInMonth(date), 30);
      });

      test('returns 31 for December', () {
        final date = DateTime(2024, 12, 15);
        expect(calendar_utils.getDaysInMonth(date), 31);
      });
    });

    group('getDaysInMonthList', () {
      test('returns correct number of days for January', () {
        final date = DateTime(2024, 1, 15);
        final days = calendar_utils.getDaysInMonthList(date);

        expect(days.length, 31);
        expect(days.first.day, 1);
        expect(days.last.day, 31);
      });

      test('returns correct number of days for February in leap year', () {
        final date = DateTime(2024, 2, 15);
        final days = calendar_utils.getDaysInMonthList(date);

        expect(days.length, 29);
        expect(days.last.day, 29);
      });

      test('all days are in the same month', () {
        final date = DateTime(2024, 1, 15);
        final days = calendar_utils.getDaysInMonthList(date);

        for (final day in days) {
          expect(day.month, 1);
          expect(day.year, 2024);
        }
      });
    });

    group('getVisibleDays', () {
      test('returns days including padding from adjacent months', () {
        final date = DateTime(2024, 1, 15);
        final days = calendar_utils.getVisibleDays(date, DateTime.monday);

        expect(days.length, greaterThan(31));
        expect(days.first.weekday, DateTime.monday);
      });

      test('excludes weekends when hideWeekends is true', () {
        final date = DateTime(2024, 1, 15);
        final days = calendar_utils.getVisibleDays(
          date,
          DateTime.monday,
          hideWeekends: true,
        );

        for (final day in days) {
          expect(day.weekday, isNot(DateTime.saturday));
          expect(day.weekday, isNot(DateTime.sunday));
        }
      });

      test('includes weekends when hideWeekends is false', () {
        final date = DateTime(2024, 1, 15);
        final days = calendar_utils.getVisibleDays(
          date,
          DateTime.monday,
        );

        final hasSaturday = days.any((d) => d.weekday == DateTime.saturday);
        final hasSunday = days.any((d) => d.weekday == DateTime.sunday);

        expect(hasSaturday, true);
        expect(hasSunday, true);
      });
    });

    group('getWeekNumber', () {
      test('returns 1 for first week of year', () {
        final date = DateTime(2024);
        expect(calendar_utils.getWeekNumber(date), 1);
      });

      test('returns correct week number for mid-year', () {
        final date = DateTime(2024, 6, 15);
        final weekNumber = calendar_utils.getWeekNumber(date);

        expect(weekNumber, greaterThan(20));
        expect(weekNumber, lessThan(30));
      });

      test('returns high week number for end of year', () {
        final date = DateTime(2024, 12, 31);
        final weekNumber = calendar_utils.getWeekNumber(date);

        expect(weekNumber, greaterThan(50));
      });
    });

    group('isToday', () {
      test('returns true for today', () {
        final today = DateTime.now();
        expect(calendar_utils.isToday(today), true);
      });

      test('returns false for yesterday', () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        expect(calendar_utils.isToday(yesterday), false);
      });

      test('returns false for tomorrow', () {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        expect(calendar_utils.isToday(tomorrow), false);
      });
    });

    group('isPast', () {
      test('returns true for past date', () {
        final pastDate = DateTime(2020);
        expect(calendar_utils.isPast(pastDate), true);
      });

      test('returns false for future date', () {
        final futureDate = DateTime.now().add(const Duration(days: 1));
        expect(calendar_utils.isPast(futureDate), false);
      });

      test('returns false for today', () {
        final today = DateTime.now();
        expect(calendar_utils.isPast(today), false);
      });
    });

    group('isFuture', () {
      test('returns true for future date', () {
        final futureDate = DateTime.now().add(const Duration(days: 1));
        expect(calendar_utils.isFuture(futureDate), true);
      });

      test('returns false for past date', () {
        final pastDate = DateTime(2020);
        expect(calendar_utils.isFuture(pastDate), false);
      });

      test('returns false for today', () {
        final today = DateTime.now();
        expect(calendar_utils.isFuture(today), true);
      });
    });

    group('isWeekend', () {
      test('returns true for Saturday', () {
        final saturday = DateTime(2024, 1, 20);
        expect(calendar_utils.isWeekend(saturday), true);
      });

      test('returns true for Sunday', () {
        final sunday = DateTime(2024, 1, 21);
        expect(calendar_utils.isWeekend(sunday), true);
      });

      test('returns false for Monday', () {
        final monday = DateTime(2024, 1, 15);
        expect(calendar_utils.isWeekend(monday), false);
      });

      test('returns false for Friday', () {
        final friday = DateTime(2024, 1, 19);
        expect(calendar_utils.isWeekend(friday), false);
      });
    });

    group('getDateRange', () {
      test('returns correct range for consecutive days', () {
        final start = DateTime(2024, 1, 15);
        final end = DateTime(2024, 1, 17);
        final range = calendar_utils.getDateRange(start, end);

        expect(range.length, 3);
        expect(range[0].day, 15);
        expect(range[1].day, 16);
        expect(range[2].day, 17);
      });

      test('returns single day for same start and end', () {
        final date = DateTime(2024, 1, 15);
        final range = calendar_utils.getDateRange(date, date);

        expect(range.length, 1);
        expect(range[0].day, 15);
      });

      test('returns range spanning multiple months', () {
        final start = DateTime(2024, 1, 30);
        final end = DateTime(2024, 2, 2);
        final range = calendar_utils.getDateRange(start, end);

        expect(range.length, 4);
        expect(range[0].month, 1);
        expect(range[3].month, 2);
      });

      test('ignores time component', () {
        final start = DateTime(2024, 1, 15, 10, 30);
        final end = DateTime(2024, 1, 17, 14, 45);
        final range = calendar_utils.getDateRange(start, end);

        expect(range.length, 3);
        for (final date in range) {
          expect(date.hour, 0);
          expect(date.minute, 0);
          expect(date.second, 0);
        }
      });
    });

    group('addMonths', () {
      test('adds positive months correctly', () {
        final date = DateTime(2024, 1, 15);
        final result = calendar_utils.addMonths(date, 3);

        expect(result.year, 2024);
        expect(result.month, 4);
        expect(result.day, 15);
      });

      test('subtracts negative months correctly', () {
        final date = DateTime(2024, 4, 15);
        final result = calendar_utils.addMonths(date, -2);

        expect(result.year, 2024);
        expect(result.month, 2);
        expect(result.day, 15);
      });

      test('handles year boundary forward', () {
        final date = DateTime(2024, 11, 15);
        final result = calendar_utils.addMonths(date, 3);

        expect(result.year, 2025);
        expect(result.month, 2);
        expect(result.day, 15);
      });

      test('handles year boundary backward', () {
        final date = DateTime(2024, 2, 15);
        final result = calendar_utils.addMonths(date, -3);

        expect(result.year, 2023);
        expect(result.month, 11);
        expect(result.day, 15);
      });

      test('adjusts day when target month has fewer days', () {
        final date = DateTime(2024, 1, 31);
        final result = calendar_utils.addMonths(date, 1);

        expect(result.year, 2024);
        expect(result.month, 2);
        expect(result.day, 29);
      });

      test('preserves time component', () {
        final date = DateTime(2024, 1, 15, 10, 30, 45);
        final result = calendar_utils.addMonths(date, 1);

        expect(result.hour, 10);
        expect(result.minute, 30);
        expect(result.second, 45);
      });
    });

    group('copyTimeToDate', () {
      test('copies time to different date', () {
        final date = DateTime(2024, 1, 15);
        final time = DateTime(2024, 1, 1, 14, 30, 45, 123, 456);
        final result = calendar_utils.copyTimeToDate(date, time);

        expect(result.year, 2024);
        expect(result.month, 1);
        expect(result.day, 15);
        expect(result.hour, 14);
        expect(result.minute, 30);
        expect(result.second, 45);
        expect(result.millisecond, 123);
        expect(result.microsecond, 456);
      });

      test('preserves date components', () {
        final date = DateTime(2024, 12, 31);
        final time = DateTime(2024, 1, 1, 10);
        final result = calendar_utils.copyTimeToDate(date, time);

        expect(result.year, 2024);
        expect(result.month, 12);
        expect(result.day, 31);
      });
    });

    group('getStartOfDay', () {
      test('returns midnight for given date', () {
        final date = DateTime(2024, 1, 15, 14, 30, 45);
        final startOfDay = calendar_utils.getStartOfDay(date);

        expect(startOfDay.year, 2024);
        expect(startOfDay.month, 1);
        expect(startOfDay.day, 15);
        expect(startOfDay.hour, 0);
        expect(startOfDay.minute, 0);
        expect(startOfDay.second, 0);
        expect(startOfDay.millisecond, 0);
      });

      test('returns same date if already at midnight', () {
        final date = DateTime(2024, 1, 15);
        final startOfDay = calendar_utils.getStartOfDay(date);

        expect(calendar_utils.isSameDay(date, startOfDay), true);
        expect(startOfDay.hour, 0);
      });
    });

    group('getEndOfDay', () {
      test('returns end of day (23:59:59.999)', () {
        final date = DateTime(2024, 1, 15, 10, 30);
        final endOfDay = calendar_utils.getEndOfDay(date);

        expect(endOfDay.year, 2024);
        expect(endOfDay.month, 1);
        expect(endOfDay.day, 15);
        expect(endOfDay.hour, 23);
        expect(endOfDay.minute, 59);
        expect(endOfDay.second, 59);
        expect(endOfDay.millisecond, 999);
      });

      test('preserves date components', () {
        final date = DateTime(2024, 12, 31, 10);
        final endOfDay = calendar_utils.getEndOfDay(date);

        expect(endOfDay.year, 2024);
        expect(endOfDay.month, 12);
        expect(endOfDay.day, 31);
      });
    });

    group('Edge Cases', () {
      test('handles leap year correctly', () {
        final leapYear = DateTime(2024, 2, 29);
        expect(calendar_utils.getDaysInMonth(leapYear), 29);
      });

      test('handles non-leap year correctly', () {
        final nonLeapYear = DateTime(2023, 2, 15);
        expect(calendar_utils.getDaysInMonth(nonLeapYear), 28);
      });

      test('handles century leap year', () {
        final centuryLeapYear = DateTime(2000, 2, 15);
        expect(calendar_utils.getDaysInMonth(centuryLeapYear), 29);
      });

      test('handles century non-leap year', () {
        final centuryNonLeapYear = DateTime(1900, 2, 15);
        expect(calendar_utils.getDaysInMonth(centuryNonLeapYear), 28);
      });

      test('handles year boundary in getDateRange', () {
        final start = DateTime(2024, 12, 30);
        final end = DateTime(2025, 1, 2);
        final range = calendar_utils.getDateRange(start, end);

        expect(range.length, 4);
        expect(range[0].year, 2024);
        expect(range[3].year, 2025);
      });

      test('handles month with 31 days to month with 30 days', () {
        final date = DateTime(2024, 1, 31);
        final result = calendar_utils.addMonths(date, 3);

        expect(result.month, 4);
        expect(result.day, 30);
      });
    });
  });
}
