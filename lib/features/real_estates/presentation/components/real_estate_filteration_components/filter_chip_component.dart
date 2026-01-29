import '../../../../../configuration/managers/color_manager.dart';
import '../../../../../configuration/managers/font_manager.dart';
import '../../../../../configuration/managers/style_manager.dart';
import '../../../../home_module/home_imports.dart';

class FilterChipComponent extends StatelessWidget {
  const FilterChipComponent({super.key ,required this.label});

  final String label;
  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: getRegularStyle(color: ColorManager.blackColor, fontSize: FontSize.s12),
      ),
      backgroundColor: ColorManager.primaryColor2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
