import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import '../../../../../../configuration/managers/color_manager.dart';
import '../../../../../../configuration/managers/font_manager.dart';
import '../../../../../../configuration/managers/style_manager.dart';
import '../../../../../../core/translation/locale_keys.dart';
import '../../../../../home_module/home_imports.dart';

class UserDataScreenButtons extends StatelessWidget {
  const UserDataScreenButtons({super.key, required this.onSavePressed});

  final Function onSavePressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: context.scale(16), vertical: context.scale(25)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD6D8DB),
                  foregroundColor: const Color(0xFFD6D8DB),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                ),
                child: Text(
                  LocaleKeys.cancel.tr(),
                  style: getMediumStyle(
                      color: ColorManager.blackColor, fontSize: FontSize.s14),
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  onSavePressed();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                ),
                child: Text(
                  LocaleKeys.saveChanges.tr(),
                  style: getBoldStyle(
                      color: ColorManager.whiteColor, fontSize: FontSize.s14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}