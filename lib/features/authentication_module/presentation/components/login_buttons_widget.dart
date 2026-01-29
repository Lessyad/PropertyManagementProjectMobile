import 'package:flutter/material.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/components/button_app_component.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../configuration/routers/route_names.dart';
import '../../../../core/translation/locale_keys.dart';
import 'guest_button_component.dart';

class LoginButtons extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final VoidCallback onLoginPressed;

  const LoginButtons({
    super.key,
    required this.formKey,
    required this.onLoginPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LoginButton(formKey: formKey, onLoginPressed: onLoginPressed),
        SizedBox(height: context.scale(16)),
        GuestButtonComponent(),
        SizedBox(height: context.scale(24)),
        _SignUpSection(),
      ],
    );
  }
}

class _LoginButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final VoidCallback onLoginPressed;

  const _LoginButton({
    required this.formKey,
    required this.onLoginPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonAppComponent(
      width: double.infinity,
      padding: EdgeInsets.zero,
      buttonContent: Center(
        child: Text(
          LocaleKeys.login.tr(),
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
        onLoginPressed();
      },
    );
  }
}

class _SignUpSection extends StatelessWidget {
  const _SignUpSection();

  void _onSignUp(BuildContext context) {
    Navigator.pushNamed(context, RoutersNames.signUpScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          LocaleKeys.noAccount.tr(),
          style: getMediumStyle(
            color: ColorManager.grey,
            fontSize: FontSize.s14,
          ),
        ),
        SizedBox(width: context.scale(2)),
        InkWell(
          onTap: () => _onSignUp(context),
          child: Text(
            LocaleKeys.createOneNow.tr(),
            style: getUnderlineBoldStyle(
              color: ColorManager.primaryColor,
              fontSize: FontSize.s14,
            ),
          ),
        ),
      ],
    );
  }
}