import 'package:enmaa/core/components/svg_image_component.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/features/my_profile/modules/user_appointments/presentation/controller/user_appointments_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../configuration/managers/color_manager.dart';
import '../../../../../../configuration/managers/font_manager.dart';
import '../../../../../../configuration/managers/style_manager.dart';
import '../../../../../../core/components/button_app_component.dart';
import '../../../../../../core/utils/enums.dart';
import '../../../../../home_module/home_imports.dart';

class DeleteAppointmentComponent extends StatelessWidget {
  const DeleteAppointmentComponent({super.key, required this.appointmentId});

  final String appointmentId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgImageComponent(
          width: 80,
          height: 80,
          iconPath: AppAssets.removeImage,
        ),
        SizedBox(
          height: context.scale(20),
        ),
        Text(
          'هل أنت متأكد من إلغاء موعد المعاينة؟',
          style: getBoldStyle(
            color: ColorManager.blackColor,
            fontSize: FontSize.s18,
          ),
        ),
        SizedBox(
          height: context.scale(4),
        ),
        Text(
          'يرجى ملاحظة أنه يمكن استرداد رسوم المعاينة فقط إذا تم الإلغاء قبل 24 ساعة من موعد المعاينة',
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: getSemiBoldStyle(
            color: ColorManager.grey2,
            fontSize: FontSize.s14,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocConsumer<UserAppointmentsCubit, UserAppointmentsState>(
                listener: (context, state) {
          if (state.cancelAppointmentState == RequestState.loaded) {
          Navigator.pop(context);
          }
          },
                builder: (context, state) {
                  return ButtonAppComponent(
                    width: 171,
                    height: 46,
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: ColorManager.grey3,
                      borderRadius: BorderRadius.circular(context.scale(24)),
                    ),
                    buttonContent: Center(
                      child: state.cancelAppointmentState == RequestState.loading
                          ? CircularProgressIndicator(
                        color: ColorManager.primaryColor,
                      )
                          : Text(
                        'إلغاء الموعد',
                        style: getMediumStyle(
                          color: ColorManager.blackColor,
                          fontSize: FontSize.s14,
                        ),
                      ),
                    ),
                    onTap: () {
                      if(state.cancelAppointmentState != RequestState.loading) {
                        context.read<UserAppointmentsCubit>().cancelAppointment(appointmentId);
                      }
                    },
                  );
                },
              ),
              ButtonAppComponent(
                width: 171,
                height: 46,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: ColorManager.primaryColor,
                  borderRadius: BorderRadius.circular(context.scale(24)),
                ),
                buttonContent: Center(
                  child: Text(
                    'الاحتفاظ بالموعد',
                    style: getBoldStyle(
                      color: ColorManager.whiteColor,
                      fontSize: FontSize.s14,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}