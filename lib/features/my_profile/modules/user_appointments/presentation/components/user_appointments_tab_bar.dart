import 'package:enmaa/core/components/svg_image_component.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/extensions/appointment_status_extension.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:enmaa/core/utils/enums.dart';
import '../../../../../../configuration/managers/color_manager.dart';

class UserAppointmentsTabBar extends StatelessWidget {
  final TabController tabController;
  final List<AppointmentStatus> tabStatuses;
  final Function(int) onTabChanged;
  final bool? isDesktopMode;

  const UserAppointmentsTabBar({
    super.key,
    required this.tabController,
    required this.tabStatuses,
    required this.onTabChanged,
    this.isDesktopMode = false,
  });

  // Method to get color based on AppointmentStatus
  Color _getColorForStatus(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.coming:
        return ColorManager.yellowColor;
      case AppointmentStatus.completed:
        return ColorManager.greenColor;
      case AppointmentStatus.cancelled:
        return ColorManager.redColor;
    }
  }

  // Method to get icon path based on AppointmentStatus
  String _getIconForStatus(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.coming:
        return AppAssets.comingIcon;
      case AppointmentStatus.completed:
        return AppAssets.completedIcon;
      case AppointmentStatus.cancelled:
        return AppAssets.cancelledIcon;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;
    final isLargeScreen = screenWidth > 1200;
    final isDesktop = isDesktopMode ?? isLargeScreen;

    // Si mode desktop, on retourne un layout vertical
    if (isDesktop) {
      return _buildDesktopTabBar(context);
    }

    // Mode mobile/tablette
    return _buildMobileTabBar(context, isSmallScreen, screenWidth);
  }

  Widget _buildMobileTabBar(BuildContext context, bool isSmallScreen, double screenWidth) {
    return Padding(
      padding: EdgeInsets.all(isSmallScreen ? 8.0 : 12.0),
      child: Container(
        height: _getTabBarHeight(isSmallScreen, screenWidth),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_getBorderRadius(isSmallScreen)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: isSmallScreen ? 4.0 : 8.0,
              offset: Offset(0, isSmallScreen ? 1.0 : 2.0),
            ),
          ],
        ),
        child: TabBar(
          controller: tabController,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(_getIndicatorBorderRadius(isSmallScreen)),
            color: _getColorForStatus(tabStatuses[tabController.index]),
          ),
          indicatorPadding: EdgeInsets.all(isSmallScreen ? 4.0 : 6.0),
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: ColorManager.whiteColor,
          unselectedLabelColor: ColorManager.blackColor,
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: _getFontSize(isSmallScreen),
            overflow: TextOverflow.ellipsis,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: _getFontSize(isSmallScreen),
            overflow: TextOverflow.ellipsis,
          ),
          onTap: onTabChanged,
          tabs: tabStatuses.map((status) {
            return Tab(
              child: Container(
                width: _getTabWidth(isSmallScreen, screenWidth),
                height: _getTabHeight(isSmallScreen),
                padding: EdgeInsets.symmetric(
                  horizontal: _getTabPaddingHorizontal(isSmallScreen),
                  vertical: _getTabPaddingVertical(isSmallScreen),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon - taille responsive
                    SvgImageComponent(
                      width: _getIconSize(isSmallScreen),
                      height: _getIconSize(isSmallScreen),
                      iconPath: _getIconForStatus(status),
                      color: tabController.index == tabStatuses.indexOf(status)
                          ? ColorManager.whiteColor
                          : ColorManager.blackColor,
                    ),
                    SizedBox(width: _getIconSpacing(isSmallScreen)),
                    // Text - layout adaptatif
                    Flexible(
                      child: Text(
                        status.toName,
                        style: TextStyle(
                          fontSize: _getFontSize(isSmallScreen),
                          fontWeight: tabController.index == tabStatuses.indexOf(status)
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: tabController.index == tabStatuses.indexOf(status)
                              ? ColorManager.whiteColor
                              : ColorManager.blackColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
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

  Widget _buildDesktopTabBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.0,
            offset: const Offset(0, 2.0),
          ),
        ],
      ),
      child: Column(
        children: tabStatuses.asMap().entries.map((entry) {
          final index = entry.key;
          final status = entry.value;
          final isSelected = tabController.index == index;

          return InkWell(
            onTap: () => onTabChanged(index),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              decoration: BoxDecoration(
                color: isSelected ? _getColorForStatus(status).withOpacity(0.1) : Colors.transparent,
                border: Border(
                  left: BorderSide(
                    color: isSelected ? _getColorForStatus(status) : Colors.transparent,
                    width: 4.0,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Icon
                  SvgImageComponent(
                    width: 24,
                    height: 24,
                    iconPath: _getIconForStatus(status),
                    color: isSelected ? _getColorForStatus(status) : ColorManager.blackColor,
                  ),
                  const SizedBox(width: 12),
                  // Text
                  Expanded(
                    child: Text(
                      status.toName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? _getColorForStatus(status) : ColorManager.blackColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: _getColorForStatus(status),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Méthodes utilitaires pour les valeurs responsives

  double _getTabBarHeight(bool isSmallScreen, double screenWidth) {
    if (screenWidth < 400) return 44; // Très petit écran
    if (isSmallScreen) return 48; // Mobile standard
    return 52; // Tablette
  }

  double _getTabHeight(bool isSmallScreen) {
    if (isSmallScreen) return 36;
    return 40;
  }

  double _getTabWidth(bool isSmallScreen, double screenWidth) {
    if (screenWidth < 400) return screenWidth / 3 - 16; // Calcul dynamique pour petits écrans
    if (isSmallScreen) return 103;
    return 120;
  }

  double _getBorderRadius(bool isSmallScreen) {
    if (isSmallScreen) return 22;
    return 24;
  }

  double _getIndicatorBorderRadius(bool isSmallScreen) {
    if (isSmallScreen) return 20;
    return 22;
  }

  double _getFontSize(bool isSmallScreen) {
    if (isSmallScreen) return 12;
    return 14;
  }

  double _getIconSize(bool isSmallScreen) {
    if (isSmallScreen) return 18;
    return 20;
  }

  double _getIconSpacing(bool isSmallScreen) {
    if (isSmallScreen) return 6;
    return 8;
  }

  double _getTabPaddingHorizontal(bool isSmallScreen) {
    if (isSmallScreen) return 6;
    return 8;
  }

  double _getTabPaddingVertical(bool isSmallScreen) {
    if (isSmallScreen) return 4;
    return 6;
  }
}