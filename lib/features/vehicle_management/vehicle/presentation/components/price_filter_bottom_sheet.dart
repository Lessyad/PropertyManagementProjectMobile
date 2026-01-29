// import 'package:flutter/material.dart';
// import 'package:easy_localization/easy_localization.dart';
// import '../../../../../configuration/managers/color_manager.dart';
// import '../../../../../configuration/managers/font_manager.dart';
// import '../../../../../configuration/managers/style_manager.dart';
// import '../../../../../core/translation/locale_keys.dart';
// import '../../../../../core/components/custom_bottom_sheet.dart';
// import '../../../../../core/components/button_app_component.dart';
//
// class PriceFilterBottomSheet extends StatefulWidget {
//   final double? currentMaxPrice;
//   final Function(double?) onPriceChanged;
//
//   const PriceFilterBottomSheet({
//     super.key,
//     this.currentMaxPrice,
//     required this.onPriceChanged,
//   });
//
//   @override
//   State<PriceFilterBottomSheet> createState() => _PriceFilterBottomSheetState();
// }
//
// class _PriceFilterBottomSheetState extends State<PriceFilterBottomSheet> {
//   late TextEditingController _priceController;
//   double? _selectedMaxPrice;
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedMaxPrice = widget.currentMaxPrice;
//     _priceController = TextEditingController(
//       text: _selectedMaxPrice?.toStringAsFixed(0) ?? '',
//     );
//   }
//
//   @override
//   void dispose() {
//     _priceController.dispose();
//     super.dispose();
//   }
//
//   void _applyFilter() {
//     widget.onPriceChanged(_selectedMaxPrice);
//     Navigator.pop(context);
//   }
//
//   void _clearFilter() {
//     setState(() {
//       _selectedMaxPrice = null;
//       _priceController.clear();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomBottomSheet(
//       headerText: LocaleKeys.filterByPrice.tr(),
//       iconPath: 'assets/icons/filter_icon.svg',
//       widget: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             LocaleKeys.maximumDailyPrice.tr(),
//             style: getBoldStyle(
//               color: ColorManager.blackColor,
//               fontSize: FontSize.s16,
//             ),
//           ),
//           SizedBox(height: 16),
//
//           // Champ de saisie du prix
//           Container(
//             decoration: BoxDecoration(
//               color: ColorManager.greyShade,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                 color: ColorManager.primaryColor,
//                 width: 1.5,
//               ),
//             ),
//             child: TextField(
//               controller: _priceController,
//               keyboardType: TextInputType.number,
//               onChanged: (value) {
//                 setState(() {
//                   _selectedMaxPrice = double.tryParse(value);
//                 });
//               },
//               decoration: InputDecoration(
//                 hintText: LocaleKeys.enterMaxPrice.tr(),
//                 border: InputBorder.none,
//                 contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 suffixText: 'DH',
//                 suffixStyle: getBoldStyle(
//                   color: ColorManager.primaryColor,
//                   fontSize: FontSize.s14,
//                 ),
//               ),
//               style: getRegularStyle(
//                 color: ColorManager.blackColor,
//                 fontSize: FontSize.s14,
//               ),
//             ),
//           ),
//
//           SizedBox(height: 16),
//
//           // Options de prix prédéfinies
//           Text(
//             LocaleKeys.quickPriceOptions.tr(),
//             style: getBoldStyle(
//               color: ColorManager.blackColor,
//               fontSize: FontSize.s14,
//             ),
//           ),
//           SizedBox(height: 12),
//
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children: [
//               _buildPriceChip('100', 100),
//               _buildPriceChip('200', 200),
//               _buildPriceChip('300', 300),
//               _buildPriceChip('500', 500),
//               _buildPriceChip('1000', 1000),
//             ],
//           ),
//
//           SizedBox(height: 24),
//
//           // Boutons d'action
//           Row(
//             children: [
//               Expanded(
//                 child: ButtonAppComponent(
//                   width: double.infinity,
//                   height: 48,
//                   decoration: BoxDecoration(
//                     color: ColorManager.grey2,
//                     borderRadius: BorderRadius.circular(24),
//                   ),
//                   buttonContent: Text(
//                     LocaleKeys.clear.tr(),
//                     style: getBoldStyle(
//                       color: ColorManager.blackColor,
//                       fontSize: FontSize.s14,
//                     ),
//                   ),
//                   onTap: _clearFilter,
//                 ),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: ButtonAppComponent(
//                   width: double.infinity,
//                   height: 48,
//                   decoration: BoxDecoration(
//                     color: ColorManager.primaryColor,
//                     borderRadius: BorderRadius.circular(24),
//                   ),
//                   buttonContent: Text(
//                     LocaleKeys.apply.tr(),
//                     style: getBoldStyle(
//                       color: ColorManager.whiteColor,
//                       fontSize: FontSize.s14,
//                     ),
//                   ),
//                   onTap: _applyFilter,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPriceChip(String label, double price) {
//     final isSelected = _selectedMaxPrice == price;
//
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedMaxPrice = price;
//           _priceController.text = price.toStringAsFixed(0);
//         });
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: isSelected ? ColorManager.primaryColor : ColorManager.greyShade,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: isSelected ? ColorManager.primaryColor : ColorManager.grey3,
//             width: 1,
//           ),
//         ),
//         child: Text(
//           '$label DH',
//           style: getMediumStyle(
//             color: isSelected ? ColorManager.whiteColor : ColorManager.blackColor,
//             fontSize: FontSize.s12,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
