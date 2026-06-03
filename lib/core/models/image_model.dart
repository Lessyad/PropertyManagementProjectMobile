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

    String imageUrl = rawImage;
    if (rawImage.isNotEmpty && !rawImage.startsWith('http')) {
      // Retire /api/ et tout ce qui suit pour obtenir la racine du domaine
      final String base = ApiConstants.baseUrl
          .replaceAll(RegExp(r'/api/.*'), ''); // "https://domain.net" sans trailing slash
      final String path = rawImage.startsWith('/') ? rawImage : '/$rawImage';
      imageUrl = '$base$path';
    }

    return ImageModel(
      id: json[JsonKeys.id] ?? 0,
      image: imageUrl,
      isMain: json[JsonKeys.isMain] ?? true,
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