import 'package:equatable/equatable.dart';

class ResetPasswordRequestEntity extends Equatable{
  final String phone,code,password1 ,password2 ;


  const ResetPasswordRequestEntity({
    required this.phone,
    required this.code,
    required this.password1,
    required this.password2,
  });

  @override
  List<Object?> get props => [phone, code , password1 , password2];
}