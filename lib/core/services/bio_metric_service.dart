import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/translation/locale_keys.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

abstract class BaseBiometricService {
  Future<bool> isBiometricAvailable();
  Future<bool> isDeviceSecure();
  Future<bool> authenticateWithBiometrics();
  Future<bool> hasAnyRealSecurity();
}

class BiometricService implements BaseBiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  Future<bool> isBiometricAvailable() async {
    try {
      final result = await _localAuth.canCheckBiometrics;
      return result;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isDeviceSecure() async {
    try {
      final result = await _localAuth.isDeviceSupported();
      return result;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> hasAnyRealSecurity() async {
    try {
      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      final isDeviceSupported = await isDeviceSecure();
      final hasSecurity = availableBiometrics.isNotEmpty || isDeviceSupported;
      return hasSecurity;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> authenticateWithBiometrics() async {
    try {
      final hasRealSecurity = await hasAnyRealSecurity();
      if (!hasRealSecurity) {
        return false;
      }

      final result = await _localAuth.authenticate(
        localizedReason: LocaleKeys.authenticateToAccessTheApp.tr(),
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
      return result;
    } on PlatformException catch (e) {
      if (e.code == 'NotAvailable' || e.code == 'NotEnrolled' || e.code == 'PasscodeNotSet') {
        return false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}

class BiometricNotSetupException implements Exception {
  final String message;
  BiometricNotSetupException(this.message);

  @override
  String toString() => message;
}