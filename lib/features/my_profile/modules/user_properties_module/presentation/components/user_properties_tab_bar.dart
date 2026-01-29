import 'package:enmaa/core/components/svg_image_component.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/extensions/booking_status_extension.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:enmaa/core/utils/enums.dart';
import '../../../../../../configuration/managers/color_manager.dart';

class UserPropertiesTabBar extends StatelessWidget {
  final TabController tabController;
  final List<BookingStatus> tabStatuses;
  final Function(int) onTabChanged;

  const UserPropertiesTabBar({
    super.key,
    required this.tabController,
    required this.tabStatuses,
    required this.onTabChanged,
  });

   Color _getColorForStatus(BookingStatus status) {
    switch (status) {
      case BookingStatus.available:
        return ColorManager.greenColor;
      case BookingStatus.reserved:
        return ColorManager.grey2;
    }
  }

   String _getIconForStatus(BookingStatus status) {
    switch (status) {
      case BookingStatus.available:
        return AppAssets.completedIcon;
      case BookingStatus.reserved:
        return AppAssets.lockIcon;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: context.scale(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: TabBar(
          controller: tabController,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: _getColorForStatus(tabStatuses[tabController.index]),
          ),
          indicatorPadding: const EdgeInsets.all(6),
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: ColorManager.whiteColor,
          unselectedLabelColor: ColorManager.blackColor,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            overflow: TextOverflow.ellipsis,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: onTabChanged,
          tabs: tabStatuses.map((status) {
            return Tab(
              child: Container(
                width: context.scale(103),
                height: context.scale(36),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgImageComponent(
                      width: 20,
                      height: 20,
                      iconPath: _getIconForStatus(status),
                      color: tabController.index == tabStatuses.indexOf(status)
                          ? ColorManager.whiteColor
                          : ColorManager.blackColor,
                    ),
                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        status.getName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: tabController.index == tabStatuses.indexOf(status)
                              ? ColorManager.whiteColor
                              : ColorManager.blackColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}