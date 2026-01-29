import '../../../../core/constants/json_keys.dart';
import '../../domain/entities/login_request_entity.dart';

class LoginRequestModel extends LoginRequestEntity {
  const LoginRequestModel({
    required super.password,
    required super.phone,
  });


  Map<String, dynamic> toJson() {
    return {
      JsonKeys.password: password,
      JsonKeys.phoneNumber: phone,
    };
  }
}