import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/translation/locale_keys.dart';
import 'package:enmaa/core/components/app_text_field.dart';

class PropertySearchBarComponent extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback? onBack;

  const PropertySearchBarComponent({
    Key? key,
    required this.onTap,
    this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(context.scale(16)),
          bottomRight: Radius.circular(context.scale(16)),
        ),
        child: Container(
          color: ColorManager.whiteColor,
          padding: EdgeInsets.only(
            top: topPadding + context.scale(8),
            bottom: context.scale(8),
            left: context.scale(8),
            right: context.scale(8),
          ),
          child: Row(
            children: [
              if (onBack != null)
                GestureDetector(
                  onTap: onBack,
                  child: Container(
                    width: context.scale(38),
                    height: context.scale(38),
                    margin: EdgeInsets.only(right: context.scale(6)),
                    decoration: BoxDecoration(
                      color: ColorManager.greyShade,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: context.scale(16),
                      color: ColorManager.primaryColor,
                    ),
                  ),
                ),
              Expanded(
                child: InkWell(
                  onTap: onTap,
                  child: AppTextField(
                    editable: false,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: context.scale(8)),
                    backgroundColor: ColorManager.greyShade,
                    hintText: LocaleKeys.searchForProperty.tr(),
                    prefixIcon:
                        Icon(Icons.search, color: ColorManager.blackColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
