// import 'package:dio/dio.dart';
// import 'package:enmaa/core/models/image_model.dart';
//
// class CreateVehicleRequestModel {
//   final int vehicleModelId;
//   final String licensePlate;
//   final String color;
//   final double dailyPrice;
//   final double weeklyPrice;
//   final int mileage;
//   final String fuelType;
//   final String transmission;
//   final bool hasAirConditioning;
//   final int seats;
//   final String? vin;
//   final List<String> images; // Changé: List<File> au lieu de List<PropertyImage>
//   final double? latitude;
//   final double? longitude;
//
//   CreateVehicleRequestModel({
//     required this.vehicleModelId,
//     required this.licensePlate,
//     required this.color,
//     required this.dailyPrice,
//     required this.weeklyPrice,
//     required this.mileage,
//     required this.fuelType,
//     required this.transmission,
//     required this.hasAirConditioning,
//     required this.seats,
//     this.vin,
//     required this.images, // Maintenant List<File>
//     this.latitude,
//     this.longitude,
//   });
//
//   Future<FormData> toFormData() async {
//     import 'package:dio/dio.dart';
//     import 'package:enmaa/core/models/image_model.dart';
//
//     class CreateVehicleRequestModel {
//     final int vehicleModelId;
//     final String licensePlate;
//     final String color;
//     final double dailyPrice;
//     final double weeklyPrice;
//     final int mileage;
//     final String fuelType;
//     final String transmission;
//     final bool hasAirConditioning;
//     final int seats;
//     final String? vin;
//     final List<PropertyImage> images;
//     final double? latitude;
//     final double? longitude;
//
//     CreateVehicleRequestModel({
//     required this.vehicleModelId,
//     required this.licensePlate,
//     required this.color,
//     required this.dailyPrice,
//     required this.weeklyPrice,
//     required this.mileage,
//     required this.fuelType,
//     required this.transmission,
//     required this.hasAirConditioning,
//     required this.seats,
//     this.vin,
//     required this.images,
//     this.latitude,
//     this.longitude,
//     });
//
//     Future<FormData> toFormData() async {
//     final formData = FormData();
//
//     // Add basic fields
//     formData.fields.addAll([
//     MapEntry('vehicle_model_id', vehicleModelId.toString()),
//     MapEntry('license_plate', licensePlate),
//     MapEntry('color', color),
//     MapEntry('daily_price', dailyPrice.toString()),
//     MapEntry('weekly_price', weeklyPrice.toString()),
//     MapEntry('mileage', mileage.toString()),
//     MapEntry('fuel_type', fuelType),
//     MapEntry('transmission', transmission),
//     MapEntry('has_air_conditioning', hasAirConditioning.toString()),
//     MapEntry('seats', seats.toString()),
//     if (vin != null) MapEntry('vin', vin!),
//     if (latitude != null) MapEntry('latitude', latitude.toString()),
//     if (longitude != null) MapEntry('longitude', longitude.toString()),
//     ]);
//
//     // Add images
//     for (int i = 0; i < images.length; i++) {
//     final image = images[i];
//     final multipartFile = await MultipartFile.fromFile(
//     image.filePath,
//     filename: image.filePath.split('/').last,
//     );
//     formData.files.add(MapEntry('images', multipartFile));
//
//     if (image.isMain ?? false) {
//     formData.fields.add(MapEntry('images[$i].is_main', 'true'));
//     }
//     }
//
//     return formData;
//     }
//     }  }
// }