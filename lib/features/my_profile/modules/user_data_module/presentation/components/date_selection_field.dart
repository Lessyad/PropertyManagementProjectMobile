import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../configuration/managers/color_manager.dart';
import '../../../../../../configuration/managers/font_manager.dart';
import '../../../../../../configuration/managers/style_manager.dart';
import '../../../../../../core/components/custom_date_picker.dart';
import '../../../../../../core/components/svg_image_component.dart';
import '../../../../../../core/constants/app_assets.dart';


class DateSelectionField extends StatelessWidget {
  final String labelText;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final String iconPath ;

  const DateSelectionField({
    super.key,
    required this.labelText,
    required this.selectedDate,
    required this.onDateSelected,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: getBoldStyle(
            color: ColorManager.blackColor,
            fontSize: FontSize.s16,
          ),
        ),
        SizedBox(height: context.scale(8)),
        InkWell(
          onTap: () {
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
                    child: CustomDatePicker(
                      showPreviousDates: true,
                      selectedDate: selectedDate,
                      onSelectionChanged: (calendarSelectionDetails) {
                        onDateSelected(calendarSelectionDetails.date!);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
            );
          },
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
                    iconPath: iconPath,
                    width: 16,
                    height: 16,
                  ),
                  SizedBox(width: context.scale(8)),
                  Expanded(
                    child: Text(
                      selectedDate != null
                          ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                          : 'اختر التاريخ',
                      style: selectedDate == null
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
      ],
    );
  }
}