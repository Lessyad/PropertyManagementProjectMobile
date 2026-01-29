import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/core/components/svg_image_component.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../configuration/managers/color_manager.dart';
import '../../features/home_module/home_imports.dart';

class FloatingBottomNavBar extends StatefulWidget {
  final List<FloatingNavBarItem> items;
  final int currentIndex;
  final Function(int) onItemSelected;

  const FloatingBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  State<FloatingBottomNavBar> createState() => _FloatingBottomNavBarState();
}

class _FloatingBottomNavBarState extends State<FloatingBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.scale(24),
          ),
          height: context.scale(90),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: .5,
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              widget.items.length,
                  (index) => _buildNavItem(index),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildNavItem(int index) {
    final item = widget.items[index];
    final isSelected = index == widget.currentIndex;

    return InkWell(
      onTap: () => widget.onItemSelected(index),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgImageComponent(iconPath: item.icon, width: context.scale(isSelected ? 20 : 16), height: context.scale(isSelected?20: 16),
                color: isSelected ? ColorManager.primaryColor : ColorManager.grey,),
              SizedBox(height: 3.h),
              Text(
                item.text,
                style:isSelected ? getBoldStyle(color: ColorManager.primaryColor , fontSize: FontSize.s12) : getRegularStyle(color: ColorManager.grey, fontSize: FontSize.s12),
                ),
            ],
          ),

        ],
      ),
    );
  }
}

class FloatingNavBarItem {
  final String icon;
  final String text;

  FloatingNavBarItem({
    required this.icon,
    required this.text,
  });
}