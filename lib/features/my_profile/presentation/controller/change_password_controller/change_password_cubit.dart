import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:enmaa/core/utils/enums.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/services/dio_service.dart';
import '../../../../../core/services/handle_api_request_service.dart';
import '../../../../../core/services/service_locator.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit() : super(ChangePasswordState());

  void changCurrentPasswordVisibility() {
    emit(state.copyWith(showCurrentPassword: !state.showCurrentPassword));
  }

  void changNewPasswordVisibility1() {
    emit(state.copyWith(showNewPassword1: !state.showNewPassword1));
  }

  void changNewPasswordVisibility2() {
    emit(state.copyWith(showNewPassword2: !state.showNewPassword2));
  }

  void changeCurrentPassword(String value) {
    emit(state.copyWith(currentPassword: value));
  }

  void changeNewPassword(String value) {
    emit(state.copyWith(newPassword: value));
  }

  void changeConfirmPassword(String value) {
    emit(state.copyWith(confirmPassword: value));
  }

  void sendChangePasswordRequest() async {
    emit(state.copyWith(changePasswordRequestState: RequestState.loading));
    final dio = ServiceLocator.getIt<DioService>();

    final result = await HandleRequestService.handleApiCall<void>(
          () async {
        final response = await dio.patch(
          url: ApiConstants.user,
          // data: FormData.fromMap({
          //   "new_password": state.newPassword,
          //   "current_password": state.currentPassword,
          // }),
          data: {
            "new_password": state.newPassword,
            "current_password": state.currentPassword,
          },
          // options: Options(contentType: 'multipart/form-data'),
          options: Options(contentType: 'application/json'),

        );

      },
    );

    result.fold(
          (failure) {
        emit(state.copyWith(
          changePasswordRequestState: RequestState.error,
          changePasswordErrorMessage: failure.message,
        ));
      },
          (_) {
        emit(state.copyWith(
          changePasswordRequestState: RequestState.loaded,
          changePasswordErrorMessage: '',
        ));
      },
    );
  }}

