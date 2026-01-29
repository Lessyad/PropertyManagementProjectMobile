import 'package:enmaa/core/services/bio_metric_service.dart';

import '../../../../../core/services/dio_service.dart';

abstract class BaseAuthenticationLocalDataSource {
  Future<bool> loginUsingLocalAuthentication();

}

class AuthenticationLocalDataSource extends BaseAuthenticationLocalDataSource {

  AuthenticationLocalDataSource();

  @override
  Future<bool> loginUsingLocalAuthentication()async {

    BiometricService biometricService = BiometricService();

    return await biometricService.authenticateWithBiometrics() ;
  }
}