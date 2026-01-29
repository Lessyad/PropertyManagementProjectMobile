import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:enmaa/core/constants/local_keys.dart';
import 'package:enmaa/core/services/shared_preferences_service.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:enmaa/features/authentication_module/data/models/reset_password_request_model.dart';
import 'package:enmaa/features/authentication_module/data/models/sign_up_request_model.dart';
import 'package:enmaa/features/authentication_module/domain/use_cases/remote_login_use_case.dart';
import 'package:enmaa/features/authentication_module/domain/use_cases/send_otp_use_case.dart';
import 'package:enmaa/features/authentication_module/domain/use_cases/sign_up_use_case.dart';
import 'package:enmaa/features/authentication_module/domain/use_cases/verify_otp_use_case.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../data/models/login_request_model.dart';
import '../../../../../core/services/fcm_token_update_service.dart';
import '../../../domain/entities/otp_response_entity.dart';
import '../../../domain/use_cases/reset_password_use_case.dart';

part 'remote_authencation_state.dart';

class RemoteAuthenticationCubit extends Cubit<RemoteAuthenticationState> {
  final RemoteLoginUseCase _remoteLoginUseCase;
  final SignUpUseCase _signUpUseCase;

  final SendOtpUseCase _sendOtpUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase ;

  RemoteAuthenticationCubit(
    this._remoteLoginUseCase,
    this._sendOtpUseCase,
    this._verifyOtpUseCase,
    this._signUpUseCase,
    this._resetPasswordUseCase,
  ) : super(const RemoteAuthenticationState());

  void changeLoginPasswordVisibility() {
    emit(state.copyWith(
        loginPasswordVisibility: !state.loginPasswordVisibility));
  }

  void changeCreateNewPasswordVisibility1() {
    emit(state.copyWith(
        createNewPasswordPasswordVisibility1:
            !state.createNewPasswordPasswordVisibility1));
  }

  void changeCreateNewPasswordVisibility2() {
    emit(state.copyWith(
        createNewPasswordPasswordVisibility2:
            !state.createNewPasswordPasswordVisibility2));
  }

  void changeUserName(String userName) {
    emit(state.copyWith(userName: userName));
  }

  void changeUserPhoneNumber(String phoneNumber) {
    emit(state.copyWith(userPhoneNumber: phoneNumber));
  }

  Future<void>resetPassword(ResetPasswordRequestModel resetPasswordBody) async {
    emit(state.copyWith(resetPasswordRequestState: RequestState.loading));

    final Either<Failure, void> result = await _resetPasswordUseCase(resetPasswordBody);

    result.fold(
      (failure) => emit(state.copyWith(
          resetPasswordRequestState: RequestState.error,
          resetPasswordErrorMessage: failure.message)),
      (_) {
        emit(state.copyWith(
            resetPasswordRequestState: RequestState.loaded));
      },
    );
  }

  Future<void> remoteLogin(LoginRequestModel loginBody) async {
    emit(state.copyWith(loginRequestState: RequestState.loading));

    final Either<Failure, String> result = await _remoteLoginUseCase(loginBody);

    result.fold(
      (failure) => emit(state.copyWith(
          loginRequestState: RequestState.error,
          loginErrorMessage: failure.message)),
      (token){
        SharedPreferencesService().storeValue(LocalKeys.countryCodeNumber, state.currentCountryCode);
        emit(state.copyWith(
            loginRequestState: RequestState.loaded, loginToken: token));
        _updateFcmTokenAfterLogin();
      },
    );
  }

  Future<void> signUp(SignUpRequestModel signUpBody) async {
    emit(state.copyWith(signUpRequestState: RequestState.loading));

    final Either<Failure, String> result = await _signUpUseCase(signUpBody);

    result.fold(
      (failure) => emit(state.copyWith(
          signUpRequestState: RequestState.error,
          signUpErrorMessage: failure.message)),
      (token)
      {
        SharedPreferencesService().storeValue(LocalKeys.countryCodeNumber, state.currentCountryCode);
        emit(state.copyWith(
            signUpRequestState: RequestState.loaded, loginToken: token)) ;
      },
    );
  }

  Future<void> sendOtp(String phoneNumber) async {
    emit(state.copyWith(sendOtpRequestState: RequestState.loading));

    final Either<Failure, OTPResponseEntity> result =
        await _sendOtpUseCase(phoneNumber);

    result.fold(
      (failure) => emit(state.copyWith(
          sendOtpRequestState: RequestState.error,
          sendOtpErrorMessage: failure.message)),
      (otp) => emit(state.copyWith(
          currentOTP: otp,
          sendOtpRequestState: RequestState.loaded,
          userPhoneNumber: phoneNumber)),
    );
  }

  Future<void> verifyOtp(String otp) async {
    emit(state.copyWith(verifyOtpRequestState: RequestState.loading));

    final Either<Failure, bool> result =
        await _verifyOtpUseCase(otp, state.userPhoneNumber);

    result.fold(
      (failure) => emit(state.copyWith(
          verifyOtpRequestState: RequestState.error,
          verifyOtpErrorMessage: failure.message)),
      (isVerified) => emit(state.copyWith(
        enteredOTP: otp,
          verifyOtpRequestState: RequestState.loaded,
          isOtpVerified: isVerified)),
    );
  }

  Future<void> setCountryCode(String countyCode) async {
    emit(state.copyWith(currentCountryCode: countyCode));
  }

  void _updateFcmTokenAfterLogin() {
    print('🚀 [CUBIT] _updateFcmTokenAfterLogin() appelée');
    print('🔄 [CUBIT] Programmation du Future.delayed...');
    Future.delayed(const Duration(milliseconds: 1000), () async {
      try {
        print('🔄 [CUBIT] Future.delayed démarré - Début de la mise à jour du FCM Token après authentification...');
        await FcmTokenUpdateService().updateFcmTokenAfterAuthentication();
        print('✅ [CUBIT] Mise à jour du FCM Token terminée avec succès');
      } catch (e) {
        print('❌ [CUBIT] Erreur lors de la mise à jour du FCM token: $e');
        print('🔍 [CUBIT] Stack trace: $e');
        print('🔍 [CUBIT] Stack trace détaillé: ${StackTrace.current}');
      }
    });
    print('🔄 [CUBIT] Future.delayed programmé avec succès');
  }
}
