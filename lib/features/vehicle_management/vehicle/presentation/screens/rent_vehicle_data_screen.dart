import 'package:country_code_picker/country_code_picker.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/extensions/request_states_extension.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/translation/locale_keys.dart';
import '../../../../../configuration/managers/color_manager.dart';
import '../../../../../configuration/managers/font_manager.dart';
import '../../../../../configuration/managers/style_manager.dart';
import '../../../../../configuration/managers/value_manager.dart';
import '../../../../../core/components/app_text_field.dart';
import '../../../../../core/components/country_code_picker.dart';
import '../../../../../core/components/custom_date_picker.dart';
import '../../../../../core/components/svg_image_component.dart';
import '../../../../../core/utils/form_validator.dart';
import '../../../../add_new_real_estate/presentation/components/numbered_text_header_component.dart';
import '../../../../add_new_real_estate/presentation/components/select_images_component.dart';
import '../../../../home_module/home_imports.dart';
import 'package:flutter/material.dart' as material;
import 'package:latlong2/latlong.dart';
import '../controller/rent_vehicle_cubit.dart';
import 'location_picker_screen.dart';

class RentVehicleDataScreen extends StatefulWidget {
  const RentVehicleDataScreen({super.key});

  @override
  State<RentVehicleDataScreen> createState() => _RentVehicleDataScreenState();
}

class _RentVehicleDataScreenState extends State<RentVehicleDataScreen> {
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

  String? _validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.ageRequired.tr();
    }
    final age = int.tryParse(value);
    if (age == null || age < 18) {
      return LocaleKeys.minimumAgeRequired.tr();
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
            text: LocaleKeys.tenantInformation.tr(),
          ),
          SizedBox(height: context.scale(20)),

          // Photo d'identité
          Text(
            LocaleKeys.idPhoto.tr(),
            style: getBoldStyle(
                color: ColorManager.blackColor, fontSize: FontSize.s16),
          ),
          SizedBox(height: context.scale(8)),
          BlocBuilder<RentVehicleCubit, RentVehicleState>(
            builder: (context, state) {
              final cubit = context.read<RentVehicleCubit>();
              return SelectImagesComponent(
                height: 124,
                selectedImages: state.idImage != null ? [state.idImage!] : [],
                isLoading: state.selectIDImageState.isLoading,
                validateImages: state.validateIDImage,
                hintText: LocaleKeys.uploadClearIdPhoto.tr(),
                onSelectImages: () async {
                  cubit.selectIDImage();
                },
                onRemoveImage: (index) => cubit.removeIDImage(),
                onValidateImages: cubit.validateIDImage,
                mode: ImageSelectionMode.single,
              );
            },
          ),

          SizedBox(height: context.scale(16)),

          // Permis de conduire
          Text(
            LocaleKeys.drivingLicense.tr(),
            style: getBoldStyle(
                color: ColorManager.blackColor, fontSize: FontSize.s16),
          ),
          SizedBox(height: context.scale(8)),
          BlocBuilder<RentVehicleCubit, RentVehicleState>(
            builder: (context, state) {
              final cubit = context.read<RentVehicleCubit>();
              return SelectImagesComponent(
                height: 124,
                selectedImages: state.driveLicenseImage != null ? [state.driveLicenseImage!] : [],
                isLoading: state.selectDriveLicenseImageState.isLoading,
                validateImages: state.validateDriveLicenseImage,
                hintText: LocaleKeys.uploadClearDrivingLicense.tr(),
                onSelectImages: () async {
                  cubit.selectDriveLicenseImage();
                },
                onRemoveImage: (index) => cubit.removeDriveLicenseImage(),
                onValidateImages: cubit.validateDriveLicenseImage,
                mode: ImageSelectionMode.single,
              );
            },
          ),

          SizedBox(height: context.scale(16)),

          // Numéro de téléphone
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
              BlocBuilder<RentVehicleCubit, RentVehicleState>(
                buildWhen: (previous, current) =>
                previous.phoneNumber != current.phoneNumber,
                builder: (context, state) {
                  final cubit = context.read<RentVehicleCubit>();
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
              Container(
                width: context.scale(88),
                height: context.scale(44),
                decoration: BoxDecoration(
                  color: ColorManager.whiteColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CustomCountryCodePicker(
                  onChanged: (CountryCode countryCode) {
                    // Gérer le changement de code pays si nécessaire
                  },
                ),
              ),
            ],
          ),

          SizedBox(height: context.scale(16)),

          // Nom complet
          Text(
            LocaleKeys.fullName.tr(),
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s12,
            ),
          ),
          SizedBox(height: context.scale(8)),
          BlocBuilder<RentVehicleCubit, RentVehicleState>(
            builder: (context, state) {
              final cubit = context.read<RentVehicleCubit>();
              return AppTextField(
                hintText: LocaleKeys.tenantFullNamePlaceholder.tr(),
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

          // Numéro d'identité
          Text(
            LocaleKeys.idNumber.tr(),
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s12,
            ),
          ),
          SizedBox(height: context.scale(8)),
          BlocBuilder<RentVehicleCubit, RentVehicleState>(
            buildWhen: (previous, current) => previous.userID != current.userID,
            builder: (context, state) {
              final cubit = context.read<RentVehicleCubit>();
              return AppTextField(
                hintText: LocaleKeys.idNumberPlaceholder.tr(),
                keyboardType: TextInputType.number,
                borderRadius: 20,
                backgroundColor: ColorManager.whiteColor,
                padding: EdgeInsets.zero,
                controller: cubit.idNumberController,
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

          // Âge
          Text(
            LocaleKeys.age.tr(),
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s12,
            ),
          ),
          SizedBox(height: context.scale(8)),
          BlocBuilder<RentVehicleCubit, RentVehicleState>(
            builder: (context, state) {
              final cubit = context.read<RentVehicleCubit>();
              return AppTextField(
                hintText: LocaleKeys.agePlaceholder.tr(),
                keyboardType: TextInputType.number,
                borderRadius: 20,
                backgroundColor: ColorManager.whiteColor,
                padding: EdgeInsets.zero,
                controller: cubit.ageController,
                validator: _validateAge,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (value) {
                  cubit.setAge(value);
                },
              );
            },
          ),

          SizedBox(height: context.scale(16)),

          // Dates (naissance et expiration ID)
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                // Date de naissance
                Expanded(
                  child: BlocBuilder<RentVehicleCubit, RentVehicleState>(
                    builder: (context, state) {
                      final cubit = context.read<RentVehicleCubit>();
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
                // Date d'expiration ID
                Expanded(
                  child: BlocBuilder<RentVehicleCubit, RentVehicleState>(
                    builder: (context, state) {
                      final cubit = context.read<RentVehicleCubit>();
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

          SizedBox(height: context.scale(20)),

          // Section Lieu de réception
          Text(
            LocaleKeys.vehicleReceptionPlace.tr(),
            style: getBoldStyle(
                color: ColorManager.blackColor, fontSize: FontSize.s16),
          ),
          SizedBox(height: context.scale(16)),

          // Bouton de sélection du lieu de réception
          BlocBuilder<RentVehicleCubit, RentVehicleState>(
            builder: (context, state) {
              final cubit = context.read<RentVehicleCubit>();
              return InkWell(
                onTap: () async {
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LocationPickerScreen(
                        title: LocaleKeys.selectReceptionPlace.tr(),
                        initialAddress: state.vehicleReceptionPlace.isNotEmpty
                            ? state.vehicleReceptionPlace
                            : null,
                        initialLocation: state.vehicleReceptionLat.isNotEmpty && state.vehicleReceptionLng.isNotEmpty
                            ? LatLng(
                          double.parse(state.vehicleReceptionLat) ,
                          double.parse(state.vehicleReceptionLng),
                        )
                            : null,
                      ),
                    ),
                  );

                  if (result != null) {
                    cubit.setVehicleReceptionPlace(result['address']);
                    cubit.setVehicleReceptionLat(result['latitude']);
                    cubit.setVehicleReceptionLng(result['longitude']);
                  }
                },
                child: Container(
                  height: context.scale(60),
                  decoration: BoxDecoration(
                    color: ColorManager.whiteColor,
                    borderRadius: BorderRadius.circular(20),
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
                          iconPath: AppAssets.locationIcon,
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(width: context.scale(12)),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LocaleKeys.receptionPlace.tr(),
                                style: getMediumStyle(
                                  color: ColorManager.blackColor,
                                  fontSize: FontSize.s12,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                state.vehicleReceptionPlace.isNotEmpty
                                    ? state.vehicleReceptionPlace
                                    : LocaleKeys.selectOnMap.tr(),
                                style: getRegularStyle(
                                  color: state.vehicleReceptionPlace.isNotEmpty
                                      ? ColorManager.primaryColor
                                      : ColorManager.grey2,
                                  fontSize: FontSize.s11,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: ColorManager.grey2,
                          size: context.scale(16),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: context.scale(20)),

          // Section Lieu de retour
          Text(
            LocaleKeys.vehicleReturnPlace.tr(),
            style: getBoldStyle(
                color: ColorManager.blackColor, fontSize: FontSize.s16),
          ),
          SizedBox(height: context.scale(16)),

          // Bouton de sélection du lieu de retour
          BlocBuilder<RentVehicleCubit, RentVehicleState>(
            builder: (context, state) {
              final cubit = context.read<RentVehicleCubit>();
              return InkWell(
                onTap: () async {
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LocationPickerScreen(
                        title: LocaleKeys.selectReturnPlace.tr(),
                        initialAddress: state.vehicleReturnPlace.isNotEmpty
                            ? state.vehicleReturnPlace
                            : null,
                        initialLocation: state.vehicleReturnLat.isNotEmpty && state.vehicleReturnLng.isNotEmpty
                            ? LatLng(
                          double.parse(state.vehicleReturnLat),
                          double.parse(state.vehicleReturnLng),
                        )
                            : null,
                      ),
                    ),
                  );

                  if (result != null) {
                    cubit.setVehicleReturnPlace(result['address']);
                    cubit.setVehicleReturnLat(result['latitude']);
                    cubit.setVehicleReturnLng(result['longitude']);
                  }
                },
                child: Container(
                  height: context.scale(60),
                  decoration: BoxDecoration(
                    color: ColorManager.whiteColor,
                    borderRadius: BorderRadius.circular(20),
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
                          iconPath: AppAssets.locationIcon,
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(width: context.scale(12)),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LocaleKeys.returnPlace.tr(),
                                style: getMediumStyle(
                                  color: ColorManager.blackColor,
                                  fontSize: FontSize.s12,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                state.vehicleReturnPlace.isNotEmpty
                                    ? state.vehicleReturnPlace
                                    : LocaleKeys.selectOnMap.tr(),
                                style: getRegularStyle(
                                  color: state.vehicleReturnPlace.isNotEmpty
                                      ? ColorManager.primaryColor
                                      : ColorManager.grey2,
                                  fontSize: FontSize.s11,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: ColorManager.grey2,
                          size: context.scale(16),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: context.scale(20)),

          // Dates de location
          Text(
            LocaleKeys.rentalDates.tr(),
            style: getBoldStyle(
                color: ColorManager.blackColor, fontSize: FontSize.s16),
          ),
          SizedBox(height: context.scale(16)),

          // Dates (début et fin de location)
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                // Date de début de location
                Expanded(
                  child: BlocBuilder<RentVehicleCubit, RentVehicleState>(
                    builder: (context, state) {
                      final cubit = context.read<RentVehicleCubit>();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.startDate.tr(),
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
                                        selectedDate: state.rentalDate,
                                        onSelectionChanged:
                                            (calendarSelectionDetails) {
                                          cubit.selectRentalDate(
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
                                        state.rentalDate != null
                                            ? '${state.rentalDate!.day}/${state.rentalDate!.month}/${state.rentalDate!.year}'
                                            : LocaleKeys.chooseDate.tr(),
                                        style: state.rentalDate == null
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
                // Date de fin de location
                Expanded(
                  child: BlocBuilder<RentVehicleCubit, RentVehicleState>(
                    builder: (context, state) {
                      final cubit = context.read<RentVehicleCubit>();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.endDate.tr(),
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
                                        selectedDate: state.returnDate,
                                        onSelectionChanged:
                                            (calendarSelectionDetails) {
                                          cubit.selectReturnDate(
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
                                        state.returnDate != null
                                            ? '${state.returnDate!.day}/${state.returnDate!.month}/${state.returnDate!.year}'
                                            : LocaleKeys.chooseDate.tr(),
                                        style: state.returnDate == null
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