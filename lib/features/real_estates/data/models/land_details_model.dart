import 'package:enmaa/core/models/amenity_model.dart';
import 'package:enmaa/core/models/image_model.dart';
import 'package:enmaa/features/real_estates/domain/entities/land_details_entity.dart';

class LandDetailsModel extends LandDetailsEntity {
  const LandDetailsModel({
    required super.id,
    required super.title,
    required super.operation,
    required super.price,
    required super.area,
    required super.propertySubType,
    required super.status,
    required super.images,
    required super.amenities,
    required super.description,
    required super.latitude,
    required super.longitude,
    required super.city,
    required super.state,
    required super.country,
    required super.isInWishlist,
    required super.isLicensed,
    required super.usageType, required super.rentIsRenewable, required super.monthlyRentPeriod, required super.officePhoneNumber, required super.isOwner,
  });

  factory LandDetailsModel.fromJson(Map<String, dynamic> json) {
    final propertyType = json['type'];
    final propertyData = json[propertyType];

    final cityData = propertyData['city'];
    final stateData = cityData['state'];
    final countryData = stateData['country'];

    return LandDetailsModel(
      id: propertyData['id'],
      title: propertyData['title'],
      operation: propertyData['operation'],
      price: propertyData['price']?.toString() ?? '0.00',
      area: (propertyData['area'] as num?)?.toDouble() ?? 0.0,
      propertySubType: propertyData['property_sub_type']['name'].toString(),
      status: propertyData['status'],
      images: (propertyData['image'] as List)
          .map((image) => ImageModel.fromJson(image))
          .toList(),
      amenities: (propertyData['amenities'] as List)
          .map((amenity) => AmenityModel.fromJson(amenity))
          .toList(),
      description: propertyData['description'] ?? '',
      latitude: propertyData['latitude'] ?? 0.0,
      longitude: propertyData['longitude'] ?? 0.0,
      // city: cityData['name'].toString(),
      // state: stateData['name'].toString(),
      // country: countryData['name'].toString(),
      city: propertyData['city']?['name']?.toString() ?? '',
      state: propertyData['city']?['state']?['name']?.toString() ?? '',
      country: propertyData['city']?['state']?['country']?['name']?.toString() ?? '',
      isInWishlist: json['is_in_wishlist'] ?? false,
      isLicensed: propertyData['is_licensed'] ?? false,
      usageType: propertyData['usage_type'] ?? '',
      rentIsRenewable: propertyData['is_renewable'] ?? '', 
      monthlyRentPeriod: propertyData['monthlyRentPeriod']?.toString() ?? propertyData['monthly_rent_period']?.toString() ?? '',
      officePhoneNumber: propertyData['partner_info']?['phone_number'].toString() ?? '',
      isOwner: propertyData['is_owner'] ?? false,


    );
  }
}