import 'package:flutter/material.dart';

/// Theme configuration for calendar appearance
class CalendarTheme {
  const CalendarTheme({
    // Background colors
    this.backgroundColor = Colors.white,
    this.headerBackgroundColor = Colors.blue,
    this.weekdayBackgroundColor = const Color(0xFFF5F5F5),

    // Text colors
    this.headerTextColor = Colors.white,
    this.weekdayTextColor = const Color(0xFF757575),
    this.dayTextColor = const Color(0xFF212121),
    this.selectedDayTextColor = Colors.white,
    this.todayTextColor = Colors.blue,
    this.outsideMonthTextColor = const Color(0xFFBDBDBD),
    this.disabledTextColor = const Color(0xFFE0E0E0),

    // Day colors
    this.todayBackgroundColor = const Color(0xFFE3F2FD),
    this.selectedDayBackgroundColor = Colors.blue,
    this.rangeStartBackgroundColor = Colors.blue,
    this.rangeEndBackgroundColor = Colors.blue,
    this.rangeMiddleBackgroundColor = const Color(0xFFBBDEFB),
    this.weekendTextColor = const Color(0xFFD32F2F),
    this.holidayTextColor = const Color(0xFFD32F2F),
    this.holidayBackgroundColor = const Color(0xFFFFEBEE),

    // Border colors
    this.borderColor = const Color(0xFFE0E0E0),
    this.selectedBorderColor = Colors.blue,
    this.todayBorderColor = Colors.blue,

    // Event colors
    this.eventIndicatorColor = Colors.blue,
    this.eventBackgroundColor = const Color(0xFFE3F2FD),
    this.eventTextColor = const Color(0xFF1976D2),

    // Sizes
    this.dayCellHeight = 56.0,
    this.dayCellWidth = 56.0,
    this.headerHeight = 56.0,
    this.weekdayHeight = 40.0,
    this.borderWidth = 1.0,
    this.borderRadius = 8.0,
    this.eventIndicatorSize = 6.0,
    this.eventIndicatorSpacing = 2.0,

    // Text styles
    this.headerTextStyle,
    this.weekdayTextStyle,
    this.dayTextStyle,
    this.eventTextStyle,

    // Spacing
    this.headerPadding =
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.dayCellPadding = const EdgeInsets.all(4),
    this.eventPadding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  });

  /// Green theme (nature and calm)
  factory CalendarTheme.green() => const CalendarTheme(
        headerBackgroundColor: Color(0xFF2E7D32),
        selectedDayBackgroundColor: Color(0xFF2E7D32),
        rangeStartBackgroundColor: Color(0xFF2E7D32),
        rangeEndBackgroundColor: Color(0xFF2E7D32),
        rangeMiddleBackgroundColor: Color(0xFFA5D6A7),
        todayBackgroundColor: Color(0xFFE8F5E9),
        todayTextColor: Color(0xFF2E7D32),
        todayBorderColor: Color(0xFF2E7D32),
        eventIndicatorColor: Color(0xFF2E7D32),
      );

  /// Orange theme (warm and vibrant)
  factory CalendarTheme.orange() => const CalendarTheme(
        headerBackgroundColor: Color(0xFFFF6F00),
        selectedDayBackgroundColor: Color(0xFFFF6F00),
        rangeStartBackgroundColor: Color(0xFFFF6F00),
        rangeEndBackgroundColor: Color(0xFFFF6F00),
        rangeMiddleBackgroundColor: Color(0xFFFFCC80),
        todayBackgroundColor: Color(0xFFFFF3E0),
        todayTextColor: Color(0xFFFF6F00),
        todayBorderColor: Color(0xFFFF6F00),
        eventIndicatorColor: Color(0xFFFF6F00),
      );

  /// Light theme (default)
  factory CalendarTheme.light() => const CalendarTheme();

  /// Dark theme
  factory CalendarTheme.dark() => const CalendarTheme(
        backgroundColor: Color(0xFF121212),
        headerBackgroundColor: Color(0xFF1E1E1E),
        weekdayBackgroundColor: Color(0xFF1E1E1E),
        weekdayTextColor: Color(0xFFB0B0B0),
        dayTextColor: Colors.white,
        todayTextColor: Color(0xFF90CAF9),
        outsideMonthTextColor: Color(0xFF616161),
        disabledTextColor: Color(0xFF424242),
        todayBackgroundColor: Color(0xFF1E3A5F),
        selectedDayBackgroundColor: Color(0xFF1976D2),
        rangeStartBackgroundColor: Color(0xFF1976D2),
        rangeEndBackgroundColor: Color(0xFF1976D2),
        rangeMiddleBackgroundColor: Color(0xFF0D47A1),
        weekendTextColor: Color(0xFFEF5350),
        holidayTextColor: Color(0xFFEF5350),
        holidayBackgroundColor: Color(0xFF3E2723),
        borderColor: Color(0xFF424242),
        selectedBorderColor: Color(0xFF90CAF9),
        todayBorderColor: Color(0xFF90CAF9),
        eventIndicatorColor: Color(0xFF90CAF9),
        eventBackgroundColor: Color(0xFF1E3A5F),
        eventTextColor: Color(0xFF90CAF9),
      );

  /// Colorful theme
  factory CalendarTheme.colorful() => const CalendarTheme(
        headerBackgroundColor: Color(0xFF6A1B9A),
        selectedDayBackgroundColor: Color(0xFF6A1B9A),
        rangeStartBackgroundColor: Color(0xFF6A1B9A),
        rangeEndBackgroundColor: Color(0xFF6A1B9A),
        rangeMiddleBackgroundColor: Color(0xFFCE93D8),
        todayBackgroundColor: Color(0xFFF3E5F5),
        todayTextColor: Color(0xFF6A1B9A),
        eventIndicatorColor: Color(0xFF6A1B9A),
      );

  /// Minimal theme
  factory CalendarTheme.minimal() => const CalendarTheme(
        headerBackgroundColor: Colors.white,
        weekdayBackgroundColor: Colors.white,
        headerTextColor: Color(0xFF212121),
        borderColor: Color(0xFFEEEEEE),
        todayBackgroundColor: Colors.transparent,
        todayBorderColor: Color(0xFF212121),
        selectedDayBackgroundColor: Color(0xFF212121),
        borderRadius: 0,
      );
  // Background colors
  final Color backgroundColor;
  final Color headerBackgroundColor;
  final Color weekdayBackgroundColor;

  // Text colors
  final Color headerTextColor;
  final Color weekdayTextColor;
  final Color dayTextColor;
  final Color selectedDayTextColor;
  final Color todayTextColor;
  final Color outsideMonthTextColor;
  final Color disabledTextColor;

  // Day colors
  final Color todayBackgroundColor;
  final Color selectedDayBackgroundColor;
  final Color rangeStartBackgroundColor;
  final Color rangeEndBackgroundColor;
  final Color rangeMiddleBackgroundColor;
  final Color weekendTextColor;
  final Color holidayTextColor;
  final Color holidayBackgroundColor;

  // Border colors
  final Color borderColor;
  final Color selectedBorderColor;
  final Color todayBorderColor;

  // Event colors
  final Color eventIndicatorColor;
  final Color eventBackgroundColor;
  final Color eventTextColor;

  // Sizes
  final double dayCellHeight;
  final double dayCellWidth;
  final double headerHeight;
  final double weekdayHeight;
  final double borderWidth;
  final double borderRadius;
  final double eventIndicatorSize;
  final double eventIndicatorSpacing;

  // Text styles
  final TextStyle? headerTextStyle;
  final TextStyle? weekdayTextStyle;
  final TextStyle? dayTextStyle;
  final TextStyle? eventTextStyle;

  // Spacing
  final EdgeInsets headerPadding;
  final EdgeInsets dayCellPadding;
  final EdgeInsets eventPadding;

  // Backward compatibility getters
  /// Alias for todayBackgroundColor (for backward compatibility)
  Color get todayColor => todayBackgroundColor;

  /// Alias for selectedDayBackgroundColor (for backward compatibility)
  Color get selectedDayColor => selectedDayBackgroundColor;

  /// Alias for disabledTextColor (for backward compatibility)
  Color get disabledDayColor => disabledTextColor;

  /// Alias for outsideMonthTextColor (for backward compatibility)
  Color get outsideMonthColor => outsideMonthTextColor;

  /// Alias for eventIndicatorColor (for backward compatibility)
  Color get eventColor => eventIndicatorColor;

  /// Alias for holidayBackgroundColor (for backward compatibility)
  Color get holidayColor => holidayBackgroundColor;

  /// Alias for weekendTextColor (for backward compatibility)
  Color get weekendColor => weekendTextColor;

  CalendarTheme copyWith({
    Color? backgroundColor,
    Color? headerBackgroundColor,
    Color? weekdayBackgroundColor,
    Color? headerTextColor,
    Color? weekdayTextColor,
    Color? dayTextColor,
    Color? selectedDayTextColor,
    Color? todayTextColor,
    Color? outsideMonthTextColor,
    Color? disabledTextColor,
    Color? todayBackgroundColor,
    Color? selectedDayBackgroundColor,
    Color? rangeStartBackgroundColor,
    Color? rangeEndBackgroundColor,
    Color? rangeMiddleBackgroundColor,
    Color? weekendTextColor,
    Color? holidayTextColor,
    Color? holidayBackgroundColor,
    Color? borderColor,
    Color? selectedBorderColor,
    Color? todayBorderColor,
    Color? eventIndicatorColor,
    Color? eventBackgroundColor,
    Color? eventTextColor,
    double? dayCellHeight,
    double? dayCellWidth,
    double? headerHeight,
    double? weekdayHeight,
    double? borderWidth,
    double? borderRadius,
    double? eventIndicatorSize,
    double? eventIndicatorSpacing,
    TextStyle? headerTextStyle,
    TextStyle? weekdayTextStyle,
    TextStyle? dayTextStyle,
    TextStyle? eventTextStyle,
    EdgeInsets? headerPadding,
    EdgeInsets? dayCellPadding,
    EdgeInsets? eventPadding,
  }) =>
      CalendarTheme(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        headerBackgroundColor:
            headerBackgroundColor ?? this.headerBackgroundColor,
        weekdayBackgroundColor:
            weekdayBackgroundColor ?? this.weekdayBackgroundColor,
        headerTextColor: headerTextColor ?? this.headerTextColor,
        weekdayTextColor: weekdayTextColor ?? this.weekdayTextColor,
        dayTextColor: dayTextColor ?? this.dayTextColor,
        selectedDayTextColor: selectedDayTextColor ?? this.selectedDayTextColor,
        todayTextColor: todayTextColor ?? this.todayTextColor,
        outsideMonthTextColor:
            outsideMonthTextColor ?? this.outsideMonthTextColor,
        disabledTextColor: disabledTextColor ?? this.disabledTextColor,
        todayBackgroundColor: todayBackgroundColor ?? this.todayBackgroundColor,
        selectedDayBackgroundColor:
            selectedDayBackgroundColor ?? this.selectedDayBackgroundColor,
        rangeStartBackgroundColor:
            rangeStartBackgroundColor ?? this.rangeStartBackgroundColor,
        rangeEndBackgroundColor:
            rangeEndBackgroundColor ?? this.rangeEndBackgroundColor,
        rangeMiddleBackgroundColor:
            rangeMiddleBackgroundColor ?? this.rangeMiddleBackgroundColor,
        weekendTextColor: weekendTextColor ?? this.weekendTextColor,
        holidayTextColor: holidayTextColor ?? this.holidayTextColor,
        holidayBackgroundColor:
            holidayBackgroundColor ?? this.holidayBackgroundColor,
        borderColor: borderColor ?? this.borderColor,
        selectedBorderColor: selectedBorderColor ?? this.selectedBorderColor,
        todayBorderColor: todayBorderColor ?? this.todayBorderColor,
        eventIndicatorColor: eventIndicatorColor ?? this.eventIndicatorColor,
        eventBackgroundColor: eventBackgroundColor ?? this.eventBackgroundColor,
        eventTextColor: eventTextColor ?? this.eventTextColor,
        dayCellHeight: dayCellHeight ?? this.dayCellHeight,
        dayCellWidth: dayCellWidth ?? this.dayCellWidth,
        headerHeight: headerHeight ?? this.headerHeight,
        weekdayHeight: weekdayHeight ?? this.weekdayHeight,
        borderWidth: borderWidth ?? this.borderWidth,
        borderRadius: borderRadius ?? this.borderRadius,
        eventIndicatorSize: eventIndicatorSize ?? this.eventIndicatorSize,
        eventIndicatorSpacing:
            eventIndicatorSpacing ?? this.eventIndicatorSpacing,
        headerTextStyle: headerTextStyle ?? this.headerTextStyle,
        weekdayTextStyle: weekdayTextStyle ?? this.weekdayTextStyle,
        dayTextStyle: dayTextStyle ?? this.dayTextStyle,
        eventTextStyle: eventTextStyle ?? this.eventTextStyle,
        headerPadding: headerPadding ?? this.headerPadding,
        dayCellPadding: dayCellPadding ?? this.dayCellPadding,
        eventPadding: eventPadding ?? this.eventPadding,
      );
}
