import 'package:flutter/material.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:easy_localization/easy_localization.dart'; // Add this import
import 'package:enmaa/core/translation/locale_keys.dart'; // Add this import

class ExpandableDescriptionBox extends StatefulWidget {
  final String description;

  const ExpandableDescriptionBox({super.key, required this.description});

  @override
  State<ExpandableDescriptionBox> createState() => _ExpandableDescriptionBoxState();
}

class _ExpandableDescriptionBoxState extends State<ExpandableDescriptionBox> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.scale(12)),
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDescriptionText(),
          SizedBox(height: context.scale(4)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Text(
                  _isExpanded ? LocaleKeys.readLess.tr() : LocaleKeys.readMore.tr(),
                  style: TextStyle(
                    color: ColorManager.yellowColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    decorationColor: ColorManager.yellowColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionText() {
    return Text(
      widget.description,
      textAlign: TextAlign.right,
      style: getRegularStyle(
        color: const Color(0xFF474747),
        fontSize: FontSize.s10,
      ),
      maxLines: _isExpanded ? null : 3,
      overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
    );
  }
}