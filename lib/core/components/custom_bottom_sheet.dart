import 'package:enmaa/core/components/svg_image_component.dart';
import 'package:enmaa/core/extensions/context_extension.dart';

import '../../configuration/managers/color_manager.dart';
import '../../configuration/managers/style_manager.dart';
import '../../features/home_module/home_imports.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({super.key,this.padding, required this.widget , required this.headerText ,this.iconPath});
  final Widget widget;
  final String headerText;
  final String? iconPath ;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.greyShade,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.scale(16), vertical: context.scale(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: 4, // Custom height
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            if(iconPath != null) SvgImageComponent(iconPath: iconPath!, width: 20, height: 20),
                            if(iconPath != null) SizedBox(width: context.scale(8)),
                            Text(headerText, style: getBoldStyle(color: ColorManager.blackColor)),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding:padding?? EdgeInsets.symmetric(horizontal: context.scale(16), vertical: context.scale(16)),
                child: widget,
              ),
        ],
      ),
    );
  }
}