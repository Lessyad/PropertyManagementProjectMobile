// import 'package:dio/dio.dart';
// import 'package:enmaa/core/models/image_model.dart';
//
// class UpdateVehicleRequestModel {
//   final String licensePlate;
//   final String color;
//   final double dailyPrice;
//   final double weeklyPrice;
//   final bool hasAirConditioning;
//   final List<PropertyImage>? images;
//   final double? latitude;
//   final double? longitude;
//
//   UpdateVehicleRequestModel({
//     required this.licensePlate,
//     required this.color,
//     required this.dailyPrice,
//     required this.weeklyPrice,
//     required this.hasAirConditioning,
//     this.images,
//     this.latitude,
//     this.longitude,
//   });
//
//   Future<FormData> toFormData() async {
//     final formData = FormData();
//
//     formData.fields.addAll([
//       MapEntry('license_plate', licensePlate),
//       MapEntry('color', color),
//       MapEntry('daily_price', dailyPrice.toString()),
//       MapEntry('weekly_price', weeklyPrice.toString()),
//       MapEntry('has_air_conditioning', hasAirConditioning.toString()),
//       if (latitude != null) MapEntry('latitude', latitude.toString()),
//       if (longitude != null) MapEntry('longitude', longitude.toString()),
//     ]);
//
//     // Add new images if provided
//     if (images != null && images!.isNotEmpty) {
//       for (int i = 0; i < images!.length; i++) {
//         final image = images![i];
//         final multipartFile = await MultipartFile.fromFile(
//           image.filePath,
//           filename: image.filePath.split('/').last,
//         );
//         formData.files.add(MapEntry('images', multipartFile));
//
//         if (image.isMain ?? false) {
//           formData.fields.add(MapEntry('images[$i].is_main', 'true'));
//         }
//       }
//     }
//
//     return formData;
//   }
// }