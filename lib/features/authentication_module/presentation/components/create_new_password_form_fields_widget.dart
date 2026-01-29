import 'package:flutter/material.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/components/app_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/translation/locale_keys.dart';
import '../controller/remote_authentication_bloc/remote_authentication_cubit.dart';

class CreateNewPasswordFormFieldsWidget extends StatelessWidget {
  final TextEditingController passwordController1;
  final TextEditingController passwordController2;

  const CreateNewPasswordFormFieldsWidget({
    super.key,
    required this.passwordController1,
    required this.passwordController2,
  });

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.confirmPasswordRequired.tr();
    }

    if (value != passwordController1.text) {
      return LocaleKeys.passwordsDoNotMatch.tr();
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PasswordField1(
          controller: passwordController1,
        ),
        SizedBox(height: context.scale(16)),
        _PasswordField2(
          controller: passwordController2,
          validator: validateConfirmPassword,
        ),
      ],
    );
  }
}

class _PasswordField1 extends StatefulWidget {
  final TextEditingController controller;

  const _PasswordField1({
    required this.controller,
  });

  @override
  State<_PasswordField1> createState() => _PasswordField1State();
}

class _PasswordField1State extends State<_PasswordField1> {
  bool hasEightChars = false;
  bool hasOneNumber = false;
  bool hasOneLetter = false;

  void _checkPasswordRequirements(String value) {
    setState(() {
      hasEightChars = value.length >= 8;
      hasOneNumber = value.contains(RegExp(r'[0-9]'));
      hasOneLetter = value.contains(RegExp(r'[a-zA-Z]'));
    });
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      _checkPasswordRequirements(widget.controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.newPassword.tr(),
          style: getBoldStyle(
            color: ColorManager.blackColor,
            fontSize: FontSize.s12,
          ),
        ),
        SizedBox(height: context.scale(16)),
        BlocBuilder<RemoteAuthenticationCubit, RemoteAuthenticationState>(
          buildWhen: (previous, current) =>
          previous.createNewPasswordPasswordVisibility1 != current.createNewPasswordPasswordVisibility1,
          builder: (context, state) {
            final bool showPassword = state.createNewPasswordPasswordVisibility1;
            return AppTextField(
              hintText: '',
              borderRadius: 20,
              backgroundColor: ColorManager.greyShade,
              padding: EdgeInsets.zero,
              controller: widget.controller,
              obscureText: showPassword,
              suffixIcon: IconButton(
                icon: Icon(
                  !showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: ColorManager.grey,
                ),
                onPressed: () {
                  context.read<RemoteAuthenticationCubit>().changeCreateNewPasswordVisibility1();
                },
              ),
            );
          },
        ),
        SizedBox(height: context.scale(8)),
        Row(
          children: [
            Icon(
              hasEightChars ? Icons.check_circle : Icons.circle_outlined,
              size: 16,
              color: hasEightChars ? Colors.green : Colors.grey,
            ),
            SizedBox(width: 8),
            Text(
              LocaleKeys.minEightChars.tr(),
              style: getRegularStyle(
                color: hasEightChars ? Colors.green : Colors.grey,
                fontSize: FontSize.s12,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Icon(
              hasOneNumber ? Icons.check_circle : Icons.circle_outlined,
              size: 16,
              color: hasOneNumber ? Colors.green : Colors.grey,
            ),
            SizedBox(width: 8),
            Text(
              LocaleKeys.minOneNumber.tr(),
              style: getRegularStyle(
                color: hasOneNumber ? Colors.green : Colors.grey,
                fontSize: FontSize.s12,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Icon(
              hasOneLetter ? Icons.check_circle : Icons.circle_outlined,
              size: 16,
              color: hasOneLetter ? Colors.green : Colors.grey,
            ),
            SizedBox(width: 8),
            Text(
              LocaleKeys.minOneLetter.tr(),
              style: getRegularStyle(
                color: hasOneLetter ? Colors.green : Colors.grey,
                fontSize: FontSize.s12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PasswordField2 extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?) validator;

  const _PasswordField2({
    required this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.confirmPassword.tr(),
          style: getBoldStyle(
            color: ColorManager.blackColor,
            fontSize: FontSize.s12,
          ),
        ),
        SizedBox(height: context.scale(16)),
        BlocBuilder<RemoteAuthenticationCubit, RemoteAuthenticationState>(
          buildWhen: (previous, current) =>
          previous.createNewPasswordPasswordVisibility2 != current.createNewPasswordPasswordVisibility2,
          builder: (context, state) {
            final bool showPassword = state.createNewPasswordPasswordVisibility2;
            return AppTextField(
              hintText: LocaleKeys.password.tr(),
              keyboardType: TextInputType.text,
              borderRadius: 20,
              backgroundColor: ColorManager.greyShade,
              padding: EdgeInsets.zero,
              controller: controller,
              obscureText: showPassword,
              validator: validator,
              suffixIcon: IconButton(
                icon: Icon(
                  !showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: ColorManager.grey,
                ),
                onPressed: () {
                  context.read<RemoteAuthenticationCubit>().changeCreateNewPasswordVisibility2();
                },
              ),
            );
          },
        ),
      ],
    );
  }
}