import 'package:enmaa/core/constants/json_keys.dart';
import 'package:enmaa/features/authentication_module/domain/entities/otp_response_entity.dart';

class OTPResponseModel extends OTPResponseEntity{
  const OTPResponseModel({
    required super.phoneNumber,
    required super.expiresAt,
  });

  factory OTPResponseModel.fromJson(Map<String, dynamic> json) {
    return OTPResponseModel(
      phoneNumber: json[JsonKeys.phoneNumber] as String? ?? '',
      expiresAt: json[JsonKeys.expiresAt] as String? ?? '',
    );
  }


}