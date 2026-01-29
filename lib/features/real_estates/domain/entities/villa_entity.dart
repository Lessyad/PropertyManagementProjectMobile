import 'package:enmaa/features/real_estates/domain/entities/base_property_entity.dart';

import '../../../../core/services/select_location_service/domain/entities/city_entity.dart';
import '../../../../core/services/select_location_service/domain/entities/country_entity.dart';
import '../../../../core/services/select_location_service/domain/entities/state_entity.dart';

class VillaEntity extends PropertyEntity {
  final int floors;
  final int rooms;
  final int bathrooms;
  final bool hasPool;
  final bool isFurnished;

  const VillaEntity({
    required super.id,
    required super.title,
    required super.image,
    required super.propertyType,
    required super.operation,
    required super.price,
    required super.area,
    required super.propertySubType,
    required super.status,
    required super.city,
    required super.state,
    required super.country,
    required super.isInWishlist,
    required this.floors,
    required this.rooms,
    required this.bathrooms,
    required this.hasPool,
    required this.isFurnished, required super.latitude, required super.longitude,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    floors,
    rooms,
    bathrooms,
    hasPool,
    isFurnished,
  ];

  VillaEntity copyWith({
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
    int? floors,
    int? rooms,
    int? bathrooms,
    bool? hasPool,
    bool? isFurnished,
    double? latitude,
    double? longitude,
  }) {
    return VillaEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      propertyType: propertyType ?? this.propertyType,
      operation: operation ?? this.operation,
      price: price ?? this.price,
      area: area ?? this.area,
      propertySubType: propertySubType ?? this.propertySubType,
      status: status ?? this.status,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      isInWishlist: isInWishlist ?? this.isInWishlist,
      floors: floors ?? this.floors,
      rooms: rooms ?? this.rooms,
      bathrooms: bathrooms ?? this.bathrooms,
      hasPool: hasPool ?? this.hasPool,
      isFurnished: isFurnished ?? this.isFurnished,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
