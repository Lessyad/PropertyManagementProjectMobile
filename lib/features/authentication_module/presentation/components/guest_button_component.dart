import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../configuration/managers/color_manager.dart';
import '../../../../configuration/managers/font_manager.dart';
import '../../../../configuration/managers/style_manager.dart';
import '../../../../configuration/routers/route_names.dart';
import '../../../../core/components/button_app_component.dart';
import '../../../../core/translation/locale_keys.dart';
import '../../../home_module/home_imports.dart';

class GuestButtonComponent extends StatelessWidget {
  const GuestButtonComponent({super.key});

  void _onGuestLogin(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pushNamed(RoutersNames.layoutScreen);
  }

  @override
  Widget build(BuildContext context) {
    return ButtonAppComponent(
      width: double.infinity,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
        borderRadius: BorderRadius.circular(context.scale(24)),
        border: Border.all(
          color: ColorManager.primaryColor,
          width: 1,
        ),
      ),
      buttonContent: Center(
        child: Text(
          LocaleKeys.enterAsGuest.tr(),
          style: getBoldStyle(
            color: ColorManager.primaryColor,
            fontSize: FontSize.s14,
          ),
        ),
      ),
      onTap: () => _onGuestLogin(context),
    );
  }
}