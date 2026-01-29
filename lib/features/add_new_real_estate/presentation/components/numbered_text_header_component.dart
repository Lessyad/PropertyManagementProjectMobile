import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

import '../../../../configuration/managers/color_manager.dart';
import '../../../../configuration/managers/font_manager.dart';
import '../../../../configuration/managers/style_manager.dart';
import '../../../home_module/home_imports.dart';

class NumberedTextHeaderComponent extends StatelessWidget {
  final String number;
  final String text;

  const NumberedTextHeaderComponent({
    super.key,
    required this.number,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    // Taille de base en fonction de la largeur de l'écran
    final screenWidth = MediaQuery.of(context).size.width;

    // Exemple : on adapte les valeurs selon la largeur
    final circleSize = screenWidth * 0.06; // 6% de la largeur
    final spacing = screenWidth * 0.02; // 2% de la largeur
    final numberFontSize = screenWidth * 0.035;
    final textFontSize = screenWidth * 0.04;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: circleSize,
          height: circleSize,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: getBoldStyle(
                color: ColorManager.primaryColor,
                fontSize: numberFontSize.clamp(12, 18), // min 12, max 18
              ),
            ),
          ),
        ),
        SizedBox(width: spacing),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: textFontSize.clamp(14, 20), // min 14, max 20
            ),
          ),
        ),
      ],
    );
  }
}
