import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/extensions/request_states_extension.dart';
import 'package:enmaa/features/authentication_module/data/models/reset_password_request_model.dart';
import 'package:enmaa/features/authentication_module/data/models/sign_up_request_model.dart';
import 'package:enmaa/features/authentication_module/presentation/controller/remote_authentication_bloc/remote_authentication_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../configuration/managers/color_manager.dart';
import '../../../../configuration/managers/style_manager.dart';
import '../../../../configuration/routers/route_names.dart';
import '../../../../core/components/button_app_component.dart';
import '../../../../core/components/circular_icon_button.dart';
import '../../../../core/components/custom_snack_bar.dart';
import '../../../../core/components/loading_overlay_component.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/translation/locale_keys.dart';
import '../../../home_module/home_imports.dart';
import '../components/create_new_password_form_fields_widget.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key, this.isFromResetPassword = false});
  final bool isFromResetPassword;

  @override
  State<CreateNewPasswordScreen> createState() => _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController1 = TextEditingController();
  final _passwordController2 = TextEditingController();

  @override
  void dispose() {
    _passwordController1.dispose();
    _passwordController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.whiteColor,
      body: BlocBuilder<RemoteAuthenticationCubit, RemoteAuthenticationState>(
        buildWhen: (previous, current) {
          if (previous.signUpRequestState != current.signUpRequestState) {
            if (current.signUpRequestState.isLoaded) {
              Navigator.of(context, rootNavigator: true).pushReplacementNamed(RoutersNames.layoutScreen);
              CustomSnackBar.show(
                context: context,
                message: LocaleKeys.accountCreatedSuccessfully.tr(),
                type: SnackBarType.success,
              );
            } else if (current.signUpRequestState.isError) {
              String errorMessage = current.signUpErrorMessage;
              
              // Message spécifique pour l'utilisateur déjà existant
              if (errorMessage.contains('Un utilisateur avec ce numéro existe déjà') || 
                  errorMessage.contains('User with this phone number already exists')) {
                errorMessage = 'Un compte existe déjà avec ce numéro. Veuillez vous connecter.';
              }
              
              CustomSnackBar.show(
                context: context,
                message: errorMessage,
                type: SnackBarType.error,
              );
            }
          }

          if (previous.resetPasswordRequestState != current.resetPasswordRequestState) {
            if (current.resetPasswordRequestState.isLoaded) {
              Navigator.of(context).pushReplacementNamed(RoutersNames.loginScreen);
              CustomSnackBar.show(
                context: context,
                message: LocaleKeys.passwordChangedSuccessfully.tr(),
                type: SnackBarType.success,
              );
            } else if (current.resetPasswordRequestState.isError) {
              CustomSnackBar.show(
                context: context,
                message: current.resetPasswordErrorMessage,
                type: SnackBarType.error,
              );
            }
          }

          return previous.signUpRequestState != current.signUpRequestState ||
              previous.resetPasswordRequestState != current.resetPasswordRequestState;
        },
        builder: (context, state) {
          return Stack(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.isFromResetPassword
                                  ? LocaleKeys.resetPassword.tr()
                                  : LocaleKeys.createPassword.tr(),
                              style: getBoldStyle(color: ColorManager.blackColor),
                            ),
                            SizedBox(height: context.scale(8)),
                            Text(
                              widget.isFromResetPassword
                                  ? LocaleKeys.createNewPasswordHint.tr()
                                  : LocaleKeys.createStrongPasswordHint.tr(),
                              style: getMediumStyle(color: ColorManager.blackColor, fontSize: FontSize.s12),
                            ),
                            SizedBox(height: context.scale(24)),
                            Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    widget.isFromResetPassword
                                        ? LocaleKeys.newPassword.tr()
                                        : LocaleKeys.signUp.tr(),
                                    style: getBoldStyle(color: ColorManager.blackColor),
                                  ),
                                  SizedBox(height: context.scale(24)),
                                  CreateNewPasswordFormFieldsWidget(
                                    passwordController1: _passwordController1,
                                    passwordController2: _passwordController2,
                                  ),
                                  SizedBox(height: context.scale(24)),
                                  ButtonAppComponent(
                                    width: double.infinity,
                                    padding: EdgeInsets.zero,
                                    buttonContent: Center(
                                      child: Text(
                                        LocaleKeys.confirm.tr(),
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
                                      if (_formKey.currentState?.validate() ?? false) {
                                        final authBloc = context.read<RemoteAuthenticationCubit>();
                                        SignUpRequestModel signUpRequestModel = SignUpRequestModel(
                                          password: _passwordController1.text,
                                          name: authBloc.state.userName,
                                          phone: authBloc.state.userPhoneNumber,
                                          code: authBloc.state.enteredOTP,
                                        );

                                        if (widget.isFromResetPassword) {
                                          ResetPasswordRequestModel resetPasswordRequestModel =
                                          ResetPasswordRequestModel(
                                            password1: _passwordController1.text,
                                            password2: _passwordController2.text,
                                            phone: authBloc.state.userPhoneNumber,
                                            code: state.enteredOTP,
                                          );
                                          authBloc.resetPassword(resetPasswordRequestModel);
                                        } else {
                                          authBloc.signUp(signUpRequestModel);
                                        }
                                      }
                                    },
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (state.signUpRequestState.isLoading || state.resetPasswordRequestState.isLoading)
                const LoadingOverlayComponent(),
            ],
          );
        },
      ),
    );
  }
}