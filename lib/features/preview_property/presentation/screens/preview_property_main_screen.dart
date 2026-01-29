import 'package:animate_do/animate_do.dart';
import 'package:enmaa/core/components/svg_image_component.dart';
import 'package:enmaa/core/components/warning_message_component.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/extensions/request_states_extension.dart';
import 'package:enmaa/features/preview_property/presentation/components/bottom_buttons.dart';
import 'package:enmaa/features/preview_property/presentation/controller/preview_property_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../configuration/managers/color_manager.dart';
import '../../../../configuration/managers/font_manager.dart';
import '../../../../configuration/managers/style_manager.dart';
import '../../../../core/components/app_bar_component.dart';
import '../../../../core/components/custom_date_picker.dart';
import '../../../../core/translation/locale_keys.dart';
import '../../../add_new_real_estate/presentation/components/numbered_text_header_component.dart';
import '../../../home_module/home_imports.dart';
import '../components/select_available_times.dart';
import 'confirm_preview_payment_screen.dart';

class PreviewPropertyScreen extends StatefulWidget {
  const PreviewPropertyScreen(
      {super.key, required this.propertyId, this.updateAppointment = false});

  final String propertyId;
  final bool updateAppointment;

  @override
  State<PreviewPropertyScreen> createState() => _PreviewPropertyScreenState();
}

class _PreviewPropertyScreenState extends State<PreviewPropertyScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    context
        .read<PreviewPropertyCubit>()
        .getAvailableHoursForSpecificProperty(widget.propertyId);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.greyShade,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBarComponent(
                appBarTextMessage: widget.updateAppointment
                    ? LocaleKeys.changeAppointmentDate.tr()
                    : LocaleKeys.propertyPreview.tr(),
                showNotificationIcon: false,
                showLocationIcon: false,
                showBackIcon: true,
                centerText: true,
              ),
              if (!widget.updateAppointment) _buildPageIndicator(),
              Expanded(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    _buildDateAndTimeSelectionPage(context),
                    if (!widget.updateAppointment)
                      ConfirmPreviewPaymentScreen(
                        propertyId: widget.propertyId,
                      ),
                  ],
                ),
              ),
              SizedBox(height: context.scale(80)), // Reserve space for buttons
            ],
          ),
          BottomButtons(
            propertyId: widget.propertyId,
            currentPage: _currentPage,
            pageController: _pageController,
            updateAppointment: widget.updateAppointment,
          )
        ],
      ),
    );
  }

  Widget _buildDateAndTimeSelectionPage(BuildContext context) {
    return BlocBuilder<PreviewPropertyCubit, PreviewPropertyState>(
      builder: (context, state) {
        if (state.getAvailableHoursState.isLoaded) {
          return SingleChildScrollView(
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.all(context.scale(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle(context),
                    SizedBox(height: context.scale(16)),
                    _buildDateSection(context),
                    SizedBox(height: context.scale(16)),
                    SelectAvailableTimes(
                      availableTimes: state.currentAvailableHours,
                    ),
                    SizedBox(height: context.scale(24)),
                    _buildWarningMessages(context),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  var animationTime = const Duration(milliseconds: 500);

  Widget _buildPageIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(2, (index) {
          bool isActive = index <= _currentPage;
          return Column(
            children: [
              Text(
                index == 0
                    ? LocaleKeys.setAppointmentDate.tr()
                    : LocaleKeys.completePayment.tr(),
                style: getBoldStyle(
                  color: isActive
                      ? ColorManager.primaryColor
                      : ColorManager.blackColor,
                  fontSize: FontSize.s11,
                ),
              ),
              SizedBox(height: context.scale(8)),
              AnimatedContainer(
                duration: animationTime,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                width: context.scale(173),
                height: context.scale(4),
                decoration: BoxDecoration(
                  color:
                  isActive ? ColorManager.primaryColor : Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return NumberedTextHeaderComponent(
      number: '1',
      text: LocaleKeys.selectPreviewDateTime.tr(),
    );
  }

  Widget _buildDateSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.date.tr(),
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
                    context
                        .read<PreviewPropertyCubit>()
                        .changePreviewDateVisibility();
                  },
                  child: Container(
                    height: context.scale(44),
                    decoration: BoxDecoration(
                      color: ColorManager.whiteColor,
                      borderRadius: BorderRadius.circular(context.scale(20)),
                      border: Border.all(
                        color: state.showPreviewDate
                            ? ColorManager.primaryColor
                            : ColorManager.greyShade,
                        width: 0.5,
                      ),
                    ),
                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: context.scale(16)),
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
                                  : LocaleKeys.chooseDate.tr(),
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
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
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
                        borderRadius:
                        BorderRadius.circular(context.scale(12)),
                        boxShadow: [
                          BoxShadow(
                            color:
                            ColorManager.blackColor.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: CustomDatePicker(
                        selectedDate: context
                            .watch<PreviewPropertyCubit>()
                            .state
                            .selectedDate,
                        onSelectionChanged: (calendarSelectionDetails) {
                          context.read<PreviewPropertyCubit>().selectDate(
                            calendarSelectionDetails.date!,
                          );
                        },
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

  Widget _buildWarningMessages(BuildContext context) {
    return Column(
      children: [
        WarningMessageComponent(
          text: LocaleKeys.advisorWarningMessage.tr(),
        ),
        SizedBox(height: context.scale(12)),
        WarningMessageComponent(
          text: LocaleKeys.transparencyWarningMessage.tr(),
        ),
      ],
    );
  }
}