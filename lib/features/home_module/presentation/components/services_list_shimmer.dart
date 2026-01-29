import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:shimmer/shimmer.dart';

import '../../home_imports.dart';

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!, // Light grey color
      highlightColor: Colors.grey[100]!, // Lighter grey color
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.scale(10)),
            child: Container(
              width: context.scale(64),
              height: context.scale(64),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(height: context.scale(8)),
          Container(
            width: context.scale(50),
            height: context.scale(12),
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}