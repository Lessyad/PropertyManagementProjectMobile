import 'package:enmaa/features/authentication_module/domain/entities/reset_password_request_entity.dart';
import 'package:enmaa/features/authentication_module/domain/entities/sign_up_request_entity.dart';

import '../../../../core/constants/json_keys.dart';

class ResetPasswordRequestModel extends ResetPasswordRequestEntity{


  const ResetPasswordRequestModel({

   required super.phone, required super.code, required super.password1, required super.password2}) ;

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phone,
      'code': code,
      'password': password1,
      'password_confirm': password2,
    };
  }
}