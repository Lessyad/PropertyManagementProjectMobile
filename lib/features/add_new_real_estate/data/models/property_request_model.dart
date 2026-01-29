import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import '../../../../core/constants/json_keys.dart';

abstract class PropertyRequestModel {
  final String currentPropertyOperationType;
  final String propertySubType;
  final String title;
  final String description;
  final double price;
  final List<PropertyImage> images;
  final String city;
  final String latitude;
  final String longitude;
  final List<String> amenities;

  // Common fields for all properties
  final int? monthlyRentPeriod;
  final bool? isRenewable;
  final String? paymentMethod;

  PropertyRequestModel( {
    required this.currentPropertyOperationType,
    required this.propertySubType,
    required this.title,
    required this.description,
    required this.price,
    required this.images,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.amenities,
    this.monthlyRentPeriod,
    this.isRenewable,
    this.paymentMethod,
  });

  /// Converts this model into a FormData object for a multipart/form-data request.
  Future<FormData> toFormData() async {
    // Create a base map for non-file fields.
    final Map<String, dynamic> data = {
      JsonKeys.operation: currentPropertyOperationType,
      JsonKeys.title: title,
      JsonKeys.description: description,
      JsonKeys.price: price,
      // JsonKeys.city: city,
      // JsonKeys.latitude: latitude,
      // JsonKeys.longitude: longitude,
      JsonKeys.city: int.tryParse(city)?.toString() ?? '0',
      JsonKeys.latitude: double.tryParse(latitude)?.toString() ?? '0',
      JsonKeys.longitude: double.tryParse(longitude)?.toString() ?? '0',
      JsonKeys.amenities: amenities,
      // JsonKeys.propertySubType : propertySubType,
      JsonKeys.propertySubType: int.tryParse(propertySubType)?.toString() ?? '0',
    };

    // final formDatas = FormData.fromMap(data);
    final formData = FormData.fromMap(data);
    for (var id in amenities) {
      final parsedId = int.tryParse(id);
      if (parsedId != null) {
        formData.fields.add(MapEntry(JsonKeys.amenities, parsedId.toString()));
      }
    }

       // Add common fields if they are not null
    if (monthlyRentPeriod != null) {
      data[JsonKeys.monthlyRentPeriod] = monthlyRentPeriod;
    }
    if (isRenewable != null) {
      data[JsonKeys.isRenewable] = isRenewable;
    }
    if (paymentMethod != null) {
      data[JsonKeys.paymentMethod] = paymentMethod;
    }

    // Start building FormData.


    // Add image files.
    for (int i = 0; i < images.length; i++) {
      final filePath = images[i].filePath;
      final multipartFile = await MultipartFile.fromFile(
        filePath,
        filename: filePath.split('/').last,
      );
      // Add file under the key 'images'
      formData.files.add(MapEntry('images', multipartFile));
      // Add corresponding is_main flag for this image.
      formData.fields.add(
        MapEntry('images[$i].is_main', images[i].isMain?.toString() ?? 'false'),
      );
    }

    return formData;
  }

  // Future<Map<String, dynamic>> toJson() async {
  //   final Map<String, dynamic> data = {
  //     JsonKeys.operation: currentPropertyOperationType,
  //     JsonKeys.title: title,
  //     JsonKeys.description: description,
  //     JsonKeys.price: price,
  //     JsonKeys.city: city,
  //     JsonKeys.latitude: latitude,
  //     JsonKeys.longitude: longitude,
  //     JsonKeys.amenities: amenities,
  //     JsonKeys.propertySubType: propertySubType,
  //   };
  //
  //   if (monthlyRentPeriod != null) {
  //     data[JsonKeys.monthlyRentPeriod] = monthlyRentPeriod;
  //   }
  //   if (isRenewable != null) {
  //     data[JsonKeys.isRenewable] = isRenewable;
  //   }
  //   if (paymentMethod != null) {
  //     data[JsonKeys.paymentMethod] = paymentMethod;
  //   }
  //
  //   // Convert image files to base64
  //   data[JsonKeys.images] = await Future.wait(images.map((img) async {
  //     final bytes = await File(img.filePath).readAsBytes();
  //     final base64String = base64Encode(bytes);
  //
  //     return {
  //       'fileName': img.filePath.split('/').last,
  //       'base64': base64String,
  //       'isMain': img.isMain ?? false,
  //     };
  //   }));
  //
  //   return data;
  // }
  Future<Map<String, dynamic>> toJson() async {
    final Map<String, dynamic> data = {
      JsonKeys.operation: currentPropertyOperationType,
      JsonKeys.title: title,
      JsonKeys.description: description,
      JsonKeys.price: price,
      JsonKeys.city: int.tryParse(city),
      JsonKeys.latitude: double.tryParse(latitude),
      JsonKeys.longitude: double.tryParse(longitude),
      JsonKeys.amenities: amenities,
      JsonKeys.propertySubType: int.tryParse(propertySubType),
    };

    if (monthlyRentPeriod != null) {
      data[JsonKeys.monthlyRentPeriod] = monthlyRentPeriod;
    }
    if (isRenewable != null) {
      data[JsonKeys.isRenewable] = isRenewable;
    }
    if (paymentMethod != null) {
      data[JsonKeys.paymentMethod] = paymentMethod;
    }

    // Convert image files to base64 (legacy method)
    data[JsonKeys.images] = await Future.wait(images.map((img) async {
      final bytes = await File(img.filePath).readAsBytes();
      final base64String = base64Encode(bytes);

      return {
        'fileName': img.filePath.split('/').last,
        'base64': base64String,
        'isMain': img.isMain ?? false,
      };
    }));

    return data;
  }

  /// Nouvelle méthode pour créer un JSON avec des URLs d'images (upload direct)
  Future<Map<String, dynamic>> toJsonWithImageUrls(List<String> imageUrls) async {
    final Map<String, dynamic> data = {
      JsonKeys.operation: currentPropertyOperationType,
      JsonKeys.title: title,
      JsonKeys.description: description,
      JsonKeys.price: price,
      JsonKeys.city: int.tryParse(city),
      JsonKeys.latitude: double.tryParse(latitude),
      JsonKeys.longitude: double.tryParse(longitude),
      JsonKeys.amenities: amenities,
      JsonKeys.propertySubType: int.tryParse(propertySubType),
    };

    if (monthlyRentPeriod != null) {
      data[JsonKeys.monthlyRentPeriod] = monthlyRentPeriod;
    }
    if (isRenewable != null) {
      data[JsonKeys.isRenewable] = isRenewable;
    }
    if (paymentMethod != null) {
      data[JsonKeys.paymentMethod] = paymentMethod;
    }

    // Utiliser les URLs d'images uploadées directement
    data[JsonKeys.images] = imageUrls.asMap().entries.map((entry) {
      final index = entry.key;
      final imageUrl = entry.value;
      
      return {
        'fileName': 'image_$index.jpg',
        'imageUrl': imageUrl, // Nouvelle propriété
        'isMain': index == 0, // La première image est principale
      };
    }).toList();

    return data;
  }
}

class PropertyImage {
  final String filePath;
  final bool? isMain;
  PropertyImage({required this.filePath, this.isMain});
}