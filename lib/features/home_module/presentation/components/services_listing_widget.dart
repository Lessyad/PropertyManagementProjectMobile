import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/configuration/managers/value_manager.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/translation/locale_keys.dart';
import '../../home_imports.dart';

class ServicesListingWidget extends StatelessWidget {
  const ServicesListingWidget({
    super.key,
    required this.seeMoreAction,
    required this.listingWidget,
    required this.title,
  });

  final Function() seeMoreAction;
  final Widget listingWidget;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // header of service
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.scale(AppPadding.p16)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: getBoldStyle(color: ColorManager.blackColor),
              ),
              InkWell(
                onTap: seeMoreAction,
                child: Text(
                  LocaleKeys.servicesSeeAll.tr(),
                  style: getUnderlineRegularStyle(color: ColorManager.blackColor),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: context.scale(12)),

        listingWidget,
      ],
    );
  }
}