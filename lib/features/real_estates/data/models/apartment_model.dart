
 import '../../../../core/services/select_location_service/domain/entities/city_entity.dart';
import '../../../../core/services/select_location_service/domain/entities/country_entity.dart';
import '../../../../core/services/select_location_service/domain/entities/state_entity.dart';
import '../../../../core/models/image_model.dart';
import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/apartment_entity.dart';

class ApartmentModel extends ApartmentEntity {
  const ApartmentModel({
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
    required super.isInWishlist,
    required super.floor,
    required super.rooms,
    required super.bathrooms,
    required super.state,
    required super.country,
    required super.isFurnished, required super.latitude, required super.longitude,
  });

  factory ApartmentModel.fromJson(Map<String, dynamic> json) {
    final propertyData = json['apartment'];

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

    return ApartmentModel(
      id: propertyData['id'] ?? 0,
      title: propertyData['title'].toString(),
      image: imageUrl,
      propertyType: json['type'].toString(),
      operation: propertyData['operation'].toString(),
      price: propertyData['price']?.toString() ?? '0.00',
      area: (propertyData['area'] as num?)?.toDouble() ?? 0.0,
      propertySubType: propertyData['property_sub_type'].toString(),
      status: propertyData['status'].toString(),
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
      floor: propertyData['floor'] is int
          ? propertyData['floor']
          : int.parse(propertyData['floor'].toString()),
      rooms: propertyData['rooms'] is int
          ? propertyData['rooms']
          : int.parse(propertyData['rooms'].toString()),
      bathrooms: propertyData['bathrooms'] is int
          ? propertyData['bathrooms']
          : int.parse(propertyData['bathrooms'].toString()),
      isFurnished: propertyData['is_furnitured'] ?? false,
      // latitude: propertyData['latitude'] ?? propertyData['latitude'],
      // longitude: propertyData['longitude'] ?? propertyData['longitude'],
      latitude: (propertyData['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (propertyData['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type':'apartment',
      'apartment':{
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
        'floor': floor,
        'rooms': rooms,
        'bathrooms': bathrooms,
        'is_furnitured': isFurnished,
      },
    };
  }
}