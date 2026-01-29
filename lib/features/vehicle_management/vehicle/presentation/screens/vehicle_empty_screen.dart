// // vehicle_empty_screen.dart
// import 'package:flutter/material.dart';
// import 'package:easy_localization/easy_localization.dart';
//
// import '../../../../../configuration/managers/color_manager.dart';
// import '../../../../../configuration/managers/font_manager.dart';
// import '../../../../../configuration/managers/style_manager.dart';
// import '../../../../../core/constants/app_assets.dart';
//
//
// class VehicleEmptyScreen extends StatelessWidget {
//   final String alertText1;
//   final String alertText2;
//   final String buttonText;
//   final VoidCallback onTap;
//
//   const VehicleEmptyScreen({
//     required this.alertText1,
//     required this.alertText2,
//     required this.buttonText,
//     required this.onTap,
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               AppAssets.emptyState,
//               width: 120,
//               height: 120,
//             ),
//             const SizedBox(height: 24),
//             Text(
//               alertText1,
//               style: getBoldStyle(
//                 color: ColorManager.blackColor,
//                 fontSize: FontSize.s16,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 8),
//             Text(
//               alertText2,
//               style: getRegularStyle(
//                 color: ColorManager.grey3,
//                 fontSize: FontSize.s14,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: onTap,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: ColorManager.primaryColor,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               ),
//               child: Text(buttonText),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../configuration/managers/color_manager.dart';
import '../../../../../configuration/managers/font_manager.dart';
import '../../../../../configuration/managers/style_manager.dart';
import '../../../../../core/constants/app_assets.dart';

class VehicleEmptyScreen extends StatelessWidget {
  final String alertText1;
  final String alertText2;
  final String buttonText;
  final VoidCallback onTap;

  const VehicleEmptyScreen({
    required this.alertText1,
    required this.alertText2,
    required this.buttonText,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.whiteColor,
      body: Stack(
        children: [
          // Image qui prend tout l'écran
          Positioned.fill(
            child: Image.asset(
              AppAssets.emptyState, // Assurez-vous d'avoir cette image dans vos assets
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // Contenu par-dessus l'image
          Positioned(
            bottom: 40, // Position du bouton en bas
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Bouton "Réinitialiser les filtres"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      buttonText,
                      style: getBoldStyle(
                        color: Colors.white,
                        fontSize: FontSize.s16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}