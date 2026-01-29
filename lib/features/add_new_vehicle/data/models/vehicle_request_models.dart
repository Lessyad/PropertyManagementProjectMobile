import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/utils/enums.dart';

class CreateVehicleRequestModel {
  final int vehiclemakId;
  final int vehicleModelId;
  final String? vin;
  final String licensePlate;
  final String color;
  final double dailyPrice;
  final double weeklyPrice;
  final int mileage;
  final String fuelType; // matches backend enum names
  final String transmission; // matches backend enum names
  final bool hasAirConditioning;
  final int seats;
  final List<File> images;
  final double? latitude;
  final double? longitude;

  CreateVehicleRequestModel({
    required this.vehiclemakId,
    required this.vehicleModelId,
    required this.licensePlate,
    required this.color,
    required this.dailyPrice,
    required this.weeklyPrice,
    required this.mileage,
    required this.fuelType,
    required this.transmission,
    this.vin,
    this.hasAirConditioning = false,
    this.seats = 5,
    this.images = const [],
    this.latitude,
    this.longitude,
  });

  Future<FormData> toFormData() async {
    final formData = FormData.fromMap({
      'VehicleModelId': vehicleModelId,
      if (vin != null) 'VIN': vin,
      'LicensePlate': licensePlate,
      'Color': color,
      'DailyPrice': dailyPrice.toInt() ?? 0,
      'WeeklyPrice': weeklyPrice.toInt() ?? 0,
      'Mileage': mileage,
      'FuelType': fuelType,
      'Transmission': transmission,
      'HasAirConditioning': hasAirConditioning,
      'Seats': seats,
      if (latitude != null) 'Latitude': latitude,
      if (longitude != null) 'Longitude': longitude,
    });

    for (final file in images) {
      final mf = await MultipartFile.fromFile(file.path, filename: file.path.split('/').last);
      formData.files.add(MapEntry('Images', mf));
    }
    return formData;
  }
}

class UpdateVehicleRequestModel {
  final String licensePlate;
  final String? color;
  final double? dailyPrice;
  final double? weeklyPrice;
  final bool? hasAirConditioning;
  final List<File>? images;
  final double? latitude;
  final double? longitude;

  UpdateVehicleRequestModel({
    required this.licensePlate,
    this.color,
    this.dailyPrice,
    this.weeklyPrice,
    this.hasAirConditioning,
    this.images,
    this.latitude,
    this.longitude,
  });

  Future<FormData> toFormData() async {
    final formData = FormData.fromMap({
      'LicensePlate': licensePlate,
      if (color != null) 'Color': color,
      if (dailyPrice != null) 'DailyPrice': dailyPrice,
      if (weeklyPrice != null) 'WeeklyPrice': weeklyPrice,
      if (hasAirConditioning != null) 'HasAirConditioning': hasAirConditioning,
      if (latitude != null) 'Latitude': latitude,
      if (longitude != null) 'Longitude': longitude,
    });

    if (images != null) {
      for (final file in images!) {
        final mf = await MultipartFile.fromFile(file.path, filename: file.path.split('/').last);
        formData.files.add(MapEntry('ImagesUrls', mf));
      }
    }
    return formData;
  }
}


