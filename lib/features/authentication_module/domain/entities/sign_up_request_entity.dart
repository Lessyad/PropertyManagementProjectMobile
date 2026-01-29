import 'package:equatable/equatable.dart';

class SignUpRequestEntity extends Equatable{
  final String phone,name,password,code;


  const SignUpRequestEntity({
    required this.phone,
    required this.name,
    required this.password,
    required this.code,
  });

  @override
  List<Object?> get props => [phone, name , password, code];
}