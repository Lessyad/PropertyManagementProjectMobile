import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';

import '../../../../../../configuration/managers/color_manager.dart';
import '../../../../../../configuration/managers/font_manager.dart';
import '../../../../../../configuration/managers/style_manager.dart';
import '../../../../../../core/components/custom_date_picker.dart';
import '../../../../../../core/components/svg_image_component.dart';
import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/translation/locale_keys.dart';


class DateSelectionField extends StatefulWidget {
  final String labelText;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final String iconPath;
  final DateTime? maxDate;
  final DateTime? minDate;

  const DateSelectionField({
    super.key,
    required this.labelText,
    required this.selectedDate,
    required this.onDateSelected,
    required this.iconPath,
    this.maxDate,
    this.minDate,
  });

  @override
  State<DateSelectionField> createState() => _DateSelectionFieldState();
}

class _DateSelectionFieldState extends State<DateSelectionField> {

  void _showCustomCalendar() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.scale(12)),
          ),
          child: Container(
            padding: EdgeInsets.all(context.scale(16)),
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              color: ColorManager.whiteColor,
              borderRadius: BorderRadius.circular(context.scale(12)),
              boxShadow: [
                BoxShadow(
                  color: ColorManager.blackColor.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  LocaleKeys.selectDate.tr(),
                  style: getBoldStyle(
                    color: ColorManager.blackColor,
                    fontSize: FontSize.s16,
                  ),
                ),
                SizedBox(height: context.scale(8)),
                Expanded(
                  child: CustomDatePicker(
                    showPreviousDates: true,
                    selectedDate: widget.selectedDate,
                    maxDate: widget.maxDate,
                    onSelectionChanged: (calendarSelectionDetails) {
                      if (calendarSelectionDetails.date != null) {
                        widget.onDateSelected(calendarSelectionDetails.date!);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showNativeDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate ?? DateTime.now(),
      firstDate: widget.minDate ?? DateTime(1900, 1, 1),
      lastDate: widget.maxDate ?? DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorManager.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: ColorManager.blackColor,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      widget.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: getBoldStyle(
            color: ColorManager.blackColor,
            fontSize: FontSize.s16,
          ),
        ),
        SizedBox(height: context.scale(8)),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: _showCustomCalendar,
                child: Container(
                  height: context.scale(44),
                  decoration: BoxDecoration(
                    color: ColorManager.whiteColor,
                    borderRadius: BorderRadius.circular(context.scale(20)),
                    border: Border.all(
                      color: ColorManager.greyShade,
                      width: 0.5,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.scale(16)),
                    child: Row(
                      children: [
                        SvgImageComponent(
                          iconPath: widget.iconPath,
                          width: 16,
                          height: 16,
                        ),
                        SizedBox(width: context.scale(8)),
                        Expanded(
                          child: Text(
                            widget.selectedDate != null
                                ? DateFormat('MM/dd/yyyy').format(widget.selectedDate!)
                                : LocaleKeys.chooseDate.tr(),
                            style: widget.selectedDate == null
                                ? getRegularStyle(
                              color: ColorManager.grey2,
                              fontSize: FontSize.s12,
                            )
                                : getSemiBoldStyle(
                              color: ColorManager.primaryColor,
                              fontSize: FontSize.s12,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down_sharp,
                          color: ColorManager.grey2,
                          size: context.scale(24),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: context.scale(8)),
            InkWell(
              onTap: _showNativeDatePicker,
              child: Container(
                height: context.scale(44),
                width: context.scale(44),
                decoration: BoxDecoration(
                  color: ColorManager.primaryColor,
                  borderRadius: BorderRadius.circular(context.scale(20)),
                ),
                child: Icon(
                  Icons.calendar_today,
                  color: ColorManager.whiteColor,
                  size: context.scale(20),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}