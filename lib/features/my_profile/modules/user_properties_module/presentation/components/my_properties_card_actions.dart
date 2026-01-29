import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:enmaa/configuration/routers/app_routers.dart';
import 'package:enmaa/configuration/routers/route_names.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../configuration/managers/color_manager.dart';
import '../../../../../../configuration/managers/font_manager.dart';
import '../../../../../../configuration/managers/style_manager.dart';
import '../../../../../../core/components/custom_snack_bar.dart';
import '../../../../../../core/components/svg_image_component.dart';
import '../../../../../../core/constants/app_assets.dart';
import '../../../../../home_module/home_imports.dart';
import '../../../../../real_estates/domain/entities/base_property_entity.dart';
import '../../../../../../core/components/custom_bottom_sheet.dart';
import '../controller/user_properties_cubit.dart';
import 'delete_property_bottom_sheet_component.dart';
class MyPropertiesCardActions extends StatelessWidget {
  const MyPropertiesCardActions({super.key , required this.propertyItem});
  final PropertyEntity propertyItem;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: propertyItem.status == 'available',
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          customButton: const Icon(
            Icons.more_horiz_rounded,
            size: 30,
            color: Colors.black,
          ),
          items: [
            DropdownMenuItem<String>(
              value: 'edit',
              child: Row(
                children: [
                  SvgImageComponent(
                    width: 20,
                    height: 20,
                    iconPath: AppAssets.pencilIcon,
                    color: ColorManager.blackColor,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'تعديل',
                    style: getBoldStyle(
                        color: ColorManager.blackColor,
                        fontSize: FontSize.s14),
                  ),
                ],
              ),
            ),
            DropdownMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  SvgImageComponent(
                    width: 20,
                    height: 20,
                    iconPath: AppAssets.closeIcon,
                    color: ColorManager.redColor,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'مسح العقار',
                    style: getBoldStyle(
                        color: ColorManager.redColor,
                        fontSize: FontSize.s14),
                  ),
                ],
              ),
            ),
          ],
          onChanged: (String? value) {
            if (value == 'edit') {

              Navigator.pushNamed(
                  context, RoutersNames.addNewRealEstateScreen ,
                  arguments: propertyItem.id.toString());

            } else if (value == 'delete') {
              if (propertyItem.status != 'available') {
                CustomSnackBar.show(
                  message: 'لا يمكن مسح العقار لأنه متاح حالياً',
                );
                return;
              }
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
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider.value(
                        value:
                        context.read<UserPropertiesCubit>(),
                      ),
                    ],
                    child: CustomBottomSheet(
                      widget: DeletePropertyBottomSheetComponent(
                        currentProperty: propertyItem,
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
    ) ;
  }
}
