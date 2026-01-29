import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/components/circular_icon_button.dart';
import 'package:enmaa/core/components/loading_overlay_component.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:enmaa/features/authentication_module/presentation/controller/remote_authentication_bloc/remote_authentication_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../configuration/routers/route_names.dart';
import '../../../../core/components/custom_snack_bar.dart';
import '../../../../core/translation/locale_keys.dart';
import '../../data/models/login_request_model.dart';
import '../components/login_buttons_widget.dart';
import '../components/login_form_fields_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController(text: '+20');
  final _passwordController = TextEditingController();
  bool navigateToNextScreen = true;

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.phoneRequired.tr();
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.passwordRequired.tr();
    }
    return null;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.whiteColor,
      body: BlocBuilder<RemoteAuthenticationCubit, RemoteAuthenticationState>(
        buildWhen: (previous, current) {
          if (previous.loginRequestState != current.loginRequestState &&
              current.loginRequestState != RequestState.loading) {
            if (current.loginRequestState == RequestState.loaded && navigateToNextScreen) {
              navigateToNextScreen = false;
              Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
                RoutersNames.layoutScreen,
                    (route) => false,
              );
            } else if (current.loginRequestState == RequestState.error) {
              CustomSnackBar.show(
                context: context,
                message: current.loginErrorMessage,
                type: SnackBarType.error,
              );
            }
          }

          return previous.loginRequestState != current.loginRequestState;
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
                        iconPath: AppAssets.closeIcon,
                        backgroundColor: ColorManager.greyShade,
                        containerSize: 40,
                        iconSize: 16,
                        padding: const EdgeInsets.all(8),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pushNamed(RoutersNames.layoutScreen);
                        },
                      ),
                    ),
                    PositionedDirectional(
                      top: context.scale(24 + 40 + 24),
                      end: 0,
                      start: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: context.scale(16)),
                        child: _buildLoginContent(),
                      ),
                    ),
                  ],
                ),
              ),
              if (state.loginRequestState == RequestState.loading) const LoadingOverlayComponent(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoginContent() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LocaleKeys.login.tr(),
            style: getBoldStyle(color: ColorManager.blackColor),
          ),
          SizedBox(height: context.scale(24)),
          LoginFormFields(
            phoneController: _phoneController,
            passwordController: _passwordController,
            validatePhone: _validatePhone,
            validatePassword: _validatePassword,
          ),
          SizedBox(height: context.scale(24)),
          LoginButtons(
            formKey: _formKey,
            onLoginPressed: () {
              if (_formKey.currentState!.validate()) {
                final loginRequestBody = LoginRequestModel(
                  phone: _phoneController.text.trim(),
                  password: _passwordController.text.trim(),
                );
                context.read<RemoteAuthenticationCubit>().remoteLogin(loginRequestBody);
              }
            },
          ),
        ],
      ),
    );
  }
}