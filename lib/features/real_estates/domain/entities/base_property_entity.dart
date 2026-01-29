import 'package:enmaa/core/services/select_location_service/domain/entities/city_entity.dart';
import 'package:enmaa/core/services/select_location_service/domain/entities/country_entity.dart';
import 'package:enmaa/core/services/select_location_service/domain/entities/state_entity.dart';
import 'package:equatable/equatable.dart';

abstract class PropertyEntity extends Equatable {
  final int id;
  final String title;
  final String image;
  final String propertyType;
  final String operation;
  final String price;
  final double area;
  final String propertySubType;
  final String status;
  final CityEntity city;
  final CountryEntity country;
  final StateEntity state;
  final bool isInWishlist;
  final double latitude , longitude;

  const PropertyEntity({
    required this.id,
    required this.title,
    required this.image,
    required this.propertyType,
    required this.operation,
    required this.price,
    required this.area,
    required this.propertySubType,
    required this.status,
    required this.city,
    required this.state,
    required this.country,
    required this.isInWishlist,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    image,
    propertyType,
    operation,
    price,
    area,
    propertySubType,
    status,
    city,
    state,
    country,
    isInWishlist,
    latitude,
    longitude,
  ];

  PropertyEntity copyWith({
    int? id,
    String? title,
    String? image,
    String? propertyType,
    String? operation,
    String? price,
    double? area,
    String? propertySubType,
    String? status,
    CityEntity? city,
    StateEntity? state,
    CountryEntity? country,
    bool? isInWishlist,
    double? latitude,
    double? longitude,
  }) ;
}
