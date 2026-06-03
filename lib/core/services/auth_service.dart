import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:enmaa/configuration/routers/route_names.dart';
import 'package:enmaa/core/components/custom_snack_bar.dart';
import 'package:enmaa/core/components/need_to_login_component.dart';
import 'package:enmaa/core/services/shared_preferences_service.dart';
import 'package:enmaa/core/translation/locale_keys.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  bool _isLoggingOut = false;

  /// Source de vérité réactive pour l'état d'authentification.
  /// Tous les widgets qui dépendent de isAuth doivent écouter ce notifier.
  static final ValueNotifier<bool> authStateNotifier = ValueNotifier<bool>(
    SharedPreferencesService().accessToken.isNotEmpty,
  );

  bool get isAuthenticated => SharedPreferencesService().accessToken.isNotEmpty;

  /// Called automatically when a 401 (token expired) response is received.
  /// Clears stored credentials, shows a message, and redirects to the home screen.
  Future<void> performLogout() async {
    if (_isLoggingOut || !isAuthenticated) return;
    _isLoggingOut = true;

    try {
      await SharedPreferencesService().clearCachedData();
      authStateNotifier.value = false;

      CustomSnackBar.show(
        message: LocaleKeys.errorTokenExpired.tr(),
        type: SnackBarType.error,
      );

      final navigatorState = LoginBottomSheet.navigatorKey.currentState;
      if (navigatorState != null) {
        navigatorState.pushNamedAndRemoveUntil(
          RoutersNames.layoutScreen,
          (route) => false,
        );
      } else {
        log('AuthService: navigatorKey not ready, cannot redirect');
      }
    } catch (e) {
      log('AuthService logout error: $e');
    } finally {
      _isLoggingOut = false;
    }
  }
}
