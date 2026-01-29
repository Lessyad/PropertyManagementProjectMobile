import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:shimmer/shimmer.dart';

import '../../features/home_module/home_imports.dart';

class ShimmerComponent extends StatelessWidget {
  const ShimmerComponent({super.key , required this.height , required this.width});

  final double width , height ;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: context.scale(width),
            height: context.scale(height),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),

        ],
      ),
    ) ;
  }
}
