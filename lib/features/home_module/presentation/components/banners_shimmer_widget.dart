import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../configuration/managers/value_manager.dart';
import '../../home_imports.dart';

class BannersShimmerWidget extends StatelessWidget {
  const BannersShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.scale(AppPadding.p16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.scale(AppRadius.r16)),
        child: SizedBox(
          height: context.scale(150),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
