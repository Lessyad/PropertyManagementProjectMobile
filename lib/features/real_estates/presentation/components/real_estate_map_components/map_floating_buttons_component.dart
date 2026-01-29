import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/core/extensions/context_extension.dart';

class MapFloatingButtonsComponent extends StatelessWidget {
  final VoidCallback toggleMapType;
  final VoidCallback centerOnCurrentLocation;
  final VoidCallback zoomIn;
  final VoidCallback zoomOut;
  final MapType currentMapType;

  const MapFloatingButtonsComponent({
    Key? key,
    required this.toggleMapType,
    required this.centerOnCurrentLocation,
    required this.zoomIn,
    required this.zoomOut,
    required this.currentMapType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 110.h,
      right:-5.w,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.scale(10)),
        child: SizedBox(
          height: 510.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                onPressed: toggleMapType,
                backgroundColor: ColorManager.whiteColor,
                mini: true,
                child: Icon(
                  currentMapType == MapType.normal
                      ? Icons.satellite
                      : Icons.map,
                  color: ColorManager.grey,
                ),
              ),
              Column(
                children: [
                  /*FloatingActionButton(
                    onPressed: centerOnCurrentLocation,
                    backgroundColor: ColorManager.whiteColor,
                    mini: true,
                    child: Icon(
                      Icons.my_location,
                      color: ColorManager.grey,
                    ),
                  ),*/
                  SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                      color: ColorManager.whiteColor,
                      borderRadius: BorderRadius.circular(context.scale(4)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: zoomIn,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(context.scale(30)),
                            topRight: Radius.circular(context.scale(30)),
                          ),
                          child: Container(
                            width: context.scale(40),
                            height: context.scale(40),
                            decoration: BoxDecoration(
                              color: ColorManager.whiteColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(context.scale(30)),
                                topRight: Radius.circular(context.scale(30)),
                              ),
                            ),
                            child: Icon(
                              Icons.add,
                              color: ColorManager.grey,
                              size: context.scale(24),
                            ),
                          ),
                        ),
                        Container(
                          width: context.scale(40),
                          height: context.scale(1),
                          color: ColorManager.grey.withOpacity(0.3),
                        ),
                        InkWell(
                          onTap: zoomOut,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(context.scale(30)),
                            bottomRight: Radius.circular(context.scale(30)),
                          ),
                          child: Container(
                            width: context.scale(40),
                            height: context.scale(40),
                            decoration: BoxDecoration(
                              color: ColorManager.whiteColor,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(context.scale(30)),
                                bottomRight: Radius.circular(context.scale(30)),
                              ),
                            ),
                            child: Icon(
                              Icons.remove,
                              color: ColorManager.grey,
                              size: context.scale(24),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
