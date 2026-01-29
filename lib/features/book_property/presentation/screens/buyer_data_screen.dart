import 'package:country_code_picker/country_code_picker.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/extensions/buyer_type_extension.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/extensions/request_states_extension.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/translation/locale_keys.dart';
import '../../../../configuration/managers/color_manager.dart';
import '../../../../configuration/managers/font_manager.dart';
import '../../../../configuration/managers/style_manager.dart';
import '../../../../configuration/managers/value_manager.dart';
import '../../../../core/components/app_text_field.dart';
import '../../../../core/components/country_code_picker.dart';
import '../../../../core/components/custom_date_picker.dart';
import '../../../../core/components/reusable_type_selector_component.dart';
import '../../../../core/components/svg_image_component.dart';
import '../../../../core/utils/form_validator.dart';
import '../../../add_new_real_estate/presentation/components/numbered_text_header_component.dart';
import '../../../add_new_real_estate/presentation/components/select_images_component.dart';
import '../../../home_module/home_imports.dart';
import 'package:flutter/material.dart' as material;
import '../controller/book_property_cubit.dart';

class BuyerDataScreen extends StatefulWidget {
  const BuyerDataScreen({super.key});

  @override
  State<BuyerDataScreen> createState() => _BuyerDataScreenState();
}

class _BuyerDataScreenState extends State<BuyerDataScreen> {
  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.phoneNumberRequired.tr();
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.nameRequired.tr();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppPadding.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NumberedTextHeaderComponent(
            number: '٢',
            text: LocaleKeys.buyerData.tr(),
          ),
          SizedBox(height: context.scale(20)),
          BlocBuilder<BookPropertyCubit, BookPropertyState>(
            builder: (context, state) {
              return TypeSelectorComponent<BuyerType>(
                selectorWidth: 171,
                values: BuyerType.values,
                currentType: state.buyerType,
                onTap: (type) {
                  context.read<BookPropertyCubit>().changeBuyerType(type);
                },
                getIcon: (type) {
                  switch (type) {
                    case BuyerType.iAmBuyer:
                      return AppAssets.emptyIcon;
                    case BuyerType.anotherBuyer:
                      return AppAssets.emptyIcon;
                  }
                },
                getLabel: (type) => type.toName,
              );
            },
          ),
          SizedBox(height: context.scale(20)),
          Text(
            LocaleKeys.idPhoto.tr(),
            style: getBoldStyle(
                color: ColorManager.blackColor, fontSize: FontSize.s16),
          ),
          SizedBox(height: context.scale(8)),
          BlocBuilder<BookPropertyCubit, BookPropertyState>(
            builder: (context, state) {
              final cubit = context.read<BookPropertyCubit>();
              return SelectImagesComponent(
                height: 124,
                selectedImages: state.selectedImages,
                isLoading: state.selectImagesState.isLoading,
                validateImages: state.validateImages,
                hintText: LocaleKeys.uploadClearIdPhotos.tr(),
                onSelectImages: () async {
                  cubit.selectImage(1);
                },
                onRemoveImage: cubit.removeImage,
                onValidateImages: cubit.validateImages,
                mode: ImageSelectionMode.single,
              );
            },
          ),
          SizedBox(height: context.scale(16)),
          Text(
            LocaleKeys.phoneNumber.tr(),
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s12,
            ),
          ),
          SizedBox(height: context.scale(16)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<BookPropertyCubit, BookPropertyState>(
                buildWhen: (previous, current) =>
                previous.countryCode != current.countryCode ||
                    previous.phoneNumber != current.phoneNumber,
                builder: (context, state) {
                  final cubit = context.read<BookPropertyCubit>();
                  return Expanded(
                    child: AppTextField(
                      textDirection: material.TextDirection.ltr,
                      hintText: LocaleKeys.phoneNumberPlaceholder.tr(),
                      keyboardType: TextInputType.phone,
                      borderRadius: 20,
                      backgroundColor: ColorManager.whiteColor,
                      padding: EdgeInsets.zero,
                      controller: cubit.phoneNumberController,
                      validator: _validatePhone,
                      onChanged: (value) {
                        cubit.setPhoneNumber(value);
                      },
                    ),
                  );
                },
              ),
              SizedBox(width: context.scale(8)),
              BlocBuilder<BookPropertyCubit, BookPropertyState>(
                builder: (context, state) {
                  final cubit = context.read<BookPropertyCubit>();
                  return Container(
                    width: context.scale(88),
                    height: context.scale(44),
                    decoration: BoxDecoration(
                      color: ColorManager.whiteColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CustomCountryCodePicker(
                      onChanged: (CountryCode countryCode) {
                        cubit.setCountryCode(countryCode.dialCode!);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: context.scale(16)),
          Text(
            LocaleKeys.fullName.tr(),
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s12,
            ),
          ),
          SizedBox(height: context.scale(8)),
          BlocBuilder<BookPropertyCubit, BookPropertyState>(
            builder: (context, state) {
              final cubit = context.read<BookPropertyCubit>();
              return AppTextField(
                hintText: LocaleKeys.buyerNamePlaceholder.tr(),
                keyboardType: TextInputType.name,
                borderRadius: 20,
                backgroundColor: ColorManager.whiteColor,
                padding: EdgeInsets.zero,
                controller: cubit.nameController,
                validator: _validateName,
                onChanged: (value) {
                  cubit.setUserName(value);
                },
              );
            },
          ),
          SizedBox(height: context.scale(16)),
          Text(
            LocaleKeys.idNumber.tr(),
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s12,
            ),
          ),
          SizedBox(height: context.scale(8)),
          BlocBuilder<BookPropertyCubit, BookPropertyState>(
            buildWhen: (previous, current) => previous.userID != current.userID,
            builder: (context, state) {
              final cubit = context.read<BookPropertyCubit>();
              return AppTextField(
                hintText: LocaleKeys.idNumberPlaceholder.tr(),
                keyboardType: TextInputType.number,
                borderRadius: 20,
                backgroundColor: ColorManager.whiteColor,
                padding: EdgeInsets.zero,
                controller: cubit.iDNumberController,
                validator: (value) => FormValidator.validateNumber(value, fieldName: LocaleKeys.idNumber.tr()),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (value) {
                  cubit.setIDUserNumber(value);
                },
              );
            },
          ),
          SizedBox(height: context.scale(16)),
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                // Birth Date Picker
                Expanded(
                  child: BlocBuilder<BookPropertyCubit, BookPropertyState>(
                    builder: (context, state) {
                      final cubit = context.read<BookPropertyCubit>();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.birthDate.tr(),
                            style: getBoldStyle(
                              color: ColorManager.blackColor,
                              fontSize: FontSize.s12,
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
                                      borderRadius:
                                      BorderRadius.circular(context.scale(12)),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(context.scale(16)),
                                      width:
                                      MediaQuery.of(context).size.width * 0.8,
                                      height:
                                      MediaQuery.of(context).size.height * 0.4,
                                      decoration: BoxDecoration(
                                        color: ColorManager.whiteColor,
                                        borderRadius: BorderRadius.circular(
                                            context.scale(12)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: ColorManager.blackColor
                                                .withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: CustomDatePicker(
                                        showPreviousDates: true,
                                        selectedDate: state.birthDate,
                                        maxDate: DateTime.now(),
                                        onSelectionChanged:
                                            (calendarSelectionDetails) {
                                          cubit.selectBirthDate(
                                              calendarSelectionDetails.date!);
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
                                borderRadius:
                                BorderRadius.circular(context.scale(20)),
                                border: Border.all(
                                  color: ColorManager.greyShade,
                                  width: 0.5,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: context.scale(16)),
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
                                        state.birthDate != null
                                            ? '${state.birthDate!.day}/${state.birthDate!.month}/${state.birthDate!.year}'
                                            : LocaleKeys.chooseDate.tr(),
                                        style: state.birthDate == null
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
                    },
                  ),
                ),
                SizedBox(width: context.scale(16)),
                // ID Expiration Date Picker
                Expanded(
                  child: BlocBuilder<BookPropertyCubit, BookPropertyState>(
                    builder: (context, state) {
                      final cubit = context.read<BookPropertyCubit>();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.idExpirationDate.tr(),
                            style: getBoldStyle(
                              color: ColorManager.blackColor,
                              fontSize: FontSize.s12,
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
                                      borderRadius:
                                      BorderRadius.circular(context.scale(12)),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(context.scale(16)),
                                      width:
                                      MediaQuery.of(context).size.width * 0.8,
                                      height:
                                      MediaQuery.of(context).size.height * 0.4,
                                      decoration: BoxDecoration(
                                        color: ColorManager.whiteColor,
                                        borderRadius: BorderRadius.circular(
                                            context.scale(12)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: ColorManager.blackColor
                                                .withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: CustomDatePicker(
                                        showPreviousDates: false,
                                        selectedDate: state.idExpirationDate,
                                        onSelectionChanged:
                                            (calendarSelectionDetails) {
                                          cubit.selectIDExpirationDate(
                                              calendarSelectionDetails.date!);
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
                                borderRadius:
                                BorderRadius.circular(context.scale(20)),
                                border: Border.all(
                                  color: ColorManager.greyShade,
                                  width: 0.5,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: context.scale(16)),
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
                                        state.idExpirationDate != null
                                            ? '${state.idExpirationDate!.day}/${state.idExpirationDate!.month}/${state.idExpirationDate!.year}'
                                            : LocaleKeys.chooseDate.tr(),
                                        style: state.idExpirationDate == null
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
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}