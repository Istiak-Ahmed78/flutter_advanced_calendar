import 'package:flutter/material.dart';
import '../core/controllers/calendar_controller.dart';
import '../core/models/enums.dart';
import '../themes/calendar_theme.dart';

/// Navigation header for the calendar with view switching and date navigation.
///
/// The calendar header provides controls for navigating between dates,
/// switching calendar views, and jumping to today. It displays the current
/// date range based on the active view and supports custom styling.
///
/// Features:
/// - Previous/Next navigation buttons
/// - Dynamic title showing current date range
/// - Today button for quick navigation
/// - View switcher (Month, Week, Day, Year, Agenda, Timeline)
/// - Month/Year picker dialog
/// - Customizable appearance
/// - Responsive layout
///
/// Example:
/// ```dart
/// CalendarHeader(
///   controller: calendarController,
///   theme: CalendarTheme.light(),
///   showTodayButton: true,
///   showViewSwitcher: true,
///   enableMonthYearPicker: true,
///   onTitleTap: () {
///     print('Title tapped');
///   },
/// )
/// ```
class CalendarHeader extends StatelessWidget {
  /// Creates a calendar header.
  ///
  /// [controller] - The calendar controller managing state and navigation.
  /// [theme] - Optional theme configuration. Defaults to light theme.
  /// [onPreviousTap] - Optional callback for previous button. Defaults to controller navigation.
  /// [onNextTap] - Optional callback for next button. Defaults to controller navigation.
  /// [onTodayTap] - Optional callback for today button. Defaults to controller navigation.
  /// [onTitleTap] - Optional callback for title tap (when picker is disabled).
  /// [showTodayButton] - Whether to show the "Today" button. Defaults to true.
  /// [showViewSwitcher] - Whether to show the view switcher menu. Defaults to true.
  /// [customTitle] - Optional custom title text to override default.
  /// [enableMonthYearPicker] - Whether clicking title opens picker. Defaults to true.
  ///
  /// Example:
  /// ```dart
  /// CalendarHeader(
  ///   controller: myController,
  ///   theme: CalendarTheme.dark(),
  ///   showTodayButton: false,
  ///   customTitle: 'My Custom Calendar',
  ///   onPreviousTap: () {
  ///     // Custom previous logic
  ///   },
  /// )
  /// ```
  const CalendarHeader({
    super.key,
    required this.controller,
    this.theme,
    this.onPreviousTap,
    this.onNextTap,
    this.onTodayTap,
    this.onTitleTap,
    this.showTodayButton = true,
    this.showViewSwitcher = true,
    this.customTitle,
    this.enableMonthYearPicker = true,
  });

  /// The calendar controller managing state and navigation.
  final CalendarController controller;

  /// Theme configuration for visual styling.
  ///
  /// If not provided, defaults to [CalendarTheme.light()].
  final CalendarTheme? theme;

  /// Callback invoked when the previous button is tapped.
  ///
  /// If not provided, uses [CalendarController.navigatePrevious].
  final VoidCallback? onPreviousTap;

  /// Callback invoked when the next button is tapped.
  ///
  /// If not provided, uses [CalendarController.navigateNext].
  final VoidCallback? onNextTap;

  /// Callback invoked when the "Today" button is tapped.
  ///
  /// If not provided, uses [CalendarController.jumpToToday].
  final VoidCallback? onTodayTap;

  /// Callback invoked when the title is tapped.
  ///
  /// Only used when [enableMonthYearPicker] is false.
  final VoidCallback? onTitleTap;

  /// Whether to show the "Today" button.
  final bool showTodayButton;

  /// Whether to show the view switcher menu.
  final bool showViewSwitcher;

  /// Custom title text to display instead of the default date range.
  final String? customTitle;

  /// Whether clicking the title opens the month/year picker dialog.
  ///
  /// When true, tapping the title shows a picker dialog.
  /// When false, [onTitleTap] is called instead.
  final bool enableMonthYearPicker;

  @override
  Widget build(BuildContext context) {
    final calendarTheme = theme ?? CalendarTheme.light();

    return Container(
      height: calendarTheme.headerHeight,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        color: calendarTheme.headerBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildNavigationButton(
            icon: Icons.chevron_left,
            tooltip: 'Previous',
            onPressed: onPreviousTap ?? controller.navigatePrevious,
            theme: calendarTheme,
          ),
          _buildTitle(context, calendarTheme),
          _buildNavigationButton(
            icon: Icons.chevron_right,
            tooltip: 'Next',
            onPressed: onNextTap ?? controller.navigateNext,
            theme: calendarTheme,
          ),
          if (showTodayButton) _buildTodayButton(calendarTheme),
          if (showViewSwitcher) _buildViewSwitcher(calendarTheme),
        ],
      ),
    );
  }

  /// Builds a navigation button (previous/next).
  ///
  /// [icon] - The icon to display.
  /// [tooltip] - The tooltip text.
  /// [onPressed] - The callback when pressed.
  /// [theme] - The calendar theme.
  Widget _buildNavigationButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    required CalendarTheme theme,
  }) =>
      IconButton(
        icon: Icon(icon, color: theme.headerTextColor),
        onPressed: onPressed,
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      );

  /// Builds the title section showing the current date range.
  ///
  /// [context] - The build context.
  /// [theme] - The calendar theme.
  Widget _buildTitle(BuildContext context, CalendarTheme theme) => Expanded(
        child: InkWell(
          onTap: enableMonthYearPicker
              ? () => _showMonthYearPicker(context, theme)
              : onTitleTap,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    customTitle ?? _getTitle(),
                    style: theme.headerTextStyle ??
                        TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.headerTextColor,
                        ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                if (enableMonthYearPicker) ...[
                  const SizedBox(width: 2),
                  Icon(
                    Icons.arrow_drop_down,
                    color: theme.headerTextColor,
                    size: 18,
                  ),
                ],
              ],
            ),
          ),
        ),
      );

  /// Builds the "Today" button.
  ///
  /// [theme] - The calendar theme.
  Widget _buildTodayButton(CalendarTheme theme) => Padding(
        padding: const EdgeInsets.only(left: 4),
        child: TextButton(
          onPressed: onTodayTap ?? controller.jumpToToday,
          style: TextButton.styleFrom(
            foregroundColor: theme.headerTextColor,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: const Size(50, 32),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Today',
            style: TextStyle(fontSize: 13),
          ),
        ),
      );

  /// Builds the view switcher popup menu.
  ///
  /// [theme] - The calendar theme.
  Widget _buildViewSwitcher(CalendarTheme theme) => Padding(
        padding: const EdgeInsets.only(left: 4),
        child: PopupMenuButton<CalendarView>(
          icon: Icon(
            Icons.view_module,
            color: theme.headerTextColor,
            size: 20,
          ),
          tooltip: 'Change view',
          padding: EdgeInsets.zero,
          onSelected: controller.setView,
          itemBuilder: (context) => [
            _buildViewMenuItem(
              CalendarView.month,
              Icons.calendar_month,
              'Month',
              theme,
            ),
            _buildViewMenuItem(
              CalendarView.week,
              Icons.view_week,
              'Week',
              theme,
            ),
            _buildViewMenuItem(
              CalendarView.day,
              Icons.view_day,
              'Day',
              theme,
            ),
            _buildViewMenuItem(
              CalendarView.year,
              Icons.calendar_today,
              'Year',
              theme,
            ),
            _buildViewMenuItem(
              CalendarView.agenda,
              Icons.list,
              'Agenda',
              theme,
            ),
            _buildViewMenuItem(
              CalendarView.timeline,
              Icons.view_timeline,
              'Timeline',
              theme,
            ),
          ],
        ),
      );

  /// Builds a single view menu item.
  ///
  /// [view] - The calendar view this item represents.
  /// [icon] - The icon to display.
  /// [label] - The label text.
  /// [theme] - The calendar theme.
  PopupMenuItem<CalendarView> _buildViewMenuItem(
    CalendarView view,
    IconData icon,
    String label,
    CalendarTheme theme,
  ) {
    final isSelected = controller.currentView == view;
    return PopupMenuItem(
      value: view,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isSelected ? theme.headerBackgroundColor : Colors.grey,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  /// Shows the month and year picker dialog.
  ///
  /// [context] - The build context.
  /// [theme] - The calendar theme.
  Future<void> _showMonthYearPicker(
    BuildContext context,
    CalendarTheme theme,
  ) async {
    final result = await showDialog<Map<String, int>>(
      context: context,
      builder: (context) => _MonthYearPickerDialog(
        initialMonth: controller.focusedDay.month,
        initialYear: controller.focusedDay.year,
        theme: theme,
      ),
    );

    if (result != null) {
      controller.jumpToMonthYear(result['month']!, result['year']!);
    }
  }

  /// Gets the title text based on the current view.
  ///
  /// Returns different formats for different views:
  /// - Month: "January 2024"
  /// - Week: "1 - 7 Jan 2024"
  /// - Day: "15 Jan 2024"
  /// - Year: "2024"
  String _getTitle() {
    switch (controller.currentView) {
      case CalendarView.month:
        return controller.getFormattedMonthYear();
      case CalendarView.week:
        final start = controller.getDaysInWeek().first;
        final end = controller.getDaysInWeek().last;
        return '${start.day} - ${end.day} ${_getMonthName(start.month)} ${start.year}';
      case CalendarView.day:
        return '${controller.focusedDay.day} ${_getMonthName(controller.focusedDay.month)} ${controller.focusedDay.year}';
      case CalendarView.year:
        return '${controller.focusedDay.year}';
      default:
        return controller.getFormattedMonthYear();
    }
  }

  /// Gets the abbreviated month name for a month number.
  ///
  /// [month] - The month number (1-12).
  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}

/// Dialog for selecting month and year.
///
/// Displays a year selector with increment/decrement buttons and a
/// grid of months. Users can select any month and year combination.
class _MonthYearPickerDialog extends StatefulWidget {
  /// Creates a month/year picker dialog.
  ///
  /// [initialMonth] - The initially selected month (1-12).
  /// [initialYear] - The initially selected year.
  /// [theme] - The calendar theme for styling.
  const _MonthYearPickerDialog({
    required this.initialMonth,
    required this.initialYear,
    required this.theme,
  });

  final int initialMonth;
  final int initialYear;
  final CalendarTheme theme;

  @override
  State<_MonthYearPickerDialog> createState() => _MonthYearPickerDialogState();
}

class _MonthYearPickerDialogState extends State<_MonthYearPickerDialog> {
  late int selectedMonth;
  late int selectedYear;

  @override
  void initState() {
    super.initState();
    selectedMonth = widget.initialMonth;
    selectedYear = widget.initialYear;
  }

  @override
  Widget build(BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitle(),
              const SizedBox(height: 20),
              _buildYearSelector(),
              const SizedBox(height: 16),
              _buildMonthGrid(),
              const SizedBox(height: 20),
              _buildActionButtons(context),
            ],
          ),
        ),
      );

  /// Builds the dialog title.
  Widget _buildTitle() => Text(
        'Select Month & Year',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: widget.theme.headerTextColor,
        ),
      );

  /// Builds the year selector with increment/decrement buttons.
  Widget _buildYearSelector() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                selectedYear--;
              });
            },
          ),
          Text(
            '$selectedYear',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                selectedYear++;
              });
            },
          ),
        ],
      );

  /// Builds the month selection grid.
  Widget _buildMonthGrid() => GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          final month = index + 1;
          final isSelected = month == selectedMonth;

          return InkWell(
            onTap: () {
              setState(() {
                selectedMonth = month;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? widget.theme.selectedDayBackgroundColor
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  _getMonthShortName(month),
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? widget.theme.selectedDayTextColor
                        : Colors.black87,
                  ),
                ),
              ),
            ),
          );
        },
      );

  /// Builds the action buttons (Cancel/OK).
  ///
  /// [context] - The build context.
  Widget _buildActionButtons(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop({
                'month': selectedMonth,
                'year': selectedYear,
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.theme.headerBackgroundColor,
            ),
            child: const Text('OK'),
          ),
        ],
      );

  /// Gets the abbreviated month name for a month number.
  ///
  /// [month] - The month number (1-12).
  String _getMonthShortName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}
