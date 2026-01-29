import 'package:enmaa/core/services/map_services/domain/entities/location_entity.dart';

class LocationModel extends LocationEntity {
  const LocationModel({required super.latitude, required super.longitude, required super.locationName, required super.locationAddress});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: double.parse(json['lat']),
      longitude: double.parse( json['lon']), locationName: json['name'] , locationAddress: json['address']['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}