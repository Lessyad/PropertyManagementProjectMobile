import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/configuration/routers/route_names.dart';
import 'package:enmaa/core/components/svg_image_component.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/extensions/property_type_extension.dart';
import 'package:enmaa/core/translation/locale_keys.dart';
import 'package:flutter/material.dart';
 import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/components/custom_bottom_sheet.dart';
import '../../../../../../core/services/convert_string_to_enum.dart';
import '../../domain/entities/appointment_entity.dart';
import '../controller/user_appointments_cubit.dart';
import 'delete_appointment_component.dart';

class UserAppointmentCard extends StatelessWidget {
  final AppointmentEntity appointment;

  const UserAppointmentCard({
    super.key,
    required this.appointment,
  });


  String makeAppointmentTitle(String propertyType) {
    String type = getPropertyType(propertyType.toLowerCase()).toName;

    String area = appointment.propertyArea;
    String city = '';

    String title = "${LocaleKeys.preview.tr()} ${type} $area م² $city";

    return title;
  }



  @override
  Widget build(BuildContext context) {
    return Container(

      width: double.infinity,
      height: context.scale(122),
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  makeAppointmentTitle(appointment.propertyType),
                  style: getBoldStyle(color: ColorManager.blackColor , fontSize:FontSize.s16 ),
                ),
                if(appointment.orderStatus == 'pending')
                DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    customButton: const Icon(
                      Icons.more_horiz_rounded,
                      size: 24,
                      color: Colors.black,
                    ),
                    items: [
                      DropdownMenuItem<String>(
                        value: 'edit',
                        child: Row(
                          children:   [
                            SvgImageComponent(
                              width: 20,
                                height: 20,
                                iconPath: AppAssets.pencilIcon , color: ColorManager.blackColor,),
                            SizedBox(width: 8),
                            Text('تغيير الموعد' , style: getBoldStyle(color: ColorManager.blackColor , fontSize: FontSize.s14),),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children:   [
                            SvgImageComponent(
                              width: 20,
                              height: 20,
                              iconPath: AppAssets.closeIcon , color: ColorManager.redColor,),
                            SizedBox(width: 8),
                            Text('إلغاء المعاينة' , style: getBoldStyle(color: ColorManager.redColor , fontSize: FontSize.s14),),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (String? value) {
                      if (value == 'edit') {

                        context.read<UserAppointmentsCubit>().updateCurrentAppointmentId(appointment.id);

                        Navigator.pushNamed(context, RoutersNames.previewPropertyScreen , arguments: {
                          'id' : appointment.propertyId ,
                          'updateAppointment' : true ,
                        });

                      } else if (value == 'delete') {

                        showModalBottomSheet(
                          context: context,
                          backgroundColor: ColorManager.greyShade,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25),
                            ),
                          ),
                          builder: (__) {
                            return BlocProvider.value(
                              value: context.read<UserAppointmentsCubit>(),
                              child: CustomBottomSheet(
                                widget: DeleteAppointmentComponent(
                                  appointmentId: appointment.id,
                                ),
                                headerText: '',
                              ),
                            );
                            },
                        );
                      }
                    },
                    dropdownStyleData: DropdownStyleData(
                      width: context.scale(174),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      elevation: 8,
                      offset: Offset(context.scale(150), 0),
                    ),

                  ),
                ),
              ],
            ) , 
            
            Row(
              children: [
                SvgImageComponent(
                  width: 20,
                    height: 20,
                    iconPath: AppAssets.locationIcon),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  '${appointment.propertyCity} - ${appointment.propertyState} - ${appointment.propertyCountry}',
                  style: getRegularStyle(color: ColorManager.grey , fontSize:FontSize.s14 ),
                ),
              ],
            ),


            if(appointment.orderStatus == 'pending')
            Row(
              children: [
                SvgImageComponent(
                  width: 20,
                    height: 20,
                    iconPath: AppAssets.calendarIcon ,color: ColorManager.yellowColor,),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  appointment.date,
                  style: getBoldStyle(color: ColorManager.yellowColor  , fontSize:FontSize.s14 ),
                ),

                const SizedBox(
                  width: 20,
                ),

                SvgImageComponent(
                  width: 20,
                  height: 20,
                  iconPath: AppAssets.clockIcon ,color: ColorManager.yellowColor,),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  appointment.time,
                  style: getBoldStyle(color: ColorManager.yellowColor  , fontSize:FontSize.s14 ),
                ),
              ],
            ),

            if( appointment.orderStatus == 'accepted')
              Row(
                children: [
                  SvgImageComponent(
                    width: 20,
                    height: 20,
                    iconPath: AppAssets.completedIcon ,color: ColorManager.greenColor,),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    " تمت المعاينه بتاريخ ${appointment.date} ",
                    style: getBoldStyle(color: ColorManager.greenColor  , fontSize:FontSize.s14 ),
                  ),


                ],
              ),


            if( appointment.orderStatus == 'cancelled')
              Row(
                children: [
                  SvgImageComponent(
                    width: 20,
                    height: 20,
                    iconPath: AppAssets.cancelledIcon ,color: ColorManager.redColor,),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    "تم إلغاء المعاينه" ,
                    style: getBoldStyle(color: ColorManager.redColor  , fontSize:FontSize.s14 ),
                  ),
                  ])

          ],
        ),
      ),
    );
  }


}