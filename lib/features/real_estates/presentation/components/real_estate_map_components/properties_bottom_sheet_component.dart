import 'package:flutter/material.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/core/extensions/context_extension.dart';

class PropertiesBottomSheetComponent extends StatelessWidget {
  final DraggableScrollableController controller;
  final int propertiesCount;

  const PropertiesBottomSheetComponent({
    Key? key,
    required this.controller,
    required this.propertiesCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return DraggableScrollableSheet(
      controller: controller,
      initialChildSize: context.scale(100) / screenHeight,
      minChildSize: context.scale(100) / screenHeight,
      maxChildSize: 0.9,
      snap: true,
      snapSizes: [context.scale(100) / screenHeight, 0.20, 0.9],
      builder: (BuildContext context, ScrollController scrollController) {
        bool hasPopped = false;
        return NotificationListener<DraggableScrollableNotification>(
          onNotification: (notification) {
            if (notification.extent >= 0.20 &&
                !hasPopped &&
                Navigator.canPop(context)) {
              hasPopped = true;
              Navigator.pop(context);
              return true;
            }
            return false;
          },
          child: Container(
            decoration: BoxDecoration(
              color: ColorManager.whiteColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(context.scale(20)),
                topRight: Radius.circular(context.scale(20)),
              ),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  Container(
                    width: context.scale(80),
                    height: context.scale(4),
                    margin: EdgeInsets.symmetric(vertical: context.scale(10)),
                    decoration: BoxDecoration(
                      color: ColorManager.grey3,
                      borderRadius: BorderRadius.circular(context.scale(10)),
                    ),
                  ),
                  SizedBox(height: context.scale(10)),
                  Text(
                    'أكثر من $propertiesCount عقار',
                    style: TextStyle(
                      fontSize: context.scale(16),
                      color: ColorManager.blackColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    height: screenHeight * 0.9 - context.scale(100),
                    color: ColorManager.whiteColor,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
