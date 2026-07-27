import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../configuration/managers/color_manager.dart';
import '../../../../configuration/managers/font_manager.dart';
import '../../../../configuration/managers/style_manager.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/translation/locale_keys.dart';

/// Carte de politique repliable : en-tête (titre + icône) puis un aperçu du
/// contenu limité à [previewLength] caractères, avec un bouton
/// "Lire plus" / "Lire moins" pour dérouler le reste.
class CollapsiblePolicyCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final String content;

  /// Nombre de caractères affichés en aperçu quand la carte est repliée.
  final int previewLength;

  const CollapsiblePolicyCard({
    super.key,
    required this.title,
    required this.icon,
    required this.content,
    this.previewLength = 80,
  });

  @override
  State<CollapsiblePolicyCard> createState() => _CollapsiblePolicyCardState();
}

class _CollapsiblePolicyCardState extends State<CollapsiblePolicyCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final String content = widget.content;
    final bool showToggle = content.length > widget.previewLength;
    final String visibleText = (!_expanded && showToggle)
        ? '${content.substring(0, widget.previewLength).trimRight()}…'
        : content;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: context.scale(16)),
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
        borderRadius: BorderRadius.circular(context.scale(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // En-tête
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: context.scale(20),
              vertical: context.scale(14),
            ),
            decoration: BoxDecoration(
              color: ColorManager.primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(context.scale(16)),
                topRight: Radius.circular(context.scale(16)),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  color: ColorManager.whiteColor,
                  size: context.scale(18),
                ),
                SizedBox(width: context.scale(10)),
                Expanded(
                  child: Text(
                    widget.title,
                    softWrap: true,
                    style: getBoldStyle(
                      color: ColorManager.whiteColor,
                      fontSize: FontSize.s15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Contenu — aperçu limité par nombre de caractères, tout si déroulé
          Padding(
            padding: EdgeInsets.all(context.scale(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  visibleText,
                  softWrap: true,
                  style: TextStyle(
                    color: ColorManager.grey,
                    fontSize: FontSize.s14,
                    height: 1.6,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (showToggle) ...[
                  SizedBox(height: context.scale(6)),
                  InkWell(
                    onTap: () => setState(() => _expanded = !_expanded),
                    borderRadius: BorderRadius.circular(context.scale(8)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: context.scale(4)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _expanded
                                ? LocaleKeys.readLess.tr()
                                : LocaleKeys.readMore.tr(),
                            style: getBoldStyle(
                              color: ColorManager.primaryColor,
                              fontSize: FontSize.s13,
                            ),
                          ),
                          SizedBox(width: context.scale(4)),
                          Icon(
                            _expanded
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            color: ColorManager.primaryColor,
                            size: context.scale(20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
