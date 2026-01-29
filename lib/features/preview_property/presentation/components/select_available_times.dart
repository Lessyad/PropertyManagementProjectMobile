import 'package:animate_do/animate_do.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../configuration/managers/color_manager.dart';
import '../../../../configuration/managers/font_manager.dart';
import '../../../../configuration/managers/style_manager.dart';
import '../../../../core/components/svg_image_component.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/translation/locale_keys.dart';
import '../../../home_module/home_imports.dart';
import '../controller/preview_property_cubit.dart';import 'package:flutter/material.dart' as material; // For TextDirection


class SelectAvailableTimes extends StatelessWidget {
  const SelectAvailableTimes({super.key, required this.availableTimes});

  final List<String> availableTimes;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: context.locale.languageCode == 'ar' ? material.TextDirection.rtl : material.TextDirection.ltr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.time.tr(),
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s12,
            ),
          ),
          SizedBox(height: context.scale(8)),
          BlocBuilder<PreviewPropertyCubit, PreviewPropertyState>(
            builder: (context, state) {
              return Column(
                children: [
                  Container(
                    height: context.scale(44),
                    decoration: BoxDecoration(
                      color: ColorManager.whiteColor,
                      borderRadius: BorderRadius.circular(context.scale(20)),
                      border: Border.all(
                        color: ColorManager.primaryColor,
                        width: 0.5,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.scale(16)),
                      child: Row(
                        children: [
                          SvgImageComponent(
                            iconPath: AppAssets.clockIcon,
                            width: 16,
                            height: 16,
                          ),
                          SizedBox(width: context.scale(8)),
                          Expanded(
                            child: Text(
                              state.selectedTime != null
                                  ? state.selectedTime!
                                  : LocaleKeys.chooseTime.tr(),
                              style: state.selectedTime == null
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
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: context.scale(16),
                  ),
                  if (availableTimes.isEmpty && state.selectedDate != null)
                    Text(
                      LocaleKeys.noAvailableTimes.tr(),
                      style: getMediumStyle(
                        color: ColorManager.blackColor,
                        fontSize: FontSize.s14,
                      ),
                    ),
                  if (availableTimes.isNotEmpty)
                    SizedBox(
                      height: context.scale(142),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            GridView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 2.9,
                              ),
                              itemCount: availableTimes.length,
                              itemBuilder: (context, index) {
                                final time = availableTimes[index];
                                final isSelected = state.selectedTime == time;

                                return GestureDetector(
                                  onTap: () {
                                    context.read<PreviewPropertyCubit>().selectTime(time);
                                  },
                                  child: Container(
                                    width: context.scale(116),
                                    height: context.scale(40),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? ColorManager.primaryColor2
                                          : ColorManager.whiteColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        time,
                                        style: isSelected
                                            ? getBoldStyle(
                                          color: ColorManager.primaryColor,
                                          fontSize: FontSize.s14,
                                        )
                                            : getMediumStyle(
                                          color: ColorManager.blackColor,
                                          fontSize: FontSize.s14,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}