import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/core/components/svg_image_component.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/extensions/operation_type_property_extension.dart';
import 'package:enmaa/core/extensions/request_states_extension.dart';
import 'package:enmaa/features/add_new_real_estate/presentation/controller/add_new_real_estate_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/translation/locale_keys.dart';

import '../../../../configuration/managers/color_manager.dart';
import '../../../../configuration/managers/font_manager.dart';
import '../../../../core/components/app_text_field.dart';
import '../../../../core/utils/form_validator.dart';
import '../../../home_module/home_imports.dart';
import '../components/form_widget_component.dart';
import '../components/numbered_text_header_component.dart';
import '../../../../core/components/reusable_type_selector_component.dart';
import '../components/select_images_component.dart';

class AddNewRealEstatePriceScreen extends StatefulWidget {
  const AddNewRealEstatePriceScreen({super.key});

  @override
  _AddNewRealEstatePriceScreenState createState() => _AddNewRealEstatePriceScreenState();
}

class _AddNewRealEstatePriceScreenState extends State<AddNewRealEstatePriceScreen> {





  @override
  Widget build(BuildContext context) {
    var addNewRealEstateCubit = context.read<AddNewRealEstateCubit>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: addNewRealEstateCubit.priceForm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NumberedTextHeaderComponent(
              number: '2',
              text: LocaleKeys.priceAndDescription.tr(),
            ),
            SizedBox(height: context.scale(20)),

            // Address form
            FormWidgetComponent(
              label: LocaleKeys.address.tr(),
              content: AppTextField(
                controller: addNewRealEstateCubit.addressController,
                height: 40,
                hintText: LocaleKeys.enterBriefAddress.tr(),
                keyboardType: TextInputType.text,
                backgroundColor: Colors.white,
                borderRadius: 20,
                padding: EdgeInsets.zero,
                validator: (value) => FormValidator.validateRequired(value, fieldName: LocaleKeys.address.tr()),
              ),
            ),

            // Description form
            FormWidgetComponent(
              label: LocaleKeys.description.tr(),
              content: AppTextField(
                controller: addNewRealEstateCubit.descriptionController,
                height: 90,
                hintText: LocaleKeys.enterDetailedDescription.tr(),
                keyboardType: TextInputType.multiline,
                backgroundColor: Colors.white,
                borderRadius: 20,
                padding: EdgeInsets.zero,
                maxLines: 3,
                validator: (value) => FormValidator.validateRequired(value, fieldName: LocaleKeys.description.tr()),
              ),
            ),

            BlocBuilder<AddNewRealEstateCubit, AddNewRealEstateState>(
              builder: (context, state) {
                var currentPropertyOperationType = state.currentPropertyOperationType;

                if (currentPropertyOperationType.isForSale) {
                  return FormWidgetComponent(
                    label: LocaleKeys.price.tr(),
                    content: AppTextField(
                      controller: addNewRealEstateCubit.priceController,
                      height: 40,
                      hintText: LocaleKeys.enterPropertyPrice.tr(),
                      keyboardType: TextInputType.number,
                      backgroundColor: Colors.white,
                      borderRadius: 20,
                      padding: EdgeInsets.zero,
                      validator: (value) => FormValidator.validatePositiveNumber(value, fieldName: LocaleKeys.price.tr()),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormWidgetComponent(
                      label: LocaleKeys.monthlyRent.tr(),
                      content: AppTextField(
                        controller: addNewRealEstateCubit.rentController,
                        height: 40,
                        hintText: LocaleKeys.specifyMonthlyRent.tr(),
                        keyboardType: TextInputType.number,
                        backgroundColor: Colors.white,
                        borderRadius: 20,
                        padding: EdgeInsets.zero,
                        validator: (value) => FormValidator.validatePositiveNumber(value, fieldName: LocaleKeys.monthlyRent.tr()),
                      ),
                    ),
                    FormWidgetComponent(
                      label: LocaleKeys.rentalDurationInMonths.tr(),
                      content: AppTextField(
                        controller: addNewRealEstateCubit.rentDurationController,
                        height: 40,
                        hintText: LocaleKeys.specifyRentalDuration.tr(),
                        keyboardType: TextInputType.number,
                        backgroundColor: Colors.white,
                        borderRadius: 20,
                        padding: EdgeInsets.zero,
                        validator: (value) => FormValidator.validatePositiveNumber(value, fieldName: LocaleKeys.rentalDurationInMonths.tr()),
                      ),
                    ),
                    FormWidgetComponent(
                      label: LocaleKeys.renewable.tr(),
                      content: TypeSelectorComponent<String>(
                        selectorWidth: 171,
                        values: [LocaleKeys.yes.tr(), LocaleKeys.no.tr()],
                        currentType: state.availableForRenewal ? LocaleKeys.yes.tr() : LocaleKeys.no.tr(),
                        onTap: (type) => addNewRealEstateCubit.changeAvailabilityForRenewal(),
                        getLabel: (type) => type == LocaleKeys.yes.tr() ? LocaleKeys.yes.tr() : LocaleKeys.no.tr(),
                      ),
                    ),
                  ],
                );
              },
            ),

            FormWidgetComponent(
              label: LocaleKeys.propertyType.tr(),
              content: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgImageComponent(
                        iconPath: AppAssets.warningIcon,
                        width: 16,
                        height: 16,
                      ),
                      SizedBox(width: context.scale(8)),
                      Expanded(
                        child: Text(
                             LocaleKeys.firstImageWillBeMain.tr(),
                        maxLines: 2,
                          style: getMediumStyle(
                            color: ColorManager.grey,
                            fontSize: FontSize.s12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.scale(18)),
                  BlocBuilder<AddNewRealEstateCubit, AddNewRealEstateState>(
                    builder: (context, state) {
                      final cubit = context.read<AddNewRealEstateCubit>();
                      return SelectImagesComponent(
                        height: 108 ,
                        selectedImages: state.selectedImages,
                        isLoading: state.selectImagesState.isLoading,
                        validateImages: state.validateImages,
                       hintText: LocaleKeys.uploadClearPropertyImages.tr(),
                        onSelectImages: cubit.selectImages,
                        onRemoveImage: cubit.removeImage,
                        onValidateImages: cubit.validateImages,
                      );
                    },
                  ),
                ],
              ),
            ),


          ],
        ),
      ),
    );
  }
}
