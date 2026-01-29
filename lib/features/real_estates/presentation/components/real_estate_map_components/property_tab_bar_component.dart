import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/translation/locale_keys.dart';
import 'package:enmaa/core/components/custom_tab.dart';

class PropertyTabBarComponent extends StatelessWidget {
  final TabController tabController;

  const PropertyTabBarComponent({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      padding: EdgeInsets.symmetric(
        horizontal: context.scale(8),
        vertical: context.scale(6),
      ),
      controller: tabController,
      indicator: const BoxDecoration(color: Colors.transparent),
      dividerColor: Colors.transparent,
      tabs: [
        CustomTab(
          text: LocaleKeys.forSale.tr(),
          isSelected: tabController.index == 0,
        ),
        CustomTab(
          text: LocaleKeys.forRent.tr(),
          isSelected: tabController.index == 1,
        ),
      ],
    );
  }
}
