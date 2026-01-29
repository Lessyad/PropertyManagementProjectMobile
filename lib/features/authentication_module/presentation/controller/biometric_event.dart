import 'package:equatable/equatable.dart';

abstract class BiometricEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthenticateWithBiometrics extends BiometricEvent {}
