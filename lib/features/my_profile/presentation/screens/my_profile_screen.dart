import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/extensions/context_extension.dart';

import '../../../../configuration/managers/color_manager.dart';
import '../../../../core/components/app_bar_component.dart';
import '../../../../core/translation/locale_keys.dart';
import '../../../../main.dart';
import '../../../home_module/home_imports.dart';
import '../components/app_controls_widget.dart';
import '../components/log_out_and_contact_us_widget.dart';
import '../components/manage_my_properties_widget.dart';
import '../components/name_and_phone_widget.dart';
import '../components/remove_account_widget.dart';
import '../components/user_screens_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.greyShade,
      body: Column(
        children: [
            AppBarComponent(
            appBarTextMessage: LocaleKeys.myProfile.tr(),
            showNotificationIcon: false,
            showLocationIcon: false,
            centerText: true,
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16 , vertical: 12),
              child: SingleChildScrollView(
                child: Column(
                  spacing: context.scale(12),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NameAndPhoneWidget() ,

                    ManageMyPropertiesWidget(),

                    UserScreensWidget(),

                    AppControlsWidget(),

                    LogOutAndContactUsWidget(),


                    if(isAuth)
                      RemoveAccountWidget()

                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
