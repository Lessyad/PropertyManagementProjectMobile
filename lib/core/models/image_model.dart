import 'package:enmaa/core/constants/json_keys.dart';
import 'package:enmaa/core/constants/api_constants.dart';
import 'package:enmaa/core/entites/image_entity.dart';

class ImageModel extends ImageEntity{
  const ImageModel({
    required super.id,
    required super.image,
    required super.isMain,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    String rawImage = json[JsonKeys.image] ?? '';
    
    // Construire l'URL complète de l'image
    String imageUrl = rawImage;
    if (rawImage.isNotEmpty && !rawImage.startsWith('http')) {
      // Extraire l'URL de base sans le "/api/" final
      String baseUrl = ApiConstants.baseUrl.replaceAll('/api/', '');
      imageUrl = "$baseUrl/$rawImage";
    }
    
    return ImageModel(
     id: json[JsonKeys.id] ?? 0,
      image: imageUrl,
      isMain: json[JsonKeys.isMain] ?? true ,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      JsonKeys.id: id,
      JsonKeys.image: image,
      JsonKeys.isMain: isMain,
    };
  }
}