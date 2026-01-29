// import 'package:enmaa/configuration/routers/route_names.dart';
// import 'package:enmaa/core/components/need_to_login_component.dart';
// import 'package:enmaa/core/components/svg_image_component.dart';
// import 'package:enmaa/core/constants/app_assets.dart';
// import 'package:enmaa/core/extensions/context_extension.dart';
// import 'package:enmaa/main.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:easy_localization/easy_localization.dart';
//
// import '../../../../../../configuration/managers/color_manager.dart';
// import '../../../../../../configuration/managers/font_manager.dart';
// import '../../../../../../configuration/managers/style_manager.dart';
// import '../../../../../../core/components/button_app_component.dart';
// import '../../../../../../core/components/custom_snack_bar.dart';
// import '../../../../../../core/translation/locale_keys.dart';
// import '../../../../../home_module/home_imports.dart';
//
//
//
// class VehicleDetailsScreenFooter extends StatelessWidget {
//   const VehicleDetailsScreenFooter({
//     super.key,
//     required this.vehicleId,
//     required this.officePhoneNumber,
//     required this.actionIsDimmed,
//   });
//
//   final String vehicleId;
//   final String officePhoneNumber;
//   final bool actionIsDimmed;
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Container(
//       height: context.scale(88),
//       width: double.infinity,
//
//       padding: EdgeInsets.symmetric(horizontal: context.scale(16)),
//       decoration: BoxDecoration(
//         color: ColorManager.whiteColor,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(context.scale(24)),
//           topRight: Radius.circular(context.scale(24)),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           InkWell(
//             onTap: () async {
//               final Uri phoneUri = Uri(
//                 scheme: 'tel',
//                 path: officePhoneNumber,
//               );
//               if (await canLaunchUrl(phoneUri)) {
//                 await launchUrl(phoneUri);
//               } else {
//                 CustomSnackBar.show(
//                   message: LocaleKeys.cannotOpenDialer.tr(),
//                   type: SnackBarType.error,
//                 );
//               }
//             },
//             child: Container(
//               width: context.scale(48),
//               height: context.scale(48),
//               decoration: BoxDecoration(
//                 color: ColorManager.yellowColor,
//                 shape: BoxShape.circle,
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: SvgImageComponent(
//                   iconPath: AppAssets.phoneCallIcon,
//                   color: ColorManager.whiteColor,
//                 ),
//               ),
//             ),
//           ),
//           ButtonAppComponent(
//             width: 140,
//             height: 46,
//             padding: EdgeInsets.zero,
//             decoration: BoxDecoration(
//               color: actionIsDimmed ? ColorManager.grey2 : ColorManager.whiteColor,
//               borderRadius: BorderRadius.circular(context.scale(24)),
//               border: actionIsDimmed ? null : Border.all(
//                 color: ColorManager.primaryColor,
//                 width: 1,
//               ),
//             ),
//             buttonContent: Center(
//               child: Text(
//                 LocaleKeys.testDrive.tr(),
//                 // Changé de "preview" à "testDrive"
//                 style: getBoldStyle(
//                   color: actionIsDimmed ? ColorManager.blackColor : ColorManager.primaryColor,
//                   fontSize:   FontSize.s12,
//                 ),
//               ),
//             ),
//             onTap: () async {
//               if (isAuth) {
//                 if (!actionIsDimmed) {
//                   final result = await Navigator.of(context).pushNamed(
//                     RoutersNames.testDriveVehicleScreen, // Route pour test drive
//                     arguments: {
//                       'id': vehicleId,
//                     },
//                   );
//                   if (result == true) {
//                     CustomSnackBar.show(
//                       message: LocaleKeys.testDriveConfirmed.tr(), // Message de confirmation de test drive
//                       type: SnackBarType.success,
//                     );
//                   }
//                 } else {
//                   CustomSnackBar.show(
//                     message: LocaleKeys.testDriveError.tr(), // Message d'erreur pour test drive
//                     type: SnackBarType.error,
//                   );
//                 }
//               } else {
//                 LoginBottomSheet.show();
//               }
//             },
//           ),
//           ButtonAppComponent(
//             width: 140,
//             height: 46,
//             padding: EdgeInsets.zero,
//             decoration: BoxDecoration(
//               color: actionIsDimmed ? ColorManager.grey2 : ColorManager.primaryColor,
//               borderRadius: BorderRadius.circular(context.scale(24)),
//             ),
//             buttonContent: Center(
//               child: Text(
//                 LocaleKeys.rentNow.tr(), // Changé de "bookNow" à "rentNow"
//                 style: getBoldStyle(
//                   color: actionIsDimmed ? ColorManager.blackColor : ColorManager.whiteColor,
//                   fontSize: FontSize.s12,
//                 ),
//               ),
//             ),
//             onTap: () async {
//               if (isAuth) {
//                 if (!actionIsDimmed) {
//                   final result = await Navigator.of(context).pushNamed(
//                     RoutersNames.rentVehicleScreen, // Route pour location de véhicule
//                     arguments: vehicleId,
//                   );
//                   if (result == true) {
//                     CustomSnackBar.show(
//                       message: LocaleKeys.rentalConfirmed.tr(), // Message de confirmation de location
//                       type: SnackBarType.success,
//                     );
//                   }
//                 } else {
//                   CustomSnackBar.show(
//                     message: LocaleKeys.rentalError.tr(), // Message d'erreur pour location
//                     type: SnackBarType.error,
//                   );
//                 }
//               } else {
//                 LoginBottomSheet.show();
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }