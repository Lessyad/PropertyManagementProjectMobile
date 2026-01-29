/*
import '../../../home_module/home_imports.dart';
import 'package:animate_do/animate_do.dart';
import 'package:enmaa/core/components/svg_image_component.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/features/preview_property/presentation/controller/preview_property_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../configuration/managers/color_manager.dart';
import '../../../../configuration/managers/font_manager.dart';
import '../../../../configuration/managers/style_manager.dart';
import '../components/select_available_times.dart';
class PreviewPropertyScreen extends StatelessWidget {
  const PreviewPropertyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.all(context.scale(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'حدد تاريخ ووقت المعاينة',
                style: getBoldStyle(color: ColorManager.blackColor),
              ),
              SizedBox(height: context.scale(16)),
              _buildDateSection(context),
              SizedBox(height: context.scale(16)),
              SelectAvailableTimes(),
              SizedBox(height: context.scale(24)),

            ],
          ),
        ),
      ),
    );

  }

  Widget _buildDateSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'التاريخ',
          style: getBoldStyle(
            color: ColorManager.blackColor,
            fontSize: FontSize.s12,
          ),
        ),
        SizedBox(height: context.scale(10)),
        BlocBuilder<PreviewPropertyCubit, PreviewPropertyState>(
          builder: (context, state) {
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    context.read<PreviewPropertyCubit>().changePreviewDateVisibility();
                  },
                  child: Container(
                    height: context.scale(44),
                    decoration: BoxDecoration(
                      color: ColorManager.whiteColor,
                      borderRadius: BorderRadius.circular(context.scale(20)),
                      border: Border.all(
                        color: state.showPreviewDate ? ColorManager.primaryColor : ColorManager.greyShade,
                        width: 0.5,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.scale(16)),
                      child: Row(
                        children: [
                          SvgImageComponent(
                            iconPath: AppAssets.calendarIcon,
                            width: 16,
                            height: 16,
                          ),
                          SizedBox(width: context.scale(8)),
                          Expanded(
                            child: Text(
                              state.selectedDate != null
                                  ? '${state.selectedDate!.day}/${state.selectedDate!.month}/${state.selectedDate!.year}'
                                  : 'اختر التاريخ',
                              style: state.selectedDate == null
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
                            !state.showPreviewDate
                                ? Icons.arrow_drop_down_sharp
                                : Icons.arrow_drop_up_sharp,
                            color: ColorManager.grey2,
                            size: context.scale(24),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: Duration(seconds: 1),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(0, -0.1),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: state.showPreviewDate
                      ? FadeInDown(
                    duration: Duration(seconds: 1),
                    child: Container(
                      key: ValueKey<bool>(state.showPreviewDate),
                      margin: EdgeInsets.only(top: context.scale(8)),
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
                      clipBehavior: Clip.antiAlias,
                      child: SfCalendar(
                        view: CalendarView.month,
                        firstDayOfWeek: 7,
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
                        selectionDecoration: BoxDecoration(
                          color: ColorManager.primaryColor.withOpacity(0.3),
                          border: Border.all(
                            color: ColorManager.primaryColor,
                            width: 1,
                          ),
                          shape: BoxShape.circle,
                        ),
                        monthViewSettings: MonthViewSettings(
                          showTrailingAndLeadingDates: false,
                          dayFormat: 'EEE',
                          monthCellStyle: MonthCellStyle(
                            textStyle: getRegularStyle(
                              color: ColorManager.primaryColor,
                              fontSize: FontSize.s12,
                            ),
                            leadingDatesTextStyle: getRegularStyle(
                              color: ColorManager.primaryColor,
                              fontSize: FontSize.s12,
                            ),
                            trailingDatesTextStyle: getRegularStyle(
                              color: ColorManager.primaryColor,
                              fontSize: FontSize.s12,
                            ),
                            backgroundColor: ColorManager.whiteColor,
                          ),
                          navigationDirection: MonthNavigationDirection.horizontal,
                        ),
                        onSelectionChanged: (calendarSelectionDetails) {
                          context.read<PreviewPropertyCubit>().selectDate(
                            calendarSelectionDetails.date!,
                          );
                        },
                        minDate: DateTime.now(),
                      ),
                    ),
                  )
                      : SizedBox.shrink(),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

}
*/
