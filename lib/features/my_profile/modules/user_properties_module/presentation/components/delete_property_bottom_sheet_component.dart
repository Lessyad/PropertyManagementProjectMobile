import 'package:enmaa/core/components/custom_snack_bar.dart';
import 'package:enmaa/core/components/svg_image_component.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/services/convert_string_to_enum.dart';
import 'package:enmaa/features/real_estates/domain/entities/base_property_entity.dart';
import 'package:enmaa/features/real_estates/presentation/controller/real_estate_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../configuration/managers/color_manager.dart';
import '../../../../../../configuration/managers/font_manager.dart';
import '../../../../../../configuration/managers/style_manager.dart';
import '../../../../../../core/components/button_app_component.dart';
import '../../../../../../core/services/service_locator.dart';
import '../../../../../../core/utils/enums.dart';
import '../../../../../home_module/home_imports.dart';
import '../../../../../home_module/presentation/controller/home_bloc.dart';
import '../controller/user_properties_cubit.dart';

class DeletePropertyBottomSheetComponent extends StatelessWidget {
  const DeletePropertyBottomSheetComponent({
    super.key,
    required this.currentProperty,
  });

  final PropertyEntity currentProperty;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgImageComponent(
          width: 80,
          height: 80,
          iconPath: AppAssets.removeImage,
        ),
        SizedBox(height: context.scale(20)),
        Text(
          'هل أنت متأكد من مسح العقار؟',
          style: getBoldStyle(
            color: ColorManager.blackColor,
            fontSize: FontSize.s18,
          ),
        ),
        SizedBox(height: context.scale(4)),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocConsumer<UserPropertiesCubit, UserPropertiesState>(
                listener: (context, state) {
                  final isLoaded = state.loadedStates.values.any(
                          (state) => state == RequestState.loaded);
                  if (isLoaded &&
                      !state.loadedStates.values
                          .contains(RequestState.loading)) {

                    /// remove this property from home and real estate screens
                    final realEstateCubit =
                    ServiceLocator.getIt<RealEstateCubit>();
                    realEstateCubit
                        .removePropertyById(currentProperty.id.toString());
                    ServiceLocator.getIt<HomeBloc>().add(RemoveProperty(
                      propertyId: currentProperty.id.toString(),
                      propertyType: getPropertyType(
                          currentProperty.propertyType.toString()),
                    ));

                    Navigator.pop(context);
                  }
                },
                builder: (context, state) {
                  final isLoading = state.loadedStates.values
                      .any((state) => state == RequestState.loading);

                  return ButtonAppComponent(
                    width: 171,
                    height: 46,
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: ColorManager.grey3,
                      borderRadius: BorderRadius.circular(context.scale(24)),
                    ),
                    buttonContent: Center(
                      child: isLoading
                          ? CircularProgressIndicator(
                        color: ColorManager.primaryColor,
                      )
                          : Text(
                        'مسح العقار',
                        style: getMediumStyle(
                          color: ColorManager.blackColor,
                          fontSize: FontSize.s14,
                        ),
                      ),
                    ),
                    onTap: () {
                      context.read<UserPropertiesCubit>().deleteProperty(
                        propertyId: currentProperty.id.toString(),
                        propertyType: getPropertyType(
                            currentProperty.propertyType.toString()),
                      );
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
                    'الاحتفاظ',
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