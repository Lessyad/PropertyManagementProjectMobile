import 'package:flutter/material.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../configuration/routers/route_names.dart';
import '../../../../core/components/circular_icon_button.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/translation/locale_keys.dart';
import '../components/sign_up_buttons_widget.dart';
import '../components/sign_up_form_field_widget.dart';
import '../controller/remote_authentication_bloc/remote_authentication_cubit.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.nameRequired.tr();
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
                            LocaleKeys.createAccount.tr(),
                            style: getBoldStyle(color: ColorManager.blackColor),
                          ),
                          SizedBox(height: context.scale(24)),
                          SignUpFormFieldWidget(
                            phoneController: phoneController,
                            validatePhone: _validatePhone,
                            nameController: nameController,
                            validateName: _validateName,
                          ),
                          SizedBox(height: context.scale(24)),
                          SignUpButtonsWidget(
                            formKey: formKey,
                            signUpOnTap: () {
                              if (formKey.currentState?.validate() ?? false) {
                                final authenticationCubit = context.read<RemoteAuthenticationCubit>();
                                authenticationCubit.sendOtp(phoneController.text);
                                authenticationCubit.changeUserName(nameController.text);
                                Navigator.pushNamed(
                                  context,
                                  RoutersNames.otpScreen,
                                );
                              }
                            },
                          ),
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