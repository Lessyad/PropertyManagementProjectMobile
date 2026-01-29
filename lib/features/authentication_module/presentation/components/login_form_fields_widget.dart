import 'package:country_code_picker/country_code_picker.dart';
import 'package:enmaa/features/authentication_module/presentation/controller/remote_authentication_bloc/remote_authentication_cubit.dart';
import 'package:flutter/material.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/components/app_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;
import '../../../../configuration/routers/route_names.dart';
import '../../../../core/components/country_code_picker.dart';
import '../../../../core/translation/locale_keys.dart';

class LoginFormFields extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final String? Function(String?) validatePhone;
  final String? Function(String?) validatePassword;

  const LoginFormFields({
    super.key,
    required this.phoneController,
    required this.passwordController,
    required this.validatePhone,
    required this.validatePassword,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PhoneField(
          controller: phoneController,
          validator: validatePhone,
        ),
        SizedBox(height: context.scale(16)),
        _PasswordField(
          controller: passwordController,
          validator: validatePassword,
        ),
        SizedBox(height: context.scale(12)),
        _ForgotPasswordText(),
      ],
    );
  }
}

class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?) validator;

  const _PhoneField({
    required this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              buildWhen: (previous, current) =>
              previous.currentCountryCode != current.currentCountryCode,
              builder: (context, state) {
                return Expanded(
                  child: AppTextField(
                    textDirection: ui.TextDirection.ltr,
                    hintText: '0100000000000',
                    keyboardType: TextInputType.phone,
                    borderRadius: 20,
                    backgroundColor: ColorManager.greyShade,
                    padding: EdgeInsets.zero,
                    controller: controller,
                    validator: validator,
                    onChanged: (value) {
                      BlocProvider.of<RemoteAuthenticationCubit>(context)
                          .changeUserPhoneNumber(value);
                      if (!value.startsWith(state.currentCountryCode)) {
                        controller.clear();
                        controller.text = state.currentCountryCode;
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
                  controller.clear();
                  controller.text = countryCode.dialCode!;
                  BlocProvider.of<RemoteAuthenticationCubit>(context)
                      .setCountryCode(countryCode.dialCode!);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?) validator;

  const _PasswordField({
    required this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.password.tr(),
          style: getBoldStyle(
            color: ColorManager.blackColor,
            fontSize: FontSize.s12,
          ),
        ),
        SizedBox(height: context.scale(16)),
        BlocBuilder<RemoteAuthenticationCubit, RemoteAuthenticationState>(
          buildWhen: (previous, current) => previous.loginPasswordVisibility != current.loginPasswordVisibility,
          builder: (context, state) {
            final bool showPassword = state.loginPasswordVisibility;
            return AppTextField(
              hintText: LocaleKeys.password.tr(),
              keyboardType: TextInputType.text,
              borderRadius: 20,
              backgroundColor: ColorManager.greyShade,
              padding: EdgeInsets.zero,
              controller: controller,
              obscureText: !showPassword,
              validator: validator,
              suffixIcon: IconButton(
                icon: Icon(
                  !showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: ColorManager.grey,
                ),
                onPressed: () {
                  context.read<RemoteAuthenticationCubit>().changeLoginPasswordVisibility();
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ForgotPasswordText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutersNames.resetPasswordScreen);
      },
      child: Text(
        LocaleKeys.forgotPassword.tr(),
        style: getUnderlineBoldStyle(
          color: ColorManager.redColor,
          fontSize: FontSize.s12,
        ),
      ),
    );
  }
}