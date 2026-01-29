import 'package:equatable/equatable.dart';

class OTPResponseEntity extends Equatable {
  final String phoneNumber , expiresAt ;

  const OTPResponseEntity({
    required this.phoneNumber,
    required this.expiresAt,
  });

  @override
  List<Object?> get props => [
    phoneNumber,
    expiresAt,
  ];

}