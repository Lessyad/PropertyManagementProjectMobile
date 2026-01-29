
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';

import '../../configuration/managers/color_manager.dart';
import '../../features/home_module/home_imports.dart';


class CustomNetworkImage extends StatelessWidget {
  final String? image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final bool? border;
  final bool isProduct;
  final BorderRadiusGeometry? borderRadiusGeometry;

  const CustomNetworkImage({
    super.key,
    this.image,
    this.height,
    this.border = false,
    this.width,
    this.fit = BoxFit.fill,
    this.isProduct = false,
    this.borderRadiusGeometry,
  });

  @override
  Widget build(BuildContext context) {
    // Vérifier si l'image est null ou vide
    if (image == null || image!.isEmpty) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: ColorManager.greyShade,
          borderRadius: borderRadiusGeometry,
        ),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: ColorManager.grey3,
            borderRadius: borderRadiusGeometry,
          ),
          child: Center(
            child: Icon(
              Icons.image_not_supported,
              color: ColorManager.primaryColor,
              size: 30,
            ),
          ),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: image!,
        // imageUrl: (image ?? "").isNotEmpty
        //     ? image!
        //     : "https://imnaemediacontainer.blob.core.windows.net/imnaemediacontainer/c65f7450-e7c8-402d-bed0-5e2c23a1037e_1000219057.jpg",
        height: height,
        width: width,
        fit: fit,
        errorWidget: (context, url, error) =>
            Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                color: ColorManager.greyShade,
                borderRadius: borderRadiusGeometry,
              ),
              child: Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  color: ColorManager.grey3,
                  borderRadius: borderRadiusGeometry,
                ),
                child: Center(
                  child: Icon(
                    Icons.refresh, // Refresh icon
                    color: ColorManager.primaryColor,
                    size: 30, // Adjust size as needed
                  ),
                ),
              ),
            ),
        placeholder: (context, url) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: ColorManager.primaryColor.withOpacity(.1),
            child: Container(
              height: height,
              width: width,
              color: isProduct ? null : ColorManager.primaryColor.withOpacity(
                  .1),
              decoration: isProduct
                  ? BoxDecoration(
                  color: ColorManager.greyShade,
                  borderRadius: borderRadiusGeometry)
                  : null,
              child: const Center(child: CupertinoActivityIndicator()),
            ),
          );
        },
        imageBuilder: (context, imageProvider) =>
            Container(
              decoration: BoxDecoration(
                color: isProduct ? null : ColorManager.greyShade,
                borderRadius: borderRadiusGeometry,
                image: DecorationImage(
                  image: imageProvider,
                  fit: fit,
                ),
              ),
            ),
      );

  }
}