import 'package:flutter/material.dart';
import '../core/controllers/calendar_controller.dart';
import '../core/models/enums.dart';
import '../themes/calendar_theme.dart';

/// Header widget for calendar navigation
class CalendarHeader extends StatelessWidget {
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
  final CalendarController controller;
  final CalendarTheme? theme;
  final VoidCallback? onPreviousTap;
  final VoidCallback? onNextTap;
  final VoidCallback? onTodayTap;
  final VoidCallback? onTitleTap;
  final bool showTodayButton;
  final bool showViewSwitcher;
  final String? customTitle;
  final bool enableMonthYearPicker;

  @override
  Widget build(BuildContext context) {
    final calendarTheme = theme ?? CalendarTheme.light();

    return Container(
      height: calendarTheme.headerHeight,
      padding: const EdgeInsets.symmetric(
          horizontal: 4, vertical: 8), // ✅ REDUCED PADDING
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
          // Previous button - COMPACT
          IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: calendarTheme.headerTextColor,
            ),
            onPressed: onPreviousTap ?? controller.navigatePrevious,
            tooltip: 'Previous',
            padding: EdgeInsets.zero, // ✅ REMOVED PADDING
            constraints: const BoxConstraints(
                minWidth: 40, minHeight: 40), // ✅ SMALLER SIZE
          ),

          // Title (clickable for month/year picker) - FLEXIBLE
          Expanded(
            child: InkWell(
              onTap: enableMonthYearPicker
                  ? () => _showMonthYearPicker(context, calendarTheme)
                  : onTitleTap,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      // ✅ WRAPPED IN FLEXIBLE
                      child: Text(
                        customTitle ?? _getTitle(),
                        style: calendarTheme.headerTextStyle ??
                            TextStyle(
                              fontSize: 16, // ✅ REDUCED FROM 18
                              fontWeight: FontWeight.bold,
                              color: calendarTheme.headerTextColor,
                            ),
                        overflow: TextOverflow.ellipsis, // ✅ PREVENT OVERFLOW
                        maxLines: 1, // ✅ SINGLE LINE
                      ),
                    ),
                    if (enableMonthYearPicker) ...[
                      const SizedBox(width: 2), // ✅ REDUCED FROM 4
                      Icon(
                        Icons.arrow_drop_down,
                        color: calendarTheme.headerTextColor,
                        size: 18, // ✅ REDUCED FROM 20
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // Next button - COMPACT
          IconButton(
            icon: Icon(
              Icons.chevron_right,
              color: calendarTheme.headerTextColor,
            ),
            onPressed: onNextTap ?? controller.navigateNext,
            tooltip: 'Next',
            padding: EdgeInsets.zero, // ✅ REMOVED PADDING
            constraints: const BoxConstraints(
                minWidth: 40, minHeight: 40), // ✅ SMALLER SIZE
          ),

          // Today button - COMPACT
          if (showTodayButton) ...[
            const SizedBox(width: 4), // ✅ REDUCED FROM 8
            TextButton(
              onPressed: onTodayTap ?? controller.jumpToToday,
              style: TextButton.styleFrom(
                foregroundColor: calendarTheme.headerTextColor,
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4), // ✅ REDUCED PADDING
                minimumSize: const Size(50, 32), // ✅ SMALLER SIZE
                tapTargetSize:
                    MaterialTapTargetSize.shrinkWrap, // ✅ COMPACT TAP TARGET
              ),
              child: const Text(
                'Today',
                style: TextStyle(fontSize: 13), // ✅ SMALLER FONT
              ),
            ),
          ],

          // View switcher - COMPACT
          if (showViewSwitcher) ...[
            const SizedBox(width: 4), // ✅ REDUCED FROM 8
            PopupMenuButton<CalendarView>(
              icon: Icon(
                Icons.view_module,
                color: calendarTheme.headerTextColor,
                size: 20, // ✅ SMALLER ICON
              ),
              tooltip: 'Change view',
              padding: EdgeInsets.zero, // ✅ REMOVED PADDING
              onSelected: controller.setView,
              itemBuilder: (context) => [
                _buildViewMenuItem(
                  CalendarView.month,
                  Icons.calendar_month,
                  'Month',
                  calendarTheme,
                ),
                _buildViewMenuItem(
                  CalendarView.week,
                  Icons.view_week,
                  'Week',
                  calendarTheme,
                ),
                _buildViewMenuItem(
                  CalendarView.day,
                  Icons.view_day,
                  'Day',
                  calendarTheme,
                ),
                _buildViewMenuItem(
                  CalendarView.year,
                  Icons.calendar_today,
                  'Year',
                  calendarTheme,
                ),
                _buildViewMenuItem(
                  CalendarView.agenda,
                  Icons.list,
                  'Agenda',
                  calendarTheme,
                ),
                _buildViewMenuItem(
                  CalendarView.timeline,
                  Icons.view_timeline,
                  'Timeline',
                  calendarTheme,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

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

  /// Issue #4: Show month and year picker dialog
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

/// Issue #4: Month and Year Picker Dialog
class _MonthYearPickerDialog extends StatefulWidget {
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
              // Title
              Text(
                'Select Month & Year',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: widget.theme.headerTextColor,
                ),
              ),
              const SizedBox(height: 20),

              // Year selector
              Row(
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
              ),

              const SizedBox(height: 16),

              // Month grid
              GridView.builder(
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
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? widget.theme.selectedDayTextColor
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Action buttons
              Row(
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
              ),
            ],
          ),
        ),
      );

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
