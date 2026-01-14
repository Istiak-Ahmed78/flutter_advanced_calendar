import 'package:flutter/material.dart';
import 'package:flutter_advanced_calendar/src/core/models/calendar_config.dart';
import 'package:flutter_advanced_calendar/src/core/models/enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CalendarConfig Tests', () {
    test('CalendarConfig creates with default values', () {
      const config = CalendarConfig();

      expect(config.initialView, CalendarView.month);
      expect(config.showWeekNumbers, false);
      expect(config.weekStartDay, WeekStartDay.monday);
      expect(config.enableRangeSelection, false);
      expect(config.enableMultiDayEvents, true);
      expect(config.hideWeekends, false);
      expect(config.showHolidays, true);
      expect(config.enableVerticalScroll, false);
      expect(config.allowSameDayRange, true);
      expect(config.enableSwipeNavigation, true);
      expect(config.enableDragAndDrop, false);
      expect(config.show24HourFormat, true);
      expect(config.showEventTime, true);
      expect(config.showEventLocation, false);
      expect(config.showEventIcon, true);
      expect(config.maxEventsPerDay, 3);
      expect(config.compactMode, false);
      expect(config.showEventDots, true);
      expect(config.maxEventDotsPerDay, 3);
      expect(config.enableLongPress, true);
      expect(config.enableDoubleTap, false);
      expect(config.animationDuration, const Duration(milliseconds: 300));
      expect(config.locale, null);
      expect(config.holidays, isEmpty);
      expect(config.holidayNames, isEmpty);
    });

    test('CalendarConfig creates with custom values', () {
      final minDate = DateTime(2024);
      final maxDate = DateTime(2024, 12, 31);
      final holidays = <DateTime>[
        DateTime(2024),
        DateTime(2024, 12, 25),
      ];
      final holidayNames = <DateTime, String>{
        DateTime(2024): 'New Year',
        DateTime(2024, 12, 25): 'Christmas',
      };

      final config = CalendarConfig(
        initialView: CalendarView.week,
        showWeekNumbers: true,
        weekStartDay: WeekStartDay.sunday,
        minDate: minDate,
        maxDate: maxDate,
        enableRangeSelection: true,
        enableMultiDayEvents: false,
        hideWeekends: true,
        showHolidays: false,
        enableVerticalScroll: true,
        allowSameDayRange: false,
        enableSwipeNavigation: false,
        enableDragAndDrop: true,
        show24HourFormat: false,
        showEventTime: false,
        showEventLocation: true,
        showEventIcon: false,
        maxEventsPerDay: 5,
        compactMode: true,
        showEventDots: false,
        maxEventDotsPerDay: 5,
        enableLongPress: false,
        enableDoubleTap: true,
        animationDuration: const Duration(milliseconds: 500),
        locale: const Locale('en', 'US'),
        holidays: holidays,
        holidayNames: holidayNames,
      );

      expect(config.initialView, CalendarView.week);
      expect(config.showWeekNumbers, true);
      expect(config.weekStartDay, WeekStartDay.sunday);
      expect(config.minDate, minDate);
      expect(config.maxDate, maxDate);
      expect(config.enableRangeSelection, true);
      expect(config.enableMultiDayEvents, false);
      expect(config.hideWeekends, true);
      expect(config.showHolidays, false);
      expect(config.enableVerticalScroll, true);
      expect(config.allowSameDayRange, false);
      expect(config.enableSwipeNavigation, false);
      expect(config.enableDragAndDrop, true);
      expect(config.show24HourFormat, false);
      expect(config.showEventTime, false);
      expect(config.showEventLocation, true);
      expect(config.showEventIcon, false);
      expect(config.maxEventsPerDay, 5);
      expect(config.compactMode, true);
      expect(config.showEventDots, false);
      expect(config.maxEventDotsPerDay, 5);
      expect(config.enableLongPress, false);
      expect(config.enableDoubleTap, true);
      expect(config.animationDuration, const Duration(milliseconds: 500));
      expect(config.locale, const Locale('en', 'US'));
      expect(config.holidays, holidays);
      expect(config.holidayNames, holidayNames);
    });

    test('CalendarConfig copyWith works correctly', () {
      const config = CalendarConfig();

      final modified = config.copyWith(
        initialView: CalendarView.week,
        hideWeekends: true,
      );

      expect(modified.initialView, CalendarView.week);
      expect(modified.showWeekNumbers, false);
      expect(modified.hideWeekends, true);
    });

    test('CalendarConfig copyWith preserves unmodified values', () {
      final originalHolidays = <DateTime>[DateTime(2024)];
      final originalHolidayNames = <DateTime, String>{
        DateTime(2024): 'New Year',
      };

      final config = CalendarConfig(
        showWeekNumbers: true,
        maxEventsPerDay: 5,
        holidays: originalHolidays,
        holidayNames: originalHolidayNames,
      );

      final modified = config.copyWith(
        compactMode: true,
      );

      expect(modified.showWeekNumbers, true);
      expect(modified.maxEventsPerDay, 5);
      expect(modified.compactMode, true);
      expect(modified.holidays, originalHolidays);
      expect(modified.holidayNames, originalHolidayNames);
    });

    test('CalendarConfig isHoliday returns correct value', () {
      final holidays = <DateTime>[
        DateTime(2024),
        DateTime(2024, 7, 4),
        DateTime(2024, 12, 25),
      ];

      final config = CalendarConfig(
        holidays: holidays,
      );

      expect(config.isHoliday(DateTime(2024)), true);
      expect(config.isHoliday(DateTime(2024, 7, 4)), true);
      expect(config.isHoliday(DateTime(2024, 12, 25)), true);
      expect(config.isHoliday(DateTime(2024, 1, 2)), false);
      expect(config.isHoliday(DateTime(2024, 6, 15)), false);
    });

    test('CalendarConfig isHoliday ignores time component', () {
      final holidays = <DateTime>[
        DateTime(2024),
      ];

      final config = CalendarConfig(
        holidays: holidays,
      );

      expect(config.isHoliday(DateTime(2024, 1, 1, 10, 30)), true);
      expect(config.isHoliday(DateTime(2024, 1, 1, 23, 59)), true);
    });

    test('CalendarConfig getHolidayName returns correct name', () {
      final holidayNames = <DateTime, String>{
        DateTime(2024): 'New Year\'s Day',
        DateTime(2024, 7, 4): 'Independence Day',
        DateTime(2024, 12, 25): 'Christmas',
      };

      final config = CalendarConfig(
        holidayNames: holidayNames,
      );

      expect(config.getHolidayName(DateTime(2024)), 'New Year\'s Day');
      expect(
        config.getHolidayName(DateTime(2024, 7, 4)),
        'Independence Day',
      );
      expect(config.getHolidayName(DateTime(2024, 12, 25)), 'Christmas');
      expect(config.getHolidayName(DateTime(2024, 1, 2)), null);
    });

    test('CalendarConfig getHolidayName ignores time component', () {
      final holidayNames = <DateTime, String>{
        DateTime(2024): 'New Year\'s Day',
      };

      final config = CalendarConfig(
        holidayNames: holidayNames,
      );

      expect(
        config.getHolidayName(DateTime(2024, 1, 1, 10, 30)),
        'New Year\'s Day',
      );
      expect(
        config.getHolidayName(DateTime(2024, 1, 1, 23, 59)),
        'New Year\'s Day',
      );
    });

    test('CalendarConfig with date constraints', () {
      final minDate = DateTime(2024);
      final maxDate = DateTime(2024, 12, 31);

      final config = CalendarConfig(
        minDate: minDate,
        maxDate: maxDate,
      );

      expect(config.minDate, minDate);
      expect(config.maxDate, maxDate);
    });

    test('CalendarConfig with different calendar views', () {
      const monthConfig = CalendarConfig();
      const weekConfig = CalendarConfig(
        initialView: CalendarView.week,
      );
      const dayConfig = CalendarConfig(
        initialView: CalendarView.day,
      );

      expect(monthConfig.initialView, CalendarView.month);
      expect(weekConfig.initialView, CalendarView.week);
      expect(dayConfig.initialView, CalendarView.day);
    });

    test('CalendarConfig with different week start days', () {
      const mondayConfig = CalendarConfig();
      const sundayConfig = CalendarConfig(
        weekStartDay: WeekStartDay.sunday,
      );
      const saturdayConfig = CalendarConfig(
        weekStartDay: WeekStartDay.saturday,
      );

      expect(mondayConfig.weekStartDay, WeekStartDay.monday);
      expect(sundayConfig.weekStartDay, WeekStartDay.sunday);
      expect(saturdayConfig.weekStartDay, WeekStartDay.saturday);
    });

    test('CalendarConfig event display settings', () {
      const config = CalendarConfig(
        showEventLocation: true,
        maxEventsPerDay: 10,
        maxEventDotsPerDay: 5,
      );

      expect(config.showEventTime, true);
      expect(config.showEventLocation, true);
      expect(config.showEventIcon, true);
      expect(config.maxEventsPerDay, 10);
      expect(config.showEventDots, true);
      expect(config.maxEventDotsPerDay, 5);
    });

    test('CalendarConfig interaction settings', () {
      const config = CalendarConfig(
        enableDoubleTap: true,
        enableDragAndDrop: true,
      );

      expect(config.enableLongPress, true);
      expect(config.enableDoubleTap, true);
      expect(config.enableSwipeNavigation, true);
      expect(config.enableDragAndDrop, true);
    });

    test('CalendarConfig animation duration', () {
      const fastConfig = CalendarConfig(
        animationDuration: Duration(milliseconds: 150),
      );
      const slowConfig = CalendarConfig(
        animationDuration: Duration(milliseconds: 600),
      );

      expect(fastConfig.animationDuration, const Duration(milliseconds: 150));
      expect(slowConfig.animationDuration, const Duration(milliseconds: 600));
    });

    test('CalendarConfig locale settings', () {
      const enConfig = CalendarConfig(
        locale: Locale('en', 'US'),
      );
      const esConfig = CalendarConfig(
        locale: Locale('es', 'ES'),
      );
      const frConfig = CalendarConfig(
        locale: Locale('fr', 'FR'),
      );

      expect(enConfig.locale, const Locale('en', 'US'));
      expect(esConfig.locale, const Locale('es', 'ES'));
      expect(frConfig.locale, const Locale('fr', 'FR'));
    });

    test('CalendarConfig range selection settings', () {
      const config = CalendarConfig(
        enableRangeSelection: true,
        allowSameDayRange: false,
      );

      expect(config.enableRangeSelection, true);
      expect(config.allowSameDayRange, false);
    });

    test('CalendarConfig with empty holidays', () {
      const config = CalendarConfig();

      expect(config.holidays, isEmpty);
      expect(config.holidayNames, isEmpty);
      expect(config.isHoliday(DateTime(2024)), false);
      expect(config.getHolidayName(DateTime(2024)), null);
    });

    test('CalendarConfig copyWith updates all fields', () {
      const config = CalendarConfig();
      final newHolidays = <DateTime>[DateTime(2024)];
      final newHolidayNames = <DateTime, String>{
        DateTime(2024): 'New Year',
      };

      final modified = config.copyWith(
        initialView: CalendarView.week,
        showWeekNumbers: true,
        weekStartDay: WeekStartDay.sunday,
        minDate: DateTime(2024),
        maxDate: DateTime(2024, 12, 31),
        enableRangeSelection: true,
        enableMultiDayEvents: false,
        hideWeekends: true,
        showHolidays: false,
        enableVerticalScroll: true,
        allowSameDayRange: false,
        enableSwipeNavigation: false,
        enableDragAndDrop: true,
        show24HourFormat: false,
        showEventTime: false,
        showEventLocation: true,
        showEventIcon: false,
        maxEventsPerDay: 5,
        compactMode: true,
        showEventDots: false,
        maxEventDotsPerDay: 5,
        enableLongPress: false,
        enableDoubleTap: true,
        animationDuration: const Duration(milliseconds: 500),
        locale: const Locale('en', 'US'),
        holidays: newHolidays,
        holidayNames: newHolidayNames,
      );

      expect(modified.initialView, CalendarView.week);
      expect(modified.showWeekNumbers, true);
      expect(modified.weekStartDay, WeekStartDay.sunday);
      expect(modified.minDate, DateTime(2024));
      expect(modified.maxDate, DateTime(2024, 12, 31));
      expect(modified.enableRangeSelection, true);
      expect(modified.enableMultiDayEvents, false);
      expect(modified.hideWeekends, true);
      expect(modified.showHolidays, false);
      expect(modified.enableVerticalScroll, true);
      expect(modified.allowSameDayRange, false);
      expect(modified.enableSwipeNavigation, false);
      expect(modified.enableDragAndDrop, true);
      expect(modified.show24HourFormat, false);
      expect(modified.showEventTime, false);
      expect(modified.showEventLocation, true);
      expect(modified.showEventIcon, false);
      expect(modified.maxEventsPerDay, 5);
      expect(modified.compactMode, true);
      expect(modified.showEventDots, false);
      expect(modified.maxEventDotsPerDay, 5);
      expect(modified.enableLongPress, false);
      expect(modified.enableDoubleTap, true);
      expect(modified.animationDuration, const Duration(milliseconds: 500));
      expect(modified.locale, const Locale('en', 'US'));
      expect(modified.holidays, newHolidays);
      expect(modified.holidayNames, newHolidayNames);
    });

    test('CalendarConfig minDate and maxDate can be null', () {
      const config = CalendarConfig();

      expect(config.minDate, null);
      expect(config.maxDate, null);
    });

    test('CalendarConfig with null locale', () {
      const config = CalendarConfig();

      expect(config.locale, null);
    });
  });
}
