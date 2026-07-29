import 'package:flutter/widgets.dart';

import '../../configuration/routers/route_names.dart';

class PendingAuthNavigationService {
  PendingAuthNavigationService._();

  static String? _routeName;
  static Object? _arguments;

  static void setPendingRoute({
    required String routeName,
    Object? arguments,
  }) {
    _routeName = routeName;
    _arguments = arguments;
  }

  static void clear() {
    _routeName = null;
    _arguments = null;
  }

  static void navigateAfterAuth(BuildContext context) {
    final routeName = _routeName;
    final arguments = _arguments;
    clear();

    final navigator = Navigator.of(context, rootNavigator: true);
    navigator.pushNamedAndRemoveUntil(
      RoutersNames.layoutScreen,
      (route) => false,
      arguments: routeName == null
          ? null
          : {
              'pendingRouteName': routeName,
              'pendingArguments': arguments,
            },
    );
  }
}
