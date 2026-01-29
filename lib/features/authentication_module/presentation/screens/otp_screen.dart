import 'dart:async';

import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/features/authentication_module/presentation/controller/remote_authentication_bloc/remote_authentication_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_auth/smart_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../configuration/managers/color_manager.dart';
import '../../../../configuration/managers/font_manager.dart';
import '../../../../configuration/managers/style_manager.dart';
import '../../../../configuration/routers/route_names.dart';
import '../../../../core/components/circular_icon_button.dart';
import '../../../../core/components/custom_snack_bar.dart';
import '../../../../core/components/loading_overlay_component.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/translation/locale_keys.dart';
import '../../../home_module/home_imports.dart';
import 'dart:ui' as ui;
import 'dart:io' show Platform;

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, this.isFromResetPassword = false});

  final bool isFromResetPassword;
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late TextEditingController otpController;
  late final SmsRetriever smsRetriever;
  Timer? _timer;
  int _timeLeft = 120;
  bool _canResend = false;
  bool navigateToHome = true;

  void startTimer() {
    _timeLeft = 120;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        _timer?.cancel();
      }
    });
  }

  String formatTime() {
    int minutes = _timeLeft ~/ 60;
    int seconds = _timeLeft % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    otpController = TextEditingController();
    smsRetriever = SmsRetrieverImpl(SmartAuth.instance);
    startTimer();
  }

  @override
  void dispose() {
    otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void handleResendCode() {
    if (_canResend) {
      final phoneNumber = context.read<RemoteAuthenticationCubit>().state.userPhoneNumber;
      context.read<RemoteAuthenticationCubit>().sendOtp(phoneNumber);
      startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.whiteColor,
      body: BlocBuilder<RemoteAuthenticationCubit, RemoteAuthenticationState>(
        buildWhen: (previous, current) {
          if (previous.verifyOtpRequestState != current.verifyOtpRequestState &&
              current.verifyOtpRequestState != RequestState.loading) {
            if (current.verifyOtpRequestState == RequestState.loaded &&
                current.isOtpVerified &&
                navigateToHome) {
              Navigator.pushReplacementNamed(context, RoutersNames.createNewPasswordScreen, arguments: widget.isFromResetPassword);
            } else {
              otpController.clear();
              CustomSnackBar.show(
                context: context,
                message: current.sendOtpErrorMessage,
                type: SnackBarType.error,
              );
            }
          }
          return previous.verifyOtpRequestState != current.verifyOtpRequestState;
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
                              LocaleKeys.enterSecurityCode.tr(),
                              style: getBoldStyle(color: ColorManager.blackColor),
                            ),
                            SizedBox(height: context.scale(8)),
                            BlocBuilder<RemoteAuthenticationCubit, RemoteAuthenticationState>(
                              builder: (context, state) {
                                final String userPhoneNumber = state.userPhoneNumber;
                                return Text.rich(TextSpan(
                                  children: [
                                    TextSpan(
                                      text: LocaleKeys.codeSentTo.tr(),
                                      style: getMediumStyle(
                                        color: ColorManager.blackColor,
                                        fontSize: FontSize.s12,
                                      ),
                                    ),
                                    TextSpan(
                                      text: userPhoneNumber,
                                      style: getMediumStyle(
                                        color: ColorManager.blackColor,
                                        fontSize: FontSize.s12,
                                      ),
                                    ),
                                  ],
                                ));
                              },
                            ),
                            SizedBox(height: context.scale(24)),
                            Center(
                              child: Directionality(
                                textDirection: ui.TextDirection.ltr,
                                child: Pinput(
                                  smsRetriever: smsRetriever,
                                  controller: otpController,
                                  length: 6,
                                  defaultPinTheme: PinTheme(
                                    width: context.scale(48),
                                    height: context.scale(44),
                                    decoration: BoxDecoration(
                                      color: ColorManager.greyShade,
                                      borderRadius: BorderRadius.circular(context.scale(4)),
                                    ),
                                  ),
                                  focusedPinTheme: PinTheme(
                                    width: context.scale(58),
                                    height: context.scale(54),
                                    decoration: BoxDecoration(
                                      color: ColorManager.greyShade,
                                      borderRadius: BorderRadius.circular(context.scale(4)),
                                    ),
                                  ),
                                  submittedPinTheme: PinTheme(
                                    width: context.screenWidth * .15,
                                    height: context.screenWidth * .15,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: ColorManager.primaryColor.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                  showCursor: true,
                                  keyboardType: TextInputType.number,
                                  onCompleted: (verificationCode) {
                                    context.read<RemoteAuthenticationCubit>().verifyOtp(verificationCode);
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: context.scale(12)),
                            Row(
                              children: [
                                Text(
                                  formatTime(),
                                  style: getBoldStyle(
                                    color: ColorManager.blackColor,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  LocaleKeys.didNotReceiveCode.tr(),
                                  style: getMediumStyle(
                                    fontSize: FontSize.s12,
                                    color: ColorManager.grey,
                                  ),
                                ),
                                InkWell(
                                  onTap: _canResend ? handleResendCode : null,
                                  child: Text(
                                    LocaleKeys.resend.tr(),
                                    style: getUnderlineBoldStyle(
                                      color: _canResend
                                          ? ColorManager.primaryColor
                                          : ColorManager.primaryColor.withOpacity(0.5),
                                      fontSize: FontSize.s12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (state.verifyOtpRequestState == RequestState.loading) const LoadingOverlayComponent(),
            ],
          );
        },
      ),
    );
  }
}

class SmsRetrieverImpl implements SmsRetriever {
  const SmsRetrieverImpl(this.smartAuth);

  final SmartAuth smartAuth;

  @override
  Future<void> dispose() {
    if (Platform.isAndroid) {
      return smartAuth.removeSmsRetrieverApiListener();
    }
    return Future.value();
  }

  @override
  Future<String?> getSmsCode() async {
    if (Platform.isAndroid) {
      final res = await smartAuth.getSmsWithUserConsentApi();
      if (res.data != null && res.data!.code != null) {
        return res.data!.code;
      }
    }
    return null;
  }

  @override
  bool get listenForMultipleSms => false;
}