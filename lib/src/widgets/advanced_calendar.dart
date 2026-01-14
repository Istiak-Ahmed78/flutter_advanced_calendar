import 'package:flutter/material.dart';

import '../core/controllers/calendar_controller.dart';
import '../core/models/calendar_config.dart';
import '../core/models/calendar_event.dart';
import '../core/models/enums.dart';
import '../themes/calendar_theme.dart';
import '../views/agenda_view.dart';
import '../views/day_view.dart';
import '../views/month_view.dart';
import '../views/timeline_view.dart';
import '../views/week_view.dart';
import '../views/year_view.dart';
import 'calendar_header.dart';

/// Main calendar widget with all views
class AdvancedCalendar extends StatefulWidget {
  const AdvancedCalendar({
    super.key,
    this.controller,
    this.config,
    this.theme,
    this.onDaySelected,
    this.onRangeSelected,
    this.onDayLongPressed,
    this.onEventTap,
    this.onTimeSlotTap,
    this.showHeader = true,
    this.timelineColumns,
  });

  final CalendarController? controller;
  final CalendarConfig? config;
  final CalendarTheme? theme;
  final void Function(DateTime)? onDaySelected;
  final void Function(DateTime, DateTime)? onRangeSelected;
  final void Function(DateTime)? onDayLongPressed;
  final void Function(CalendarEvent)? onEventTap;
  final void Function(DateTime, String)? onTimeSlotTap;
  final bool showHeader;
  final List<String>? timelineColumns;

  @override
  State<AdvancedCalendar> createState() => _AdvancedCalendarState();
}

class _AdvancedCalendarState extends State<AdvancedCalendar> {
  late CalendarController _controller;
  late CalendarConfig _config;
  late CalendarTheme _theme;
  bool _isInternalController = false;

  // ✅ PageView controller (only for horizontal mode)
  PageController? _pageController;
  final int _initialPage = 12000;
  bool _isPageChanging = false;

  // ✅ NEW: Scroll controller for vertical mode
  ScrollController? _verticalScrollController;
  DateTime _currentVisibleMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = CalendarController(
        initialView: widget.config?.initialView ?? CalendarView.month,
        weekStartDay: widget.config?.weekStartDay.value ?? DateTime.monday,
      );
      _isInternalController = true;
    } else {
      _controller = widget.controller!;
    }
    _config = widget.config ?? const CalendarConfig();
    _theme = widget.theme ?? CalendarTheme.light();

    _controller.setHideWeekends(_config.hideWeekends);
    _currentVisibleMonth = _controller.focusedDay;

    // ✅ Initialize appropriate controller based on mode
    _initializeScrollControllers();
  }

  void _initializeScrollControllers() {
    if (_config.enableVerticalScroll) {
      // ✅ Vertical mode: Use ScrollController with listener
      _verticalScrollController = ScrollController();
      _verticalScrollController!.addListener(_onVerticalScroll);
    } else {
      // ✅ Horizontal mode: Use PageController
      _pageController = PageController(initialPage: _initialPage);
      _controller.addListener(_onControllerChanged);
    }
  }

  void _disposeScrollControllers() {
    if (_pageController != null) {
      _controller.removeListener(_onControllerChanged);
      _pageController!.dispose();
      _pageController = null;
    }
    if (_verticalScrollController != null) {
      _verticalScrollController!.removeListener(_onVerticalScroll);
      _verticalScrollController!.dispose();
      _verticalScrollController = null;
    }
  }

  // ✅ NEW: Listen to vertical scroll and update visible month
  void _onVerticalScroll() {
    if (_verticalScrollController == null ||
        !_verticalScrollController!.hasClients) {
      return;
    }

    // Calculate which month is currently visible based on scroll position
    final scrollOffset = _verticalScrollController!.offset;
    const approximateMonthHeight = 400.0; // Approximate height per month item
    final monthIndex = (scrollOffset / approximateMonthHeight).round();

    final now = DateTime.now();
    final newVisibleMonth = DateTime(now.year, now.month + monthIndex - 18);

    if (!_isSameMonth(_currentVisibleMonth, newVisibleMonth)) {
      setState(() {
        _currentVisibleMonth = newVisibleMonth;
      });
    }
  }

  bool _isSameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  @override
  void dispose() {
    _disposeScrollControllers();
    if (_isInternalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(AdvancedCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update theme
    if (widget.theme != oldWidget.theme && widget.theme != null) {
      setState(() {
        _theme = widget.theme!;
      });
    }

    // ✅ Update config and reinitialize controllers if scroll mode changed
    if (widget.config != oldWidget.config && widget.config != null) {
      final oldVerticalScroll = _config.enableVerticalScroll;
      _config = widget.config!;

      // If vertical scroll setting changed, reinitialize controllers
      if (oldVerticalScroll != _config.enableVerticalScroll) {
        _disposeScrollControllers();
        _initializeScrollControllers();
      }

      setState(() {});
    }

    // Update controller
    if (widget.controller != oldWidget.controller &&
        widget.controller != null) {
      if (_isInternalController) {
        _controller.dispose();
        _isInternalController = false;
      }
      _disposeScrollControllers();
      _controller = widget.controller!;
      _initializeScrollControllers();
    }
  }

  void _onControllerChanged() {
    if (_isPageChanging ||
        _config.enableVerticalScroll ||
        _pageController == null) {
      return;
    }

    if (_controller.currentView == CalendarView.month) {
      final targetPage = _getPageForDate(_controller.focusedDay);
      if (_pageController!.hasClients &&
          _pageController!.page?.round() != targetPage) {
        _pageController!.animateToPage(
          targetPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  int _getPageForDate(DateTime date) {
    final now = DateTime.now();
    final monthOffset = (date.year - now.year) * 12 + (date.month - now.month);
    return _initialPage + monthOffset;
  }

  DateTime _getDateForPage(int page) {
    final offset = page - _initialPage;
    final now = DateTime.now();
    return DateTime(now.year, now.month + offset);
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Container(
          color: _theme.backgroundColor,
          child: Column(
            children: [
              // ✅ Show header differently based on mode
              if (widget.showHeader) _buildHeader(),
              Expanded(
                child: _buildCurrentView(),
              ),
            ],
          ),
        ),
      );

  // ✅ NEW: Build header based on scroll mode
  Widget _buildHeader() {
    if (_config.enableVerticalScroll &&
        _controller.currentView == CalendarView.month) {
      // In vertical mode, show simplified header with current visible month
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _theme.headerBackgroundColor,
          border: Border(
            bottom: BorderSide(color: _theme.borderColor),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatMonthYear(_currentVisibleMonth),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _theme.headerTextColor,
              ),
            ),
            // View switcher
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.today, color: _theme.headerTextColor),
                  onPressed: () {
                    final now = DateTime.now();
                    setState(() {
                      _currentVisibleMonth = now;
                    });
                    // Scroll to current month
                    if (_verticalScrollController != null &&
                        _verticalScrollController!.hasClients) {
                      _verticalScrollController!.animateTo(
                        18 * 400.0, // Scroll to current month (index 18)
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  tooltip: 'Today',
                ),
                PopupMenuButton<CalendarView>(
                  icon: Icon(Icons.view_module, color: _theme.headerTextColor),
                  onSelected: (view) {
                    _controller.setView(view);
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                        value: CalendarView.month, child: Text('Month')),
                    const PopupMenuItem(
                        value: CalendarView.week, child: Text('Week')),
                    const PopupMenuItem(
                        value: CalendarView.day, child: Text('Day')),
                    const PopupMenuItem(
                        value: CalendarView.year, child: Text('Year')),
                    const PopupMenuItem(
                        value: CalendarView.agenda, child: Text('Agenda')),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }

    // Default header for horizontal mode
    return CalendarHeader(
      controller: _controller,
      theme: _theme,
    );
  }

  Widget _buildCurrentView() {
    // ✅ For month view: Check scroll mode
    if (_controller.currentView == CalendarView.month) {
      if (_config.enableVerticalScroll) {
        return _buildVerticalMonthScroll(); // Continuous scroll
      } else {
        return _buildMonthPageView(); // Page-by-page swipe
      }
    }

    // Enable swipe navigation for other views if configured
    if (_config.enableSwipeNavigation) {
      return GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            _controller.navigatePrevious();
          } else if (details.primaryVelocity! < 0) {
            _controller.navigateNext();
          }
        },
        child: _getCurrentViewWidget(),
      );
    }

    return _getCurrentViewWidget();
  }

  // ✅ OPTIMIZED: Lazy loading with ListView.builder (no freeze!)
  Widget _buildVerticalMonthScroll() {
    final now = DateTime.now();
    const totalMonths = 36; // 18 past + current + 17 future
    const currentMonthIndex = 18;

    return ListView.builder(
      controller: _verticalScrollController,
      itemCount: totalMonths,
      // ✅ KEY: Only build visible items (no freeze!)
      itemBuilder: (context, index) {
        final monthOffset = index - currentMonthIndex;
        final displayDate = DateTime(now.year, now.month + monthOffset);

        return Column(
          children: [
            // Inline month header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: _theme.headerBackgroundColor.withValues(alpha: 0.5),
              ),
              child: Text(
                _formatMonthYear(displayDate),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _theme.headerTextColor,
                ),
              ),
            ),
            // Month grid
            MonthView(
              controller: _controller,
              config: _config,
              theme: _theme,
              onDaySelected: _handleDaySelected,
              onDayLongPressed: widget.onDayLongPressed,
              displayDate: displayDate,
            ),
            const SizedBox(height: 8),
            // Divider
            Divider(
              color: _theme.borderColor.withValues(alpha: 0.3),
              thickness: 1,
              height: 1,
            ),
          ],
        );
      },
    );
  }

  String _formatMonthYear(DateTime date) {
    const months = [
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
    return '${months[date.month - 1]} ${date.year}';
  }

  // ✅ Horizontal scroll mode: PageView with swipe
  Widget _buildMonthPageView() {
    if (_pageController == null) {
      return _buildMonthViewForDate(_controller.focusedDay);
    }

    return PageView.builder(
      controller: _pageController,
      onPageChanged: (page) {
        _isPageChanging = true;
        final newDate = _getDateForPage(page);
        _controller.jumpToDate(newDate);
        _isPageChanging = false;
      },
      itemBuilder: (context, index) {
        final displayDate = _getDateForPage(index);
        return _buildMonthViewForDate(displayDate);
      },
    );
  }

  Widget _buildMonthViewForDate(DateTime date) => MonthView(
        controller: _controller,
        config: _config,
        theme: _theme,
        onDaySelected: _handleDaySelected,
        onDayLongPressed: widget.onDayLongPressed,
        displayDate: date,
      );

  Widget _getCurrentViewWidget() {
    switch (_controller.currentView) {
      case CalendarView.month:
        return MonthView(
          controller: _controller,
          config: _config,
          theme: _theme,
          onDaySelected: _handleDaySelected,
          onDayLongPressed: widget.onDayLongPressed,
        );

      case CalendarView.week:
        return WeekView(
          controller: _controller,
          config: _config,
          theme: _theme,
          onDaySelected: _handleDaySelected,
          onEventTap: widget.onEventTap,
        );

      case CalendarView.day:
        return DayView(
          controller: _controller,
          config: _config,
          theme: _theme,
          onEventTap: widget.onEventTap,
          onTimeSlotTap: (timeSlot) {
            if (widget.onTimeSlotTap != null) {
              widget.onTimeSlotTap!(timeSlot, '');
            }
          },
        );

      case CalendarView.year:
        return YearView(
          controller: _controller,
          config: _config,
          theme: _theme,
          onMonthTap: (date) {
            _controller
              ..jumpToDate(date)
              ..setView(CalendarView.month);
          },
        );

      case CalendarView.agenda:
        return AgendaView(
          controller: _controller,
          config: _config,
          theme: _theme,
          onEventTap: widget.onEventTap,
        );

      case CalendarView.timeline:
        return TimelineView(
          controller: _controller,
          config: _config,
          theme: _theme,
          onEventTap: widget.onEventTap,
          onTimeSlotTap: widget.onTimeSlotTap,
          columns: widget.timelineColumns ??
              const ['Room #1', 'Room #2', 'Room #3', 'Room #4'],
        );
    }
  }

  void _handleDaySelected(DateTime day) {
    widget.onDaySelected?.call(day);

    if (_config.enableRangeSelection && _controller.hasRangeSelection) {
      widget.onRangeSelected?.call(
        _controller.rangeStart!,
        _controller.rangeEnd!,
      );
    }
  }
}
