class VehicleFilterModel {
  final int? vehicleCategoryId;
  final String? fuelType;
  final String? transmission;
  final int? minSeats;
  final double? minDailyPrice;
  final double? maxDailyPrice;
  
  // Filtres géographiques selon VehicleFilterDto
  final int? receptionZoneId;
  final int? deliveryZoneId;
  final int? userAge;
  final int? userCountryId; // ID du pays de l'utilisateur
  
  // Filtres de disponibilité
  final String? vehicleAvailabilityStatus;
  final bool? isAvailabilityFilterEnabled;
  final DateTime? startDate;
  final DateTime? endDate;

  VehicleFilterModel({
    this.vehicleCategoryId,
    this.fuelType,
    this.transmission,
    this.minSeats,
    this.minDailyPrice,
    this.maxDailyPrice,
    this.receptionZoneId,
    this.deliveryZoneId,
    this.userAge,
    this.userCountryId,
    this.vehicleAvailabilityStatus,
    this.isAvailabilityFilterEnabled,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    
    // Ajouter le préfixe "filter." pour le binding ASP.NET Core
    if (vehicleCategoryId != null) json['filter.VehicleCategoryId'] = vehicleCategoryId;
    if (fuelType != null) json['filter.FuelType'] = fuelType;
    if (transmission != null) json['filter.Transmission'] = transmission;
    if (minSeats != null) json['filter.MinSeats'] = minSeats;
    if (minDailyPrice != null) json['filter.MinDailyPrice'] = minDailyPrice;
    if (maxDailyPrice != null) json['filter.MaxDailyPrice'] = maxDailyPrice;
    if (receptionZoneId != null) json['filter.ReceptionZoneId'] = receptionZoneId;
    if (deliveryZoneId != null) json['filter.DeliveryZoneId'] = deliveryZoneId;
    if (userAge != null) json['filter.UserAge'] = userAge;
    if (userCountryId != null) json['filter.UserCountryId'] = userCountryId;
    if (vehicleAvailabilityStatus != null) json['filter.VehicleAvailabilityStatus'] = vehicleAvailabilityStatus;
    if (isAvailabilityFilterEnabled != null) json['filter.IsAvailabilityFilterEnabled'] = isAvailabilityFilterEnabled;
    if (startDate != null) json['filter.StartDate'] = startDate!.toIso8601String();
    if (endDate != null) json['filter.EndDate'] = endDate!.toIso8601String();
    
    return json;
  }
}