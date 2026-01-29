   import '../../../../core/services/select_location_service/domain/entities/city_entity.dart';
import '../../../../core/services/select_location_service/domain/entities/country_entity.dart';
import '../../../../core/services/select_location_service/domain/entities/state_entity.dart';
import '../../../../core/models/image_model.dart';
import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/land_entity.dart';

class LandModel extends LandEntity {
  const LandModel({
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
    required super.isLicensed, required super.latitude, required super.longitude,
  });

  factory LandModel.fromJson(Map<String, dynamic> json) {
    final propertyType = json['type'];
    final propertyData = json[propertyType];

    final cityData = propertyData['city'];
    final stateData = cityData['state'];
    final countryData = stateData['country'];

    // Traiter l'image correctement
    String imageUrl = '';
    if (propertyData['image'] != null) {
      if (propertyData['image'] is List && (propertyData['image'] as List).isNotEmpty) {
        // Cas où l'image est un tableau
        final imageList = propertyData['image'] as List;
        final mainImage = imageList.firstWhere(
          (img) => img['is_main'] == true,
          orElse: () => imageList.first,
        );
        imageUrl = ImageModel.fromJson(mainImage).image;
      } else if (propertyData['image'] is String && (propertyData['image'] as String).isNotEmpty) {
        // Cas où l'image est une chaîne simple
        String rawImage = propertyData['image'] as String;
        if (!rawImage.startsWith('http')) {
          // Construire l'URL complète
          String baseUrl = ApiConstants.baseUrl.replaceAll('/api/', '');
          imageUrl = "$baseUrl/$rawImage";
        } else {
          imageUrl = rawImage;
        }
      }
    }

    return LandModel(
      id: propertyData['id'],
      title: propertyData['title'],
      image: imageUrl,
      propertyType: propertyType,
      operation: propertyData['operation'],
      price: propertyData['price']?.toString() ?? '0.00',
      area: (propertyData['area'] as num?)?.toDouble() ?? 0.0,
      propertySubType: propertyData['property_sub_type'].toString(),
      status: propertyData['status'],
      city: CityEntity(
        id: cityData['id'].toString(),
        name: cityData['name'].toString(),
      ),
      state: StateEntity(
        id: stateData['id'].toString(),
        name: stateData['name'].toString(),
      ),
      country: CountryEntity(
        id: countryData['id'].toString(),
        name: countryData['name'].toString(),
      ),
      isInWishlist: json['is_in_wishlist'] ?? true,
      isLicensed: propertyData['is_licensed'] ?? false,
      // latitude: propertyData['latitude'] ?? propertyData['latitude'],
      // longitude: propertyData['longitude'] ?? propertyData['longitude'],
      latitude: (propertyData['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (propertyData['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type' : 'land',
      'land':{
        'id': id,
        'title': title,
        'image': image,
        'type': propertyType,
        'operation': operation,
        'price': price,
        'area': area,
        'property_sub_type': propertySubType,
        'status': status,
        'city': {
          'id': city.id,
          'name': city.name,
          'state': {
            'id': state.id,
            'name': state.name,
            'country': {
              'id': country.id,
              'name': country.name,
            },
          },
        },

        'is_in_wishlist': isInWishlist,
        'is_licensed': isLicensed,
      }
    };
  }
}