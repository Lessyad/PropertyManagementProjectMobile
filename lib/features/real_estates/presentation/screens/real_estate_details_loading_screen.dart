import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/components/shimmer_component.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../configuration/managers/color_manager.dart';
import '../../../../configuration/managers/font_manager.dart';
import '../../../../configuration/managers/style_manager.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/translation/locale_keys.dart';
import '../components/real_estate_details_header_actions_component.dart';
import '../components/real_estate_details_screen_components/real_estate_details_screen_footer.dart';

class RealEstateDetailsLoadingScreen extends StatelessWidget {
  const RealEstateDetailsLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.greyShade,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: context.scale(46)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _HeaderShimmer(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(context.scale(8)),
                    child: SingleChildScrollView(
                      child: SafeArea(
                        top: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _TitleShimmer(),
                            SizedBox(height: context.scale(20)),
                            _SectionTitle(LocaleKeys.descriptionLabel.tr(), context),
                            const _ContentShimmer(),
                            SizedBox(height: context.scale(20)),
                            _SectionTitle(LocaleKeys.propertyDetailsLabel.tr(), context),
                            const _ContentShimmer(),
                            SizedBox(height: context.scale(20)),
                            _SectionTitle(LocaleKeys.locationAndNearbyAreas.tr(), context),
                            const _MapShimmer(),
                            SizedBox(height: context.scale(20)),
                            _SectionTitle(LocaleKeys.amenitiesLabel.tr(), context),
                            const _AmenitiesShimmer(),
                            SizedBox(height: context.scale(20)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}

/// **Header Shimmer (Image + Actions)**
class _HeaderShimmer extends StatelessWidget {
  const _HeaderShimmer();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: double.infinity,
            height: context.scale(250),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(context.scale(12)),
                bottomRight: Radius.circular(context.scale(12)),
              ),
            ),
          ),
        ),
        Positioned(
          top: context.scale(54),
          left: context.scale(16),
          right: context.scale(16),
          child: const RealEstateDetailsHeaderActionsComponent(),
        ),
      ],
    );
  }
}

/// **Shimmer for Title & Two Rows**
class _TitleShimmer extends StatelessWidget {
  const _TitleShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ShimmerComponent(height: 14, width: double.infinity),
        SizedBox(height: context.scale(8)),
        Row(
          children: const [
            ShimmerComponent(height: 14, width: 145),
            Spacer(),
            ShimmerComponent(height: 14, width: 145),
          ],
        ),
      ],
    );
  }
}

/// **Section Title**
Widget _SectionTitle(String title, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: getBoldStyle(
          color: ColorManager.blackColor,
          fontSize: FontSize.s12,
        ),
      ),
      SizedBox(height: context.scale(16)),
    ],
  );
}

/// **Content Shimmer**
class _ContentShimmer extends StatelessWidget {
  const _ContentShimmer();

  @override
  Widget build(BuildContext context) {
    return const ShimmerComponent(height: 90, width: 358);
  }
}

/// **Map Shimmer**
class _MapShimmer extends StatelessWidget {
  const _MapShimmer();

  @override
  Widget build(BuildContext context) {
    return const ShimmerComponent(height: 205, width: 358);
  }
}

/// **Amenities Shimmer (List of Boxes)**
class _AmenitiesShimmer extends StatelessWidget {
  const _AmenitiesShimmer();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(6, (index) {
        return const ShimmerComponent(height: 38, width: 108);
      }),
    );
  }
}
