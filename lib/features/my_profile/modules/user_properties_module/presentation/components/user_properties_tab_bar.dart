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
      case BookingStatus.sold:
        return ColorManager.redColor;
    }
  }

   String _getIconForStatus(BookingStatus status) {
    switch (status) {
      case BookingStatus.available:
        return AppAssets.completedIcon;
      case BookingStatus.reserved:
        return AppAssets.lockIcon;
      case BookingStatus.sold:
        return AppAssets.reservedIcon;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        height: context.scale(44),
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
            fontSize: 12,
            overflow: TextOverflow.ellipsis,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 12,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: onTabChanged,
          tabs: tabStatuses.map((status) {
            return Tab(
              child: Container(
                width: context.scale(86),
                height: context.scale(32),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgImageComponent(
                      width: 12,
                      height: 12,
                      iconPath: _getIconForStatus(status),
                      color: tabController.index == tabStatuses.indexOf(status)
                          ? ColorManager.whiteColor
                          : ColorManager.blackColor,
                    ),
                    const SizedBox(width: 4),

                    Expanded(
                      child: Text(
                        status.getName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
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
