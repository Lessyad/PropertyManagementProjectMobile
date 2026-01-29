// import 'package:flutter/material.dart';
// import 'package:enmaa/core/extensions/context_extension.dart';
// import 'package:enmaa/configuration/managers/color_manager.dart';
// import 'package:enmaa/configuration/managers/font_manager.dart';
// import 'package:enmaa/configuration/managers/style_manager.dart';
// import 'package:enmaa/core/components/svg_image_component.dart';
// import 'package:enmaa/core/constants/app_assets.dart';
// import 'dashed_border_container.dart';
//
// class SelectVehicleImages extends StatelessWidget {
//   final List<File> selectedImages;
//   final bool isLoading;
//   final bool validateImages;
//   final VoidCallback onSelectImages;
//   final ValueChanged<int> onRemoveImage;
//   final VoidCallback onValidateImages;
//
//   const SelectVehicleImages({
//     required this.selectedImages,
//     required this.isLoading,
//     required this.validateImages,
//     required this.onSelectImages,
//     required this.onRemoveImage,
//     required this.onValidateImages,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         if (selectedImages.isEmpty && !isLoading)
//           InkWell(
//             onTap: onSelectImages,
//             child: DashedBorderContainer(
//               width: double.infinity,
//               height: 120,
//               borderRadius: 12,
//               borderColor: validateImages ? ColorManager.grey3 : Colors.red,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SvgImageComponent(
//                     iconPath: AppAssets.folderIcon,
//                     width: 24,
//                     height: 24,
//                   ),
//                   SizedBox(height: context.scale(8)),
//                   Text(
//                     'Ajouter des photos du véhicule',
//                     textAlign: TextAlign.center,
//                     style: getMediumStyle(
//                       color: ColorManager.grey,
//                       fontSize: FontSize.s12,
//                     ),
//                   ),
//                   Text(
//                     '(Max 5 images)',
//                     style: getMediumStyle(
//                       color: ColorManager.grey,
//                       fontSize: FontSize.s10,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//         if (isLoading)
//           _buildShimmerGrid(context)
//         else if (selectedImages.isNotEmpty)
//           _buildImagesPreview(context),
//       ],
//     );
//   }
//
//   Widget _buildImagesPreview(BuildContext context) {
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         crossAxisSpacing: 8,
//         mainAxisSpacing: 8,
//         childAspectRatio: 1,
//       ),
//       itemCount: selectedImages.length < 5 ? selectedImages.length + 1 : selectedImages.length,
//       itemBuilder: (context, index) {
//         if (index == selectedImages.length && selectedImages.length < 5) {
//           return GestureDetector(
//             onTap: onSelectImages,
//             child: Container(
//               decoration: BoxDecoration(
//                 border: Border.all(color: ColorManager.grey3),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(Icons.add, size: 32),
//             ),
//           );
//         }
//
//         return Stack(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 image: DecorationImage(
//                   image: FileImage(selectedImages[index]),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 4,
//               right: 4,
//               child: GestureDetector(
//                 onTap: () => onRemoveImage(index),
//                 child: Container(
//                   padding: const EdgeInsets.all(4),
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(Icons.close, size: 16),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildShimmerGrid(BuildContext context) {
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         crossAxisSpacing: 8,
//         mainAxisSpacing: 8,
//         childAspectRatio: 1,
//       ),
//       itemCount: 3,
//       itemBuilder: (context, index) {
//         return Container(
//           decoration: BoxDecoration(
//             color: Colors.grey.shade300,
//             borderRadius: BorderRadius.circular(8),
//           ),
//         );
//       },
//     );
//   }
// }