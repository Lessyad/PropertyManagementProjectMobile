
class VehicleEntity {
  final int id;
  final String licensePlate;
  final String color;
  final int year;
  final double dailyPrice;
  final double weeklyPrice;
  final String modelName;
  final String makeName;
  final String categoryName;
  final List<String> imageUrls;
  final int mileage ;
  final String  fuelType ;
  final String transmission;
  final String vehicleAvailabilityStatus;
  final bool isInWishlist;
  final double? latitude;
  final int? seats;
  final bool? hasAirConditioning;
  final double? longitude;
  VehicleEntity({
    required this.id,
    required this.licensePlate,
    required this.color,
    required this.year,
    required this.dailyPrice,
    required this.weeklyPrice,
    required this.modelName,
    required this.makeName,
    required this.categoryName,
    required this.imageUrls,
    required this.mileage,
    required this.fuelType,
    required this.transmission,
    required this.vehicleAvailabilityStatus,
    required this.isInWishlist,
    this.seats,
    this.hasAirConditioning,
    this.latitude,
    this.longitude,
  });
  List<Object?> get props => [
    id,
    licensePlate,
    color,
    year,
    dailyPrice,
    weeklyPrice,
    mileage,
    fuelType,
    transmission,
    modelName,
    makeName,
    categoryName,
    imageUrls,
    isInWishlist,
    seats,
    hasAirConditioning,
    latitude,
    longitude,
  ];

  VehicleEntity copyWith({
    bool? isInWishlist,
    int? seats,
    bool? hasAirConditioning,
    double? latitude,
    double? longitude,
    // autres champs...
  }) {
    return VehicleEntity(
      id: id,
      licensePlate: licensePlate,
      color: color,
      year: year,
      dailyPrice: dailyPrice,
      weeklyPrice: weeklyPrice,
      mileage: mileage,
      fuelType: fuelType,
      transmission: transmission,
      vehicleAvailabilityStatus: vehicleAvailabilityStatus,
      modelName: modelName,
      makeName: makeName,
      categoryName: categoryName,
      imageUrls: imageUrls,
      seats: seats ?? this.seats,
      hasAirConditioning: hasAirConditioning ?? this.hasAirConditioning,
      isInWishlist: isInWishlist ?? this.isInWishlist,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

}