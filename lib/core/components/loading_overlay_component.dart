import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/core/extensions/context_extension.dart';

import '../../configuration/managers/color_manager.dart';
import '../../features/home_module/home_imports.dart';

class LoadingOverlayComponent extends StatelessWidget {
  const LoadingOverlayComponent({super.key , this.opacity, this.text});

  final double ? opacity;
  final String ? text ;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.black.withOpacity(opacity == null ?  0.5 : opacity!),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: ColorManager.primaryColor,
          ),
          SizedBox(
            height: context.scale(16),
          ),
          if(text != null)
            Text(text! , style: getBoldStyle(color: ColorManager.primaryColor),)

        ],
      ),
    );
  }
}
