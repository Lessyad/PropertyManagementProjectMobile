import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../configuration/managers/color_manager.dart';
import '../../../../../configuration/managers/font_manager.dart';
import '../../../../../configuration/managers/style_manager.dart';
import '../../../../../core/translation/locale_keys.dart';
import '../controller/auth_helper.dart';

class VehiclePaymentAuthWidget extends StatelessWidget {
  final VoidCallback onLoginPressed;
  final VoidCallback? onCancel;

  const VehiclePaymentAuthWidget({
    Key? key,
    required this.onLoginPressed,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icône d'authentification
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: ColorManager.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_outline,
              size: 40,
              color: ColorManager.primaryColor,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Titre
          Text(
            tr(LocaleKeys.vehicle_payment_requires_login),
            style: getBoldStyle(
              color: ColorManager.primaryColor,
              fontSize: FontSize.s18,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          // Message
          Text(
            tr(LocaleKeys.please_login_to_pay),
            style: getRegularStyle(
              color: ColorManager.grey,
              fontSize: FontSize.s14,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          // Boutons
          Row(
            children: [
              if (onCancel != null) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: ColorManager.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      tr(LocaleKeys.cancel),
                      style: getMediumStyle(
                        color: ColorManager.primaryColor,
                        fontSize: FontSize.s14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: ElevatedButton(
                  onPressed: onLoginPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    tr(LocaleKeys.redirect_to_login),
                    style: getMediumStyle(
                      color: Colors.white,
                      fontSize: FontSize.s14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class VehiclePaymentAuthGuard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onLoginPressed;
  final VoidCallback? onCancel;

  const VehiclePaymentAuthGuard({
    Key? key,
    required this.child,
    this.onLoginPressed,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Vérifier l'authentification
    if (!AuthHelper.isUserAuthenticated()) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: VehiclePaymentAuthWidget(
            onLoginPressed: onLoginPressed ?? () {
              // Navigation vers l'écran de connexion
              Navigator.of(context).pushNamed('/login');
            },
            onCancel: onCancel ?? () {
              Navigator.of(context).pop();
            },
          ),
        ),
      );
    }

    // Si l'utilisateur est authentifié, afficher le contenu normal
    return child;
  }
}
