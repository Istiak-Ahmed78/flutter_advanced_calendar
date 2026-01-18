import 'package:flutter/material.dart';

/// Theme configuration for calendar appearance and styling.
///
/// Controls all visual aspects of the calendar including colors, sizes,
/// text styles, and spacing. Provides several pre-built themes and
/// full customization options.
///
/// Example:
/// ```dart
/// // Use a pre-built theme
/// final calendar = Calendar(
///   theme: CalendarTheme.dark(),
/// );
///
/// // Create a custom theme
/// final customTheme = CalendarTheme(
///   headerBackgroundColor: Colors.purple,
///   selectedDayBackgroundColor: Colors.purple,
///   todayTextColor: Colors.purple,
/// );
///
/// // Modify an existing theme
/// final modifiedTheme = CalendarTheme.light().copyWith(
///   headerBackgroundColor: Colors.green,
/// );
/// ```
class CalendarTheme {
  /// Creates a calendar theme with customizable appearance.
  ///
  /// All parameters are optional and have sensible defaults for a light theme.
  ///
  /// **Background Colors:**
  /// - [backgroundColor] - Main calendar background
  /// - [headerBackgroundColor] - Month/year header background
  /// - [weekdayBackgroundColor] - Weekday labels row background
  ///
  /// **Text Colors:**
  /// - [headerTextColor] - Month/year header text
  /// - [weekdayTextColor] - Weekday labels text
  /// - [dayTextColor] - Regular day numbers
  /// - [selectedDayTextColor] - Selected day text
  /// - [todayTextColor] - Today's date text
  /// - [outsideMonthTextColor] - Days from other months
  /// - [disabledTextColor] - Disabled/unavailable days
  ///
  /// **Day Colors:**
  /// - [todayBackgroundColor] - Today's date background
  /// - [selectedDayBackgroundColor] - Selected day background
  /// - [rangeStartBackgroundColor] - Range selection start
  /// - [rangeEndBackgroundColor] - Range selection end
  /// - [rangeMiddleBackgroundColor] - Days between range start/end
  /// - [weekendTextColor] - Weekend day text
  /// - [holidayTextColor] - Holiday text
  /// - [holidayBackgroundColor] - Holiday background
  ///
  /// **Border Colors:**
  /// - [borderColor] - General borders
  /// - [selectedBorderColor] - Selected day border
  /// - [todayBorderColor] - Today's date border
  ///
  /// **Event Colors:**
  /// - [eventIndicatorColor] - Event indicator dots
  /// - [eventBackgroundColor] - Event item background
  /// - [eventTextColor] - Event item text
  ///
  /// **Sizes:**
  /// - [dayCellHeight] - Height of each day cell
  /// - [dayCellWidth] - Width of each day cell
  /// - [headerHeight] - Height of month/year header
  /// - [weekdayHeight] - Height of weekday labels row
  /// - [borderWidth] - Width of borders
  /// - [borderRadius] - Corner radius for rounded elements
  /// - [eventIndicatorSize] - Size of event indicator dots
  /// - [eventIndicatorSpacing] - Space between event dots
  ///
  /// **Text Styles:**
  /// - [headerTextStyle] - Custom style for header text
  /// - [weekdayTextStyle] - Custom style for weekday labels
  /// - [dayTextStyle] - Custom style for day numbers
  /// - [eventTextStyle] - Custom style for event text
  ///
  /// **Spacing:**
  /// - [headerPadding] - Padding around header
  /// - [dayCellPadding] - Padding inside day cells
  /// - [eventPadding] - Padding around event items
  const CalendarTheme({
    this.backgroundColor = Colors.white,
    this.headerBackgroundColor = Colors.blue,
    this.weekdayBackgroundColor = const Color(0xFFF5F5F5),
    this.headerTextColor = Colors.white,
    this.weekdayTextColor = const Color(0xFF757575),
    this.dayTextColor = const Color(0xFF212121),
    this.selectedDayTextColor = Colors.white,
    this.todayTextColor = Colors.blue,
    this.outsideMonthTextColor = const Color(0xFFBDBDBD),
    this.disabledTextColor = const Color(0xFFE0E0E0),
    this.todayBackgroundColor = const Color(0xFFE3F2FD),
    this.selectedDayBackgroundColor = Colors.blue,
    this.rangeStartBackgroundColor = Colors.blue,
    this.rangeEndBackgroundColor = Colors.blue,
    this.rangeMiddleBackgroundColor = const Color(0xFFBBDEFB),
    this.weekendTextColor = const Color(0xFFD32F2F),
    this.holidayTextColor = const Color(0xFFD32F2F),
    this.holidayBackgroundColor = const Color(0xFFFFEBEE),
    this.borderColor = const Color(0xFFE0E0E0),
    this.selectedBorderColor = Colors.blue,
    this.todayBorderColor = Colors.blue,
    this.eventIndicatorColor = Colors.blue,
    this.eventBackgroundColor = const Color(0xFFE3F2FD),
    this.eventTextColor = const Color(0xFF1976D2),
    this.dayCellHeight = 56.0,
    this.dayCellWidth = 56.0,
    this.headerHeight = 56.0,
    this.weekdayHeight = 40.0,
    this.borderWidth = 1.0,
    this.borderRadius = 8.0,
    this.eventIndicatorSize = 6.0,
    this.eventIndicatorSpacing = 2.0,
    this.headerTextStyle,
    this.weekdayTextStyle,
    this.dayTextStyle,
    this.eventTextStyle,
    this.headerPadding =
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.dayCellPadding = const EdgeInsets.all(4),
    this.eventPadding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  });

  /// Creates a green-themed calendar (nature and calm aesthetic).
  ///
  /// Uses green tones throughout with lighter shades for backgrounds.
  ///
  /// Example:
  /// ```dart
  /// final calendar = Calendar(theme: CalendarTheme.green());
  /// ```
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

  /// Creates an orange-themed calendar (warm and vibrant aesthetic).
  ///
  /// Uses orange tones throughout with lighter shades for backgrounds.
  ///
  /// Example:
  /// ```dart
  /// final calendar = Calendar(theme: CalendarTheme.orange());
  /// ```
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

  /// Creates a light-themed calendar (default theme).
  ///
  /// Uses bright colors with blue accents on a white background.
  ///
  /// Example:
  /// ```dart
  /// final calendar = Calendar(theme: CalendarTheme.light());
  /// ```
  factory CalendarTheme.light() => const CalendarTheme();

  /// Creates a dark-themed calendar for low-light environments.
  ///
  /// Uses dark backgrounds with lighter text and blue accents.
  ///
  /// Example:
  /// ```dart
  /// final calendar = Calendar(theme: CalendarTheme.dark());
  /// ```
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

  /// Creates a colorful purple-themed calendar.
  ///
  /// Uses vibrant purple tones with lighter shades for backgrounds.
  ///
  /// Example:
  /// ```dart
  /// final calendar = Calendar(theme: CalendarTheme.colorful());
  /// ```
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

  /// Creates a minimal black-and-white themed calendar.
  ///
  /// Uses only black, white, and gray tones with sharp corners.
  ///
  /// Example:
  /// ```dart
  /// final calendar = Calendar(theme: CalendarTheme.minimal());
  /// ```
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
  /// Main background color of the calendar.
  final Color backgroundColor;

  /// Background color of the month/year header.
  final Color headerBackgroundColor;

  /// Background color of the weekday labels row.
  final Color weekdayBackgroundColor;

  // Text colors
  /// Text color in the month/year header.
  final Color headerTextColor;

  /// Text color for weekday labels (Mon, Tue, etc.).
  final Color weekdayTextColor;

  /// Text color for regular day numbers.
  final Color dayTextColor;

  /// Text color for the selected day.
  final Color selectedDayTextColor;

  /// Text color for today's date.
  final Color todayTextColor;

  /// Text color for days outside the current month.
  final Color outsideMonthTextColor;

  /// Text color for disabled/unavailable days.
  final Color disabledTextColor;

  // Day colors
  /// Background color for today's date.
  final Color todayBackgroundColor;

  /// Background color for the selected day.
  final Color selectedDayBackgroundColor;

  /// Background color for the start of a date range.
  final Color rangeStartBackgroundColor;

  /// Background color for the end of a date range.
  final Color rangeEndBackgroundColor;

  /// Background color for days in the middle of a date range.
  final Color rangeMiddleBackgroundColor;

  /// Text color for weekend days (Saturday and Sunday).
  final Color weekendTextColor;

  /// Text color for holidays.
  final Color holidayTextColor;

  /// Background color for holidays.
  final Color holidayBackgroundColor;

  // Border colors
  /// General border color for calendar elements.
  final Color borderColor;

  /// Border color for the selected day.
  final Color selectedBorderColor;

  /// Border color for today's date.
  final Color todayBorderColor;

  // Event colors
  /// Color for event indicator dots.
  final Color eventIndicatorColor;

  /// Background color for event items.
  final Color eventBackgroundColor;

  /// Text color for event items.
  final Color eventTextColor;

  // Sizes
  /// Height of each day cell in pixels.
  final double dayCellHeight;

  /// Width of each day cell in pixels.
  final double dayCellWidth;

  /// Height of the month/year header in pixels.
  final double headerHeight;

  /// Height of the weekday labels row in pixels.
  final double weekdayHeight;

  /// Width of borders in pixels.
  final double borderWidth;

  /// Corner radius for rounded elements in pixels.
  final double borderRadius;

  /// Size of event indicator dots in pixels.
  final double eventIndicatorSize;

  /// Spacing between event indicator dots in pixels.
  final double eventIndicatorSpacing;

  // Text styles
  /// Custom text style for the month/year header.
  final TextStyle? headerTextStyle;

  /// Custom text style for weekday labels.
  final TextStyle? weekdayTextStyle;

  /// Custom text style for day numbers.
  final TextStyle? dayTextStyle;

  /// Custom text style for event items.
  final TextStyle? eventTextStyle;

  // Spacing
  /// Padding around the month/year header.
  final EdgeInsets headerPadding;

  /// Padding inside each day cell.
  final EdgeInsets dayCellPadding;

  /// Padding around event items.
  final EdgeInsets eventPadding;

  // Backward compatibility getters
  /// Alias for [todayBackgroundColor] (for backward compatibility).
  Color get todayColor => todayBackgroundColor;

  /// Alias for [selectedDayBackgroundColor] (for backward compatibility).
  Color get selectedDayColor => selectedDayBackgroundColor;

  /// Alias for [disabledTextColor] (for backward compatibility).
  Color get disabledDayColor => disabledTextColor;

  /// Alias for [outsideMonthTextColor] (for backward compatibility).
  Color get outsideMonthColor => outsideMonthTextColor;

  /// Alias for [eventIndicatorColor] (for backward compatibility).
  Color get eventColor => eventIndicatorColor;

  /// Alias for [holidayBackgroundColor] (for backward compatibility).
  Color get holidayColor => holidayBackgroundColor;

  /// Alias for [weekendTextColor] (for backward compatibility).
  Color get weekendColor => weekendTextColor;

  /// Creates a copy of this theme with the given fields replaced.
  ///
  /// This is useful for creating variations of a theme without
  /// modifying the original.
  ///
  /// Example:
  /// ```dart
  /// final customTheme = CalendarTheme.dark().copyWith(
  ///   headerBackgroundColor: Colors.purple,
  ///   selectedDayBackgroundColor: Colors.purple,
  /// );
  /// ```
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
