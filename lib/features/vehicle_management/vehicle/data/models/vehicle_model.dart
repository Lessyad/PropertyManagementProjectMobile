import '../../domain/entities/vehicle_entity.dart';

class VehicleModel {
  final int id;
  final String licensePlate;
  final String color;
  final int year;
  final double dailyPrice;
  final double weeklyPrice;
  final int mileage;
  final String fuelType;
  final String transmission;
  final String vehicleAvailabilityStatus;
  final bool hasAirConditioning;
  final int seats;
  final String vin;
  final String modelName;
  final int modelId;
  final String makeName;
  final String categoryName;
  final int categoryId;
  final List<String> imageUrls;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final bool isinwishlist;
  final double? latitude;
  final double? longitude;

  VehicleModel({
    required this.id,
    required this.licensePlate,
    required this.color,
    required this.year,
    required this.dailyPrice,
    required this.weeklyPrice,
    required this.mileage,
    required this.fuelType,
    required this.transmission,
    required this.vehicleAvailabilityStatus,
    required this.hasAirConditioning,
    required this.seats,
    required this.vin,
    required this.modelName,
    required this.modelId,
    required this.makeName,
    required this.categoryName,
    required this.categoryId,
    required this.imageUrls,
    required this.createdAt,
    required this.modifiedAt,
    required this.isinwishlist,
    this.latitude,
    this.longitude,
  });

  static String _stringFromJson(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }

  static DateTime _dateTimeFromJson(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) return DateTime.parse(value);
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return DateTime.now();
  }

  static List<String> _stringListFromJson(dynamic value) {
    if (value == null || value is! List) return [];
    return value.map((e) => e == null ? '' : e.toString()).toList();
  }

  static dynamic _key(Map<String, dynamic> json, String camel, String pascal) {
    if (json.containsKey(camel)) return json[camel];
    return json[pascal];
  }

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: _intFromJson(_key(json, 'id', 'Id')),
      licensePlate: _stringFromJson(_key(json, 'licensePlate', 'LicensePlate')),
      color: _stringFromJson(_key(json, 'color', 'Color')),
      year: _intFromJson(_key(json, 'year', 'Year')),
      dailyPrice: _doubleFromJson(_key(json, 'dailyPrice', 'DailyPrice')),
      weeklyPrice: _doubleFromJson(_key(json, 'weeklyPrice', 'WeeklyPrice')),
      mileage: _intFromJson(_key(json, 'mileage', 'Mileage')),
      vehicleAvailabilityStatus: _stringFromJson(_key(json, 'vehicleAvailabilityStatus', 'VehicleAvailabilityStatus')),
      fuelType: _stringFromJson(_key(json, 'fuelType', 'FuelType')),
      transmission: _stringFromJson(_key(json, 'transmission', 'Transmission')),
      hasAirConditioning: _key(json, 'hasAirConditioning', 'HasAirConditioning') == true,
      seats: _intFromJson(_key(json, 'seats', 'Seats')),
      vin: _stringFromJson(_key(json, 'vin', 'Vin')),
      modelName: _stringFromJson(_key(json, 'modelName', 'ModelName')),
      modelId: _intFromJson(_key(json, 'modelId', 'ModelId')),
      makeName: _stringFromJson(_key(json, 'makeName', 'MakeName')),
      categoryName: _stringFromJson(_key(json, 'categoryName', 'CategoryName')),
      categoryId: _intFromJson(_key(json, 'categoryId', 'CategoryId')),
      imageUrls: _stringListFromJson(_key(json, 'imageUrls', 'ImageUrls')),
      createdAt: _dateTimeFromJson(_key(json, 'createdAt', 'CreatedAt')),
      modifiedAt: _dateTimeFromJson(_key(json, 'modifiedAt', 'ModifiedAt')),
      isinwishlist: _key(json, 'is_in_wishlist', 'IsInWishlist') == true,
      latitude: _doubleOrNullFromJson(_key(json, 'latitude', 'Latitude')),
      longitude: _doubleOrNullFromJson(_key(json, 'longitude', 'Longitude')),
    );
  }

  static int _intFromJson(dynamic value, [int fallback = 0]) {
    if (value == null) return fallback;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? fallback;
  }

  static double _doubleFromJson(dynamic value, [double fallback = 0.0]) {
    if (value == null) return fallback;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? fallback;
  }

  static double? _doubleOrNullFromJson(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    final d = double.tryParse(value.toString());
    return d;
  }
  // Dans vehicle_model.dart
  VehicleEntity toEntity() {
    return VehicleEntity(
      id: id,
      licensePlate: licensePlate,
      color: color,
      year: year,
      dailyPrice: dailyPrice,
      weeklyPrice: weeklyPrice,
      modelName: modelName,
      makeName: makeName,
      categoryName: categoryName,
      imageUrls: imageUrls,
      mileage: mileage,
      fuelType: fuelType,
      transmission: transmission,
      vehicleAvailabilityStatus: vehicleAvailabilityStatus,
      seats: seats,
      hasAirConditioning: hasAirConditioning,
      isInWishlist: isinwishlist,
      latitude: latitude,
      longitude: longitude,
    );
  }
}