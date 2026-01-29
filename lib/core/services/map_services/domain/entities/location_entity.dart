import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable {
  final double latitude;
  final double longitude;

  final String locationName, locationAddress ;
  const LocationEntity({
    required this.latitude,
    required this.longitude,
    required this.locationName,
    required this.locationAddress,
  });

  @override
  List<Object> get props => [latitude, longitude , locationName , locationAddress];
}