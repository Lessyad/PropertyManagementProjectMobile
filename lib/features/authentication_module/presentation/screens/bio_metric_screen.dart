import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/core/components/custom_snack_bar.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../configuration/managers/style_manager.dart';
import '../../../../configuration/routers/route_names.dart';
import '../../../../core/components/button_app_component.dart';
import '../../../../core/services/shared_preferences_service.dart';
import '../../../../core/translation/locale_keys.dart';
import '../controller/biometric_bloc.dart';
import '../controller/biometric_event.dart';
import '../controller/biometric_state.dart';

class BioMetricScreen extends StatefulWidget {
  const BioMetricScreen({super.key});

  @override
  State<BioMetricScreen> createState() => _BioMetricScreenState();
}

class _BioMetricScreenState extends State<BioMetricScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _lineAnimation;
  bool _showSuccessUI = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _lineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    Future.microtask(() {
      context.read<BiometricBloc>().add(AuthenticateWithBiometrics());
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleSuccess() {
    setState(() {
      _showSuccessUI = true;
    });

    _animationController.reset();
    _animationController.forward();
    SharedPreferencesService().setFirstLaunch(false);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, RoutersNames.layoutScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.grey3,
      body: BlocListener<BiometricBloc, BiometricState>(
        listener: (context, state) {
          if (state is BiometricSuccess) {
            _handleSuccess();
          } else if (state is BiometricFailure) {
            CustomSnackBar.show(message: LocaleKeys.authenticationFailed.tr());
          }
        },
        child: BlocBuilder<BiometricBloc, BiometricState>(
          builder: (context, state) {
            if (_showSuccessUI) {
              return _buildSuccessUI();
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error,
                      color: Colors.red,
                      size: context.scale(50),
                    ),
                    const SizedBox(height: 16),
                    ButtonAppComponent(
                      width: context.scale(150),
                      onTap: () {
                        context.read<BiometricBloc>().add(AuthenticateWithBiometrics());
                      },
                      buttonContent: Center(
                        child: Text(
                          LocaleKeys.retryAuthentication.tr(),
                          style: getBoldStyle(
                            color: ColorManager.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildSuccessUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: context.scale(150),
            height: context.scale(150),
            decoration: BoxDecoration(
              color: ColorManager.whiteColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Container(
                width: context.scale(65),
                height: context.scale(65),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green, width: 3),
                ),
                child: Center(
                  child: Icon(
                    Icons.check,
                    size: context.scale(30),
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          AnimatedBuilder(
            animation: _lineAnimation,
            builder: (context, child) {
              return Container(
                width: _lineAnimation.value * context.scale(150),
                height: 5,
                color: Colors.green,
              );
            },
          ),
          const SizedBox(height: 15),
          Text(
            LocaleKeys.authenticationSuccessful.tr(),
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}