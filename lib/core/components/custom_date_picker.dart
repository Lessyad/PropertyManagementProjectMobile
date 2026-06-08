import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../configuration/managers/color_manager.dart';
import '../../configuration/managers/font_manager.dart';
import '../../configuration/managers/style_manager.dart';
import '../../features/home_module/home_imports.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({
    this.showPreviousDates = false,
    super.key,
    this.selectedDate,
    this.onSelectionChanged,
    this.maxDate,
    this.minDate,
  });

  final DateTime? selectedDate;
  final void Function(CalendarSelectionDetails)? onSelectionChanged;
  final bool showPreviousDates;
  final DateTime? maxDate;
  final DateTime? minDate;

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late final CalendarController _calendarController;
  late DateTime _displayDate;

  static const List<String> _monthNames = [
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
    'December',
  ];

  DateTime get _minDate =>
      widget.minDate ??
      (widget.showPreviousDates ? DateTime(1900, 1, 1) : DateTime.now());

  DateTime get _maxDate => widget.maxDate ?? DateTime(2100, 12, 31);

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _displayDate =
        _monthStart(_clampToRange(widget.selectedDate ?? DateTime.now()));
    _calendarController.displayDate = _displayDate;
  }

  @override
  void didUpdateWidget(covariant CustomDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate ||
        widget.minDate != oldWidget.minDate ||
        widget.maxDate != oldWidget.maxDate ||
        widget.showPreviousDates != oldWidget.showPreviousDates) {
      _displayDate =
          _monthStart(_clampToRange(widget.selectedDate ?? _displayDate));
      _calendarController.displayDate = _displayDate;
    }
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  DateTime _monthStart(DateTime date) => DateTime(date.year, date.month, 1);

  DateTime _clampToRange(DateTime date) {
    if (date.isBefore(_minDate)) return _minDate;
    if (date.isAfter(_maxDate)) return _maxDate;
    return date;
  }

  bool _isSameMonth(DateTime first, DateTime second) {
    return first.year == second.year && first.month == second.month;
  }

  bool get _canGoPrevious {
    final previousMonth =
        DateTime(_displayDate.year, _displayDate.month - 1, 1);
    return !previousMonth.isBefore(_monthStart(_minDate));
  }

  bool get _canGoNext {
    final nextMonth = DateTime(_displayDate.year, _displayDate.month + 1, 1);
    return !nextMonth.isAfter(_monthStart(_maxDate));
  }

  List<int> get _availableYears {
    return List<int>.generate(
      _maxDate.year - _minDate.year + 1,
      (index) => _minDate.year + index,
    );
  }

  List<int> get _availableMonths {
    final minMonth = _displayDate.year == _minDate.year ? _minDate.month : 1;
    final maxMonth = _displayDate.year == _maxDate.year ? _maxDate.month : 12;
    return List<int>.generate(
        maxMonth - minMonth + 1, (index) => minMonth + index);
  }

  void _setDisplayDate(DateTime date) {
    final clampedDate = _monthStart(_clampToRange(date));
    setState(() {
      _displayDate = clampedDate;
      _calendarController.displayDate = clampedDate;
    });
  }

  void _changeMonth(int month) {
    _setDisplayDate(DateTime(_displayDate.year, month, 1));
  }

  void _changeYear(int year) {
    final validMonths = _availableMonthsForYear(year);
    final month = validMonths.contains(_displayDate.month)
        ? _displayDate.month
        : validMonths.first;
    _setDisplayDate(DateTime(year, month, 1));
  }

  List<int> _availableMonthsForYear(int year) {
    final minMonth = year == _minDate.year ? _minDate.month : 1;
    final maxMonth = year == _maxDate.year ? _maxDate.month : 12;
    return List<int>.generate(
        maxMonth - minMonth + 1, (index) => minMonth + index);
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: _canGoPrevious
              ? () => _setDisplayDate(
                    DateTime(_displayDate.year, _displayDate.month - 1, 1),
                  )
              : null,
          icon: const Icon(Icons.chevron_left),
          color: ColorManager.primaryColor,
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<int>(
                value: _displayDate.month,
                underline: const SizedBox.shrink(),
                items: _availableMonths
                    .map(
                      (month) => DropdownMenuItem<int>(
                        value: month,
                        child: Text(_monthNames[month - 1]),
                      ),
                    )
                    .toList(),
                onChanged: (month) {
                  if (month != null) _changeMonth(month);
                },
              ),
              const SizedBox(width: 8),
              DropdownButton<int>(
                value: _displayDate.year,
                underline: const SizedBox.shrink(),
                menuMaxHeight: 260,
                items: _availableYears
                    .map(
                      (year) => DropdownMenuItem<int>(
                        value: year,
                        child: Text(year.toString()),
                      ),
                    )
                    .toList(),
                onChanged: (year) {
                  if (year != null) _changeYear(year);
                },
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: _canGoNext
              ? () => _setDisplayDate(
                    DateTime(_displayDate.year, _displayDate.month + 1, 1),
                  )
              : null,
          icon: const Icon(Icons.chevron_right),
          color: ColorManager.primaryColor,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: SfCalendar(
            controller: _calendarController,
            view: CalendarView.month,
            firstDayOfWeek: 6,
            showNavigationArrow: false,
            headerHeight: 0,
            backgroundColor: ColorManager.whiteColor,
            headerStyle: CalendarHeaderStyle(
              textStyle: getBoldStyle(
                color: ColorManager.primaryColor,
                fontSize: FontSize.s14,
              ),
              backgroundColor: ColorManager.whiteColor,
              textAlign: TextAlign.center,
            ),
            todayHighlightColor: ColorManager.primaryColor,
            monthViewSettings: MonthViewSettings(
              showTrailingAndLeadingDates: false,
              dayFormat: 'EEE',
              navigationDirection: MonthNavigationDirection.horizontal,
            ),
            cellBorderColor: Colors.transparent,
            onSelectionChanged: widget.onSelectionChanged,
            onViewChanged: (details) {
              if (details.visibleDates.isEmpty) return;
              final visibleMonth = details.visibleDates.firstWhere(
                (date) => date.day == 1,
                orElse: () =>
                    details.visibleDates[details.visibleDates.length ~/ 2],
              );
              final monthStart = _monthStart(visibleMonth);
              if (!_isSameMonth(monthStart, _displayDate)) {
                setState(() => _displayDate = monthStart);
              }
            },
            initialDisplayDate: _displayDate,
            minDate: _minDate,
            maxDate: widget.maxDate,
            selectionDecoration: BoxDecoration(
              color: Colors.transparent,
            ),
            monthCellBuilder: (BuildContext context, MonthCellDetails details) {
              final now = DateTime.now();
              final todayStart = DateTime(now.year, now.month, now.day);

              bool isSelected = widget.selectedDate != null &&
                  details.date.year == widget.selectedDate!.year &&
                  details.date.month == widget.selectedDate!.month &&
                  details.date.day == widget.selectedDate!.day;

              bool isToday = details.date.year == now.year &&
                  details.date.month == now.month &&
                  details.date.day == now.day;

              bool isPastDay = details.date.isBefore(todayStart) &&
                  !widget.showPreviousDates;

              bool isFutureDay = details.date.isAfter(_maxDate);

              return Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? ColorManager.primaryColor
                      : isToday
                          ? ColorManager.primaryColor2
                          : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  details.date.day.toString(),
                  style: isSelected || isToday
                      ? getBoldStyle(
                          color: isSelected
                              ? Colors.white
                              : ColorManager.primaryColor,
                          fontSize: FontSize.s14,
                        )
                      : getRegularStyle(
                          color: isSelected
                              ? Colors.white
                              : isToday
                                  ? ColorManager.primaryColor
                                  : isFutureDay
                                      ? Colors.grey
                                      : isPastDay
                                          ? Colors.grey
                                          : Colors.black,
                          fontSize: FontSize.s12,
                        ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
