import 'package:enmaa/core/extensions/context_extension.dart';

import '../../../../../core/components/circular_icon_button.dart';
import '../../../../../core/components/my_property_badge.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/entites/image_entity.dart';
import '../../../../home_module/home_imports.dart';
import '../../../../home_module/presentation/components/banners_widget.dart';
import '../real_estate_details_header_actions_component.dart';


class RealEstateDetailsBanner extends StatelessWidget {
  const RealEstateDetailsBanner({
    super.key,
    required this.banners,
    this.isOwner = false,
  });
  final List<ImageEntity> banners ;
  final bool isOwner;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BannersWidget(
          height: 270,
          banners: banners,
          bottomLeftRadius: 12,
          bottomRightRadius: 12,
        ),
        Positioned(
          top: context.scale(54),
          left: context.scale(16),
          right: context.scale(16),
          child: RealEstateDetailsHeaderActionsComponent(),
        ),
        if (isOwner)
          Positioned(
            bottom: context.scale(16),
            left: context.scale(16),
            child: const MyPropertyBadge(),
          ),
      ],
    );
  }
}
