import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/components/circular_icon_button.dart';
import 'dart:ui' as ui;
import 'package:enmaa/features/authentication_module/presentation/controller/remote_authentication_bloc/remote_authentication_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../configuration/managers/font_manager.dart';
import '../../../../configuration/routers/route_names.dart';
import '../../../../core/components/app_text_field.dart';
import '../../../../core/components/button_app_component.dart';
import '../../../../core/components/country_code_picker.dart';
import '../../../../core/components/custom_snack_bar.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/translation/locale_keys.dart';
import '../../data/models/login_request_model.dart';
import '../components/login_buttons_widget.dart';
import '../components/login_form_fields_widget.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController(text: '+20');
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.phoneRequired.tr();
    }
    return null;
  }


  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.whiteColor,
      body: Stack(
        children: [
          SafeArea(
            child: Stack(
              children: [
                PositionedDirectional(
                  top: context.scale(24),
                  start: context.scale(16),
                  child: CircularIconButton(
                    iconPath: AppAssets.backIcon,
                    backgroundColor: ColorManager.greyShade,
                    containerSize: 40,
                    iconSize: 16,
                    padding: const EdgeInsets.all(8),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                PositionedDirectional(
                  top: context.scale(24 + 40 + 24),
                  end: 0,
                  start: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.scale(16)),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            LocaleKeys.recoverPassword.tr(),
                            style: getBoldStyle(color: ColorManager.blackColor, fontSize: FontSize.s20),
                          ),
                          SizedBox(height: context.scale(8)),
                          Text(
                            LocaleKeys.recoverPasswordHint.tr(),
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            style: getSemiBoldStyle(color: ColorManager.grey2, fontSize: FontSize.s14),
                          ),
                          SizedBox(height: context.scale(8)),
                          Text(
                            LocaleKeys.mobileNumber.tr(),
                            style: getBoldStyle(
                              color: ColorManager.blackColor,
                              fontSize: FontSize.s12,
                            ),
                          ),
                          SizedBox(height: context.scale(16)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BlocBuilder<RemoteAuthenticationCubit, RemoteAuthenticationState>(
                                buildWhen: (previous, current) => previous.currentCountryCode != current.currentCountryCode,
                                builder: (context, state) {
                                  return Expanded(
                                    child: AppTextField(
                                      textDirection: ui.TextDirection.ltr,
                                      hintText: '0100000000000',
                                      keyboardType: TextInputType.phone,
                                      borderRadius: 20,
                                      backgroundColor: ColorManager.greyShade,
                                      padding: EdgeInsets.zero,
                                      controller: phoneController,
                                      validator: _validatePhone,
                                      onChanged: (value) {
                                        BlocProvider.of<RemoteAuthenticationCubit>(context).changeUserPhoneNumber(value);
                                        if (!value.startsWith(state.currentCountryCode)) {
                                          phoneController.clear();
                                          phoneController.text = state.currentCountryCode;
                                        }
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
                                  color: ColorManager.greyShade,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: CustomCountryCodePicker(
                                  onChanged: (CountryCode countryCode) {
                                    phoneController.clear();
                                    phoneController.text = countryCode.dialCode!;
                                    BlocProvider.of<RemoteAuthenticationCubit>(context).setCountryCode(countryCode.dialCode!);
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: context.scale(24)),
                          BlocBuilder<RemoteAuthenticationCubit, RemoteAuthenticationState>(
                            buildWhen: (previous, current) {
                              return previous.sendOtpRequestState != current.sendOtpRequestState;
                            },
                            builder: (context, state) {
                              return ButtonAppComponent(
                                width: double.infinity,
                                padding: EdgeInsets.zero,
                                buttonContent: Center(
                                  child: Text(
                                    LocaleKeys.next.tr(),
                                    style: getBoldStyle(
                                      color: ColorManager.whiteColor,
                                      fontSize: FontSize.s14,
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: ColorManager.primaryColor,
                                  borderRadius: BorderRadius.circular(context.scale(20)),
                                ),
                                onTap: () {
                                  if (formKey.currentState?.validate() ?? false) {
                                    final authenticationCubit = context.read<RemoteAuthenticationCubit>();
                                    authenticationCubit.sendOtp(phoneController.text);
                                    authenticationCubit.changeUserName(nameController.text);
                                    Navigator.pushNamed(
                                      context,
                                      RoutersNames.otpScreen,
                                      arguments: true,
                                    );
                                  }
                                },
                              );
                            },
                          )
                        ],
                      ),
                    ),
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