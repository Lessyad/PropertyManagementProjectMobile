import 'package:country_code_picker/country_code_picker.dart';
import 'package:enmaa/core/services/convert_numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/extensions/request_states_extension.dart';
import 'package:enmaa/features/my_profile/modules/user_data_module/presentation/controller/user_data_cubit.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/core/components/app_bar_component.dart';
import 'package:enmaa/core/components/app_text_field.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/components/country_code_picker.dart';
import '../../../../../../core/components/loading_overlay_component.dart';
import '../../../../../../core/constants/local_keys.dart';
import '../../../../../../core/services/shared_preferences_service.dart';
import '../../../../../../core/translation/locale_keys.dart';
import '../../../../../../core/utils/enums.dart';
import '../components/date_selection_field.dart';
import '../components/user_data_screen_buttons.dart';

class EditUserDataScreen extends StatefulWidget {
  const EditUserDataScreen({super.key});

  @override
  State<EditUserDataScreen> createState() => _EditUserDataScreenState();
}

class _EditUserDataScreenState extends State<EditUserDataScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _idNumberController;
  DateTime? _selectedBirthDate;
  DateTime? _selectedIdExpirationDate;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _idNumberController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sharedPrefs = SharedPreferencesService();
      if (!sharedPrefs.hasKey(LocalKeys.userPhone)) {
        context.read<UserDataCubit>().getRemoteUserData();
      } else {
        context.read<UserDataCubit>().getLocalUserData();
      }
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _idNumberController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _onSavePressed() {
    if (_formKey.currentState!.validate()) {
      final updatedData = {
        'full_name': _fullNameController.text,
        'phone_number': _phoneNumberController.text,
        'id_number': _idNumberController.text,
        'date_of_birth': _formatDate(_selectedBirthDate),
        'id_expiry_date': _formatDate(_selectedIdExpirationDate),
      };
      context.read<UserDataCubit>().updateUserData(updatedData);
    }
  }

  void _spreadUserData(UserDataState state) {
    if (state.getUserDataState == RequestState.loaded && state.userDataEntity != null) {
      _fullNameController.text = state.userDataEntity!.userName ?? '';
      _phoneNumberController.text = NumbersServices.relocatePlusInNumber(state.userDataEntity!.phoneNumber ?? '' , context.locale.languageCode);
      _idNumberController.text = state.userDataEntity!.idNumber ?? '';
      _selectedBirthDate = _parseDate(state.userDataEntity!.dateOfBirth);
      _selectedIdExpirationDate = _parseDate(state.userDataEntity!.idExpirationDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.greyShade,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBarComponent(
            appBarTextMessage: LocaleKeys.profilePage.tr(),
            showNotificationIcon: false,
            showLocationIcon: false,
            centerText: true,
            showBackIcon: true,
          ),
          Expanded(
            child: BlocListener<UserDataCubit, UserDataState>(
              listener: (context, state) {},
              child: BlocBuilder<UserDataCubit, UserDataState>(
                buildWhen: (previous, current) {
                  if (!previous.getUserDataState.isLoaded && current.getUserDataState.isLoaded) {
                    _spreadUserData(current);
                  }
                  return true;
                },
                builder: (context, state) {
                  if (state.getUserDataState.isLoading || state.getUserDataState.isInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.getUserDataState.isLoaded) {
                    return Stack(
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                padding: EdgeInsets.all(context.scale(16)),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: context.scale(60),
                                            height: context.scale(60),
                                            decoration: BoxDecoration(
                                              color: ColorManager.primaryColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                _fullNameController.text.isNotEmpty
                                                    ? _fullNameController.text[0]
                                                    : 'U',
                                                style: getBoldStyle(
                                                  color: ColorManager.whiteColor,
                                                  fontSize: FontSize.s18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: context.scale(16)),
                                      Text(LocaleKeys.fullName.tr(),
                                          style: getBoldStyle(
                                              color: ColorManager.blackColor,
                                              fontSize: FontSize.s16)),
                                      SizedBox(height: context.scale(8)),
                                      AppTextField(
                                        controller: _fullNameController,
                                        height: 40,
                                        hintText: LocaleKeys.enterFullName.tr(),
                                        backgroundColor: Colors.white,
                                        borderRadius: 24,
                                        validator: (value) =>
                                        value == null || value.isEmpty ? LocaleKeys.fullNameRequired.tr() : null,
                                        padding: EdgeInsets.zero,
                                      ),
                                      SizedBox(height: context.scale(16)),
                                      Text(LocaleKeys.phoneNumber.tr(),
                                          style: getBoldStyle(
                                              color: ColorManager.blackColor,
                                              fontSize: FontSize.s16)),
                                      SizedBox(height: context.scale(8)),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: AppTextField(
                                              controller: _phoneNumberController,
                                              height: 40,
                                              hintText: LocaleKeys.enterPhoneNumber.tr(),
                                              backgroundColor: Colors.white,
                                              borderRadius: 24,
                                              editable: false,
                                              validator: (value) => value == null || value.isEmpty
                                                  ? LocaleKeys.phoneNumberRequired.tr()
                                                  : null,
                                              padding: EdgeInsets.zero,
                                            ),
                                          ),
                                          SizedBox(width: context.scale(8)),
                                          AbsorbPointer(
                                            child: Container(
                                              width: context.scale(60),
                                              height: context.scale(40),
                                              decoration: BoxDecoration(
                                                color: ColorManager.whiteColor,
                                                borderRadius: BorderRadius.circular(24),
                                              ),
                                              child: CustomCountryCodePicker(
                                                disableSelection : true ,
                                                onChanged: (CountryCode countryCode) {


                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: context.scale(16)),
                                      Text(LocaleKeys.idNumber.tr(),
                                          style: getBoldStyle(
                                              color: ColorManager.blackColor,
                                              fontSize: FontSize.s16)),
                                      SizedBox(height: context.scale(8)),
                                      AppTextField(
                                        controller: _idNumberController,
                                        height: 40,
                                        hintText: LocaleKeys.enterIdNumber.tr(),
                                        backgroundColor: Colors.white,
                                        borderRadius: 24,
                                        validator: (value) =>
                                        value == null || value.isEmpty ? LocaleKeys.idNumberRequired.tr() : null,
                                        padding: EdgeInsets.zero,
                                      ),
                                      SizedBox(height: context.scale(16)),
                                      DateSelectionField(
                                        labelText: LocaleKeys.dateOfBirth.tr(),
                                        selectedDate: _selectedBirthDate,
                                        iconPath: AppAssets.birthDayIcon,
                                        onDateSelected: (date) {
                                          setState(() {
                                            _selectedBirthDate = date;
                                          });
                                        },
                                      ),
                                      SizedBox(height: context.scale(16)),
                                      DateSelectionField(
                                        labelText: LocaleKeys.idExpirationDate.tr(),
                                        iconPath: AppAssets.cardIdentityIcon,
                                        selectedDate: _selectedIdExpirationDate,
                                        onDateSelected: (date) {
                                          setState(() {
                                            _selectedIdExpirationDate = date;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: context.scale(88),
                              decoration: BoxDecoration(
                                color: ColorManager.whiteColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(context.scale(24)),
                                  topRight: Radius.circular(context.scale(24)),
                                ),
                              ),
                              child: UserDataScreenButtons(
                                onSavePressed: _onSavePressed,
                              ),
                            ),
                          ],
                        ),
                        if (state.updateUserDataState.isLoading)
                          LoadingOverlayComponent(
                            opacity: 0,
                            text: LocaleKeys.updatingData.tr(),
                          )
                      ],
                    );
                  }
                  return Center(
                    child: Text(
                      LocaleKeys.dataFetchError.tr(),
                      style: getBoldStyle(color: ColorManager.redColor, fontSize: FontSize.s16),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  DateTime? _parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      final parts = dateString.split('-');
      if (parts.length != 3) return null;
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (e) {
      return null;
    }
  }
}