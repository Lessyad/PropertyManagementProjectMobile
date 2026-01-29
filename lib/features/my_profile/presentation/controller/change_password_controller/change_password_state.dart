part of 'change_password_cubit.dart';

class ChangePasswordState extends Equatable {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  final RequestState changePasswordRequestState;
  final String changePasswordErrorMessage;

  final bool showCurrentPassword , showNewPassword1 , showNewPassword2;

  const ChangePasswordState({
    this.currentPassword = '',
     this.newPassword = '',
     this.confirmPassword = '',
     this.changePasswordRequestState = RequestState.initial,
     this.changePasswordErrorMessage = '',
    this.showCurrentPassword = false,
    this.showNewPassword1 = false,
    this.showNewPassword2 = false,
  });


  ChangePasswordState copyWith({
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
    RequestState? changePasswordRequestState,
    String? changePasswordErrorMessage,
    bool? showCurrentPassword,
    bool? showNewPassword1,
    bool? showNewPassword2,

  }) {
    return ChangePasswordState(
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      changePasswordRequestState: changePasswordRequestState ?? this.changePasswordRequestState,
      changePasswordErrorMessage: changePasswordErrorMessage ?? this.changePasswordErrorMessage,
      showCurrentPassword: showCurrentPassword ?? this.showCurrentPassword,
      showNewPassword1: showNewPassword1 ?? this.showNewPassword1,
      showNewPassword2: showNewPassword2 ?? this.showNewPassword2,
    );
  }

  @override
  List<Object> get props => [
    currentPassword,
    newPassword,
    confirmPassword,
    changePasswordRequestState,
    changePasswordErrorMessage,
    showCurrentPassword,
    showNewPassword1,
    showNewPassword2,
  ];
}
