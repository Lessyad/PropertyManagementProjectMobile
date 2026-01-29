import 'package:equatable/equatable.dart';

class LoginRequestEntity extends Equatable {
  const LoginRequestEntity({
    required this.password,
    required this.phone,
  });
  final String phone, password;

  @override
  List<Object?> get props => [phone, password];
}
