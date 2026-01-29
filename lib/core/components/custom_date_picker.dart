import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../configuration/managers/color_manager.dart';
import '../../configuration/managers/font_manager.dart';
import '../../configuration/managers/style_manager.dart';
import '../../features/home_module/home_imports.dart';

class CustomDatePicker extends StatelessWidget {
  const CustomDatePicker({
    this.showPreviousDates = false,
    super.key,
    this.selectedDate,
    this.onSelectionChanged,
    this.maxDate,
  });

  final DateTime? selectedDate;
  final void Function(CalendarSelectionDetails)? onSelectionChanged;
  final bool showPreviousDates;
  final DateTime? maxDate;

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.month,
      firstDayOfWeek: 6,
      showNavigationArrow: true,
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
      onSelectionChanged: onSelectionChanged,
      initialDisplayDate: selectedDate ?? DateTime.now(),
      minDate: showPreviousDates ? DateTime(1900, 1, 1) : DateTime.now(),
      maxDate: maxDate,
      selectionDecoration: BoxDecoration(
        color: Colors.transparent,
      ),
      monthCellBuilder: (BuildContext context, MonthCellDetails details) {
        final today = DateTime.now();
        final effectiveMaxDate = maxDate ?? DateTime(2100, 12, 31); // Default far future date if maxDate is null

        bool isSelected = selectedDate != null &&
            details.date.year == selectedDate!.year &&
            details.date.month == selectedDate!.month &&
            details.date.day == selectedDate!.day;

        bool isToday = details.date.year == today.year &&
            details.date.month == today.month &&
            details.date.day == today.day;

        bool isPastDay = details.date.isBefore(today) && !showPreviousDates;

        bool isFutureDay = details.date.isAfter(effectiveMaxDate);

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
              color: isSelected ? Colors.white : ColorManager.primaryColor,
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
    );
  }
}