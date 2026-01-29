part of 'remote_authentication_cubit.dart';

class RemoteAuthenticationState extends Equatable {
  const RemoteAuthenticationState({
    this.loginRequestState = RequestState.initial,
    this.loginErrorMessage = '',
    this.loginToken = '',
    this.loginPasswordVisibility = false,
    this.userPhoneNumber = '',
    this.sendOtpRequestState = RequestState.initial,
    this.sendOtpErrorMessage = '',
    this.currentOTP ,
    this.verifyOtpRequestState = RequestState.initial,
    this.isOtpVerified = false,
    this.verifyOtpErrorMessage = '',
    this.currentCountryCode =  '+20',
    this.createNewPasswordPasswordVisibility1 =  true,
    this.createNewPasswordPasswordVisibility2 =  true,
    this.userName =  '',
    this.signUpRequestState = RequestState.initial,
    this.signUpErrorMessage = '',

    this.resetPasswordRequestState = RequestState.initial,
    this.resetPasswordErrorMessage = '',
    this.enteredOTP = '',
  });

  final RequestState loginRequestState;
  final String loginErrorMessage;
  final String loginToken;

  final RequestState signUpRequestState;
  final String signUpErrorMessage;

  final String userPhoneNumber;
  final OTPResponseEntity? currentOTP;
  final RequestState sendOtpRequestState;
  final String sendOtpErrorMessage;

  final RequestState verifyOtpRequestState;
  final bool isOtpVerified;
  final String verifyOtpErrorMessage;

  final bool loginPasswordVisibility;
  final bool createNewPasswordPasswordVisibility1;
  final bool createNewPasswordPasswordVisibility2;

  final String currentCountryCode;
  final String userName;

  final RequestState resetPasswordRequestState;
  final String resetPasswordErrorMessage;
  final String enteredOTP ;

  RemoteAuthenticationState copyWith({
    RequestState? loginRequestState,
    String? loginErrorMessage,
    String? loginToken,
    bool? loginPasswordVisibility,
    String? userPhoneNumber,
    RequestState? sendOtpRequestState,
    String? sendOtpErrorMessage,
    OTPResponseEntity? currentOTP,
    RequestState? verifyOtpRequestState,
    bool? isOtpVerified,
    String? verifyOtpErrorMessage,
    String? currentCountryCode,
    bool? createNewPasswordPasswordVisibility1,
    bool? createNewPasswordPasswordVisibility2,
    String? userName,
    RequestState? signUpRequestState,
    String? signUpErrorMessage,

    RequestState? resetPasswordRequestState,
    String? resetPasswordErrorMessage,
    String? enteredOTP,
  }) {
    return RemoteAuthenticationState(
      loginRequestState: loginRequestState ?? this.loginRequestState,
      loginErrorMessage: loginErrorMessage ?? this.loginErrorMessage,
      loginToken: loginToken ?? this.loginToken,
      loginPasswordVisibility:
      loginPasswordVisibility ?? this.loginPasswordVisibility,
      userPhoneNumber: userPhoneNumber ?? this.userPhoneNumber,
      sendOtpRequestState: sendOtpRequestState ?? this.sendOtpRequestState,
      sendOtpErrorMessage: sendOtpErrorMessage ?? this.sendOtpErrorMessage,
      currentOTP: currentOTP ?? this.currentOTP,
      verifyOtpRequestState: verifyOtpRequestState ?? this.verifyOtpRequestState,
      isOtpVerified: isOtpVerified ?? this.isOtpVerified,
      verifyOtpErrorMessage: verifyOtpErrorMessage ?? this.verifyOtpErrorMessage,
      currentCountryCode: currentCountryCode ?? this.currentCountryCode,
      createNewPasswordPasswordVisibility1: createNewPasswordPasswordVisibility1 ?? this.createNewPasswordPasswordVisibility1,
      createNewPasswordPasswordVisibility2: createNewPasswordPasswordVisibility2 ?? this.createNewPasswordPasswordVisibility2,
      userName: userName ?? this.userName,
      signUpRequestState: signUpRequestState ?? this.signUpRequestState,
      signUpErrorMessage: signUpErrorMessage ?? this.signUpErrorMessage,

      resetPasswordRequestState: resetPasswordRequestState ?? this.resetPasswordRequestState,
      resetPasswordErrorMessage: resetPasswordErrorMessage ?? this.resetPasswordErrorMessage,

      enteredOTP: enteredOTP ?? this.enteredOTP,
    );
  }

  @override
  List<Object?> get props => [
    loginRequestState,
    loginErrorMessage,
    loginToken,
    loginPasswordVisibility,
    userPhoneNumber,
    sendOtpRequestState,
    sendOtpErrorMessage,
    currentOTP,
    verifyOtpRequestState,
    isOtpVerified,
    verifyOtpErrorMessage,
    currentCountryCode,
    createNewPasswordPasswordVisibility1,
    createNewPasswordPasswordVisibility2,
    userName,
    signUpRequestState,
    signUpErrorMessage,
    resetPasswordRequestState,
    resetPasswordErrorMessage,
    enteredOTP ,
  ];
}