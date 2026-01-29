import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/translation/locale_keys.dart';
import 'package:enmaa/core/components/app_text_field.dart';

class PropertySearchBarComponent extends StatelessWidget {
  final VoidCallback onTap;

  const PropertySearchBarComponent({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          height: context.scale(120),
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorManager.whiteColor,
          ),
          alignment: Alignment.bottomCenter,
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              height: context.scale(70),
              child: AppTextField(
                editable: false,
                width: double.infinity,
                backgroundColor: ColorManager.greyShade,
                hintText: LocaleKeys.searchForProperty.tr(),
                prefixIcon: Icon(Icons.search, color: ColorManager.blackColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
