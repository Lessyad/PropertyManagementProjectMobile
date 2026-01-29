import 'dart:io';
import 'package:flutter/material.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import '../../../../configuration/managers/color_manager.dart';
import '../../../../configuration/managers/font_manager.dart';
import '../../../../configuration/managers/style_manager.dart';
import '../../../../core/components/svg_image_component.dart';
import '../../../../core/constants/app_assets.dart';
import 'dashed_border_container.dart';

typedef ImageSelectionCallback = Future<void> Function();
typedef ImageRemovalCallback = void Function(int index);
typedef ValidateImagesCallback = bool Function();

enum ImageSelectionMode {
  single,
  multiple,
}

class SelectImagesComponent extends StatefulWidget {
  final List<File> selectedImages;
  final bool isLoading;
  final bool validateImages;
  final ImageSelectionCallback onSelectImages;
  final ImageRemovalCallback onRemoveImage;
  final ValidateImagesCallback onValidateImages;
  final ImageSelectionMode mode;

  final double height;
  final String hintText ;
  const SelectImagesComponent({
    super.key,
    required this.selectedImages,
    required this.isLoading,
    required this.validateImages,
    required this.onSelectImages,
    required this.onRemoveImage,
    required this.onValidateImages,
    this.mode = ImageSelectionMode.multiple,
    required this.hintText ,
    required this.height ,
  });

  @override
  State<SelectImagesComponent> createState() => _SelectImagesComponentState();
}

class _SelectImagesComponentState extends State<SelectImagesComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        if (widget.selectedImages.isEmpty && !widget.isLoading)
          InkWell(
            onTap: widget.onSelectImages,
            child: DottedBorderContainer(
              width: double.infinity,
              height: widget.height,
              borderRadius: 12,
              borderColor: widget.validateImages ? ColorManager.grey3 : Colors.red,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgImageComponent(
                    iconPath: AppAssets.folderIcon,
                    width: 16,
                    height: 16,
                  ),
                  SizedBox(width: context.scale(8)),
                  Flexible(
                    child: Text(
                      widget.hintText,
                      textAlign: TextAlign.center,
                      style: getMediumStyle(
                        color: ColorManager.grey,
                        fontSize: FontSize.s12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),

        if (widget.isLoading)
          widget.mode == ImageSelectionMode.single
              ? _buildShimmer(context)
              : _buildShimmerGrid(context)
        else if (widget.selectedImages.isNotEmpty)
          widget.mode == ImageSelectionMode.single
              ? _buildSingleImagePreview(context)
              : _buildMultipleImagesPreview(context),
      ],
    );
  }

  Widget _buildSingleImagePreview(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: context.scale(widget.height * 1.3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: FileImage(widget.selectedImages.first),
              fit: BoxFit.cover,
            ),
          ),
        ),
        PositionedDirectional(
          top: context.scale(8),
          end: context.scale(8),
          child: GestureDetector(
            onTap: (){
              widget.onSelectImages();
            },
            child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.edit,
                color: Colors.blue,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMultipleImagesPreview(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: context.scale(8)),
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.selectedImages.length < 5
            ? widget.selectedImages.length + 1
            : widget.selectedImages.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 12,
          childAspectRatio: 171 / 124,
        ),
        itemBuilder: (context, index) {
          if (index == widget.selectedImages.length && widget.selectedImages.length < 5) {
            return GestureDetector(
              onTap: widget.onSelectImages,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorManager.grey3,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorManager.primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 32,
                        color: ColorManager.whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: index == 0 ? Colors.blue : Colors.transparent,
                    width: index == 0 ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(21),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    widget.selectedImages[index],
                    width: context.scale(171),
                    height: context.scale(124),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Delete icon
              PositionedDirectional(
                top: context.scale(8),
                end: context.scale(12),
                child: GestureDetector(
                  onTap: () => widget.onRemoveImage(index),
                  child: Container(
                    width: context.scale(24),
                    height: context.scale(24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: ColorManager.blackColor,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Container(
      width: double.infinity,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildShimmerGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 12,
        childAspectRatio: 171 / 124,
      ),
      itemBuilder: (context, index) {
        return Container(
          width: context.scale(171),
          height: context.scale(124),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
          ),
        );
      },
    );
  }
}