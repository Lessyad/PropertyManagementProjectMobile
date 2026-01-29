import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/core/components/app_bar_component.dart';
import 'package:enmaa/core/components/app_text_field.dart';
import 'package:enmaa/core/components/button_app_component.dart';
import 'package:enmaa/core/components/custom_snack_bar.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:enmaa/core/utils/form_validator.dart';
import 'package:enmaa/features/home_module/home_imports.dart';
import 'package:enmaa/core/translation/locale_keys.dart';

import '../controller/change_password_controller/change_password_cubit.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangePasswordCubit(),
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBarComponent(
              appBarTextMessage: LocaleKeys.changePasswordTitle.tr(),
              showNotificationIcon: false,
              showLocationIcon: false,
              centerText: true,
              showBackIcon: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.currentPasswordLabel.tr(),
                          style: getBoldStyle(color: ColorManager.blackColor, fontSize: FontSize.s16),
                        ),
                        SizedBox(height: context.scale(8)),
                        BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
                          builder: (context, state) {
                            final bool showPassword = state.showCurrentPassword;
                            return AppTextField(
                              hintText: LocaleKeys.currentPasswordHint.tr(),
                              keyboardType: TextInputType.text,
                              borderRadius: 20,
                              padding: EdgeInsets.zero,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  showPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                  color: ColorManager.grey,
                                ),
                                onPressed: () {
                                  context.read<ChangePasswordCubit>().changCurrentPasswordVisibility();
                                },
                              ),
                              obscureText: !showPassword,
                              initialValue: state.currentPassword,
                              validator: (value) => FormValidator.validateRequired(value, fieldName: LocaleKeys.currentPasswordLabel.tr()),
                              onChanged: (value) {
                                context.read<ChangePasswordCubit>().changeCurrentPassword(value);
                              },
                            );
                          },
                        ),
                        SizedBox(height: context.scale(16)),

                        Text(
                          LocaleKeys.newPasswordLabel.tr(),
                          style: getBoldStyle(color: ColorManager.blackColor, fontSize: FontSize.s16),
                        ),
                        SizedBox(height: context.scale(8)),
                        BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
                          builder: (context, state) {
                            final bool showPassword = state.showNewPassword1;
                            return AppTextField(
                              hintText: LocaleKeys.newPasswordHint.tr(),
                              keyboardType: TextInputType.text,
                              borderRadius: 20,
                              padding: EdgeInsets.zero,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  showPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                  color: ColorManager.grey,
                                ),
                                onPressed: () {
                                  context.read<ChangePasswordCubit>().changNewPasswordVisibility1();
                                },
                              ),
                              obscureText: !showPassword,
                              initialValue: state.newPassword,
                              validator: (value) => FormValidator.validatePassword(value),
                              onChanged: (value) {
                                context.read<ChangePasswordCubit>().changeNewPassword(value);
                              },
                            );
                          },
                        ),
                        SizedBox(height: context.scale(16)),

                        Text(
                          LocaleKeys.confirmNewPasswordLabel.tr(),
                          style: getBoldStyle(color: ColorManager.blackColor, fontSize: FontSize.s16),
                        ),
                        SizedBox(height: context.scale(8)),
                        BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
                          builder: (context, state) {
                            final bool showPassword = state.showNewPassword2;
                            return AppTextField(
                              hintText: LocaleKeys.confirmNewPasswordHint.tr(),
                              keyboardType: TextInputType.text,
                              borderRadius: 20,
                              padding: EdgeInsets.zero,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  showPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                  color: ColorManager.grey,
                                ),
                                onPressed: () {
                                  context.read<ChangePasswordCubit>().changNewPasswordVisibility2();
                                },
                              ),
                              obscureText: !showPassword,
                              initialValue: state.confirmPassword,
                              validator: (value) {
                                if (value != state.newPassword) {
                                  return LocaleKeys.passwordsDoNotMatch.tr();
                                }
                                return FormValidator.validateRequired(value, fieldName: LocaleKeys.confirmNewPasswordLabel.tr());
                              },
                              onChanged: (value) {
                                context.read<ChangePasswordCubit>().changeConfirmPassword(value);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Container(
              height: context.scale(88),
              padding: EdgeInsets.symmetric(horizontal: context.scale(16)),
              decoration: BoxDecoration(
                color: ColorManager.whiteColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(context.scale(24)),
                  topRight: Radius.circular(context.scale(24)),
                ),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonAppComponent(
                    width: 171,
                    height: 46,
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: ColorManager.grey3,
                      borderRadius: BorderRadius.circular(context.scale(24)),
                    ),
                    buttonContent: Center(
                      child: Text(
                        LocaleKeys.cancelButton.tr(),
                        style: getMediumStyle(
                          color: ColorManager.blackColor,
                          fontSize: FontSize.s12,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),

                  BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
                    listenWhen: (previous, current) =>
                    previous.changePasswordRequestState != current.changePasswordRequestState,
                    listener: (context, state) {
                      if (state.changePasswordRequestState == RequestState.loaded) {
                        CustomSnackBar.show(
                          context: context,
                          message: LocaleKeys.changePasswordSuccess.tr(),
                          type: SnackBarType.success,
                        );
                        Navigator.pop(context);
                      } else if (state.changePasswordRequestState == RequestState.error) {
                        CustomSnackBar.show(
                          context: context,
                          message: state.changePasswordErrorMessage,
                          type: SnackBarType.error,
                        );
                      }
                    },
                    buildWhen: (previous, current) =>
                    previous.changePasswordRequestState != current.changePasswordRequestState,
                    builder: (context, state) {
                      return ButtonAppComponent(
                        width: 171,
                        height: 46,
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: ColorManager.primaryColor,
                          borderRadius: BorderRadius.circular(context.scale(24)),
                        ),
                        buttonContent: Center(
                          child: state.changePasswordRequestState == RequestState.loading
                              ? CupertinoActivityIndicator(color: ColorManager.whiteColor)
                              : Text(
                            LocaleKeys.saveButton.tr(),
                            style: getBoldStyle(
                              color: ColorManager.whiteColor,
                              fontSize: FontSize.s12,
                            ),
                          ),
                        ),
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<ChangePasswordCubit>().sendChangePasswordRequest();
                          }
                        },
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