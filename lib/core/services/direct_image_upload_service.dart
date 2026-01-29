import 'dart:io';
import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'dio_service.dart';

class DirectImageUploadService {
  final DioService _dioService;

  DirectImageUploadService({required DioService dioService}) : _dioService = dioService;

  /// Workflow complet d'upload d'images :
  /// 1. Demande des URLs SAS au backend
  /// 2. Upload direct vers Azure Blob Storage
  /// 3. Retourne les URLs finales pour la création d'entité
  Future<List<String>> uploadImages(List<File> imageFiles, String entityType) async {
    try {
      // Étape 1 : Demander les URLs SAS
      // print('📤 Demande de ${imageFiles.length} URLs SAS pour $entityType...');
      final sasUrls = await _requestSasUrls(imageFiles.length, entityType);
      
      // Étape 2 : Upload chaque image vers Azure Blob
      print('⬆️ Upload direct vers Azure Blob Storage...');
      final uploadedUrls = <String>[];
      
      for (int i = 0; i < imageFiles.length; i++) {
        final imageFile = imageFiles[i];
        final sasUrl = sasUrls[i];
        
        final finalUrl = await _uploadToAzureBlob(imageFile, sasUrl);
        uploadedUrls.add(finalUrl);
        
        print('✅ Image ${i + 1}/${imageFiles.length} uploadée: ${finalUrl.substring(0, 50)}...');
      }
      
      // Étape 3 : Vérifier que toutes les images existent
      print('🔍 Vérification des uploads...');
      final allUploaded = await _verifyUploads(uploadedUrls);
      
      if (!allUploaded) {
        throw Exception('Certaines images n\'ont pas été uploadées correctement');
      }
      
      print('🎉 Tous les uploads terminés avec succès !');
      return uploadedUrls;
      
    } catch (e) {
      print('❌ Erreur lors de l\'upload d\'images: $e');
      throw Exception('Erreur lors de l\'upload d\'images: $e');
    }
  }

  /// Étape 1 : Demander les URLs SAS au backend
  Future<List<SasUploadUrl>> _requestSasUrls(int count, String entityType) async {
    final response = await _dioService.dio.post(
      ApiConstants.generateUploadUrls,
      data: {
        'count': count,
        'entityType': entityType,
      },
    );

    if (response.statusCode == 200) {
      final uploadUrls = (response.data['uploadUrls'] as List)
          .map((item) => SasUploadUrl.fromJson(item))
          .toList();
      return uploadUrls;
    } else {
      throw Exception('Échec de la génération des URLs SAS: ${response.statusCode}');
    }
  }

  /// Étape 2 : Upload direct vers Azure Blob Storage
  Future<String> _uploadToAzureBlob(File imageFile, SasUploadUrl sasUrl) async {
    try {
      // Lire les bytes du fichier
      final bytes = await imageFile.readAsBytes();
      
      // Créer un client Dio séparé pour Azure (sans headers d'auth)
      final azureDio = Dio();
      
      // Upload vers Azure Blob avec l'URL SAS
      final response = await azureDio.put(
        sasUrl.uploadUrl,
        data: bytes,
        options: Options(
          headers: {
            'x-ms-blob-type': 'BlockBlob',
            'Content-Type': _getContentType(imageFile.path),
          },
          validateStatus: (status) => status! < 300,
        ),
      );

      if (response.statusCode == 201) {
        return sasUrl.finalUrl; // Retourner l'URL publique finale
      } else {
        throw Exception('Échec de l\'upload Azure: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'upload vers Azure: $e');
    }
  }

  /// Étape 3 : Vérifier que les uploads ont réussi
  Future<bool> _verifyUploads(List<String> imageUrls) async {
    try {
      final response = await _dioService.dio.post(
        ApiConstants.verifyUploads,
        data: {
          'imageUrls': imageUrls,
        },
      );

      if (response.statusCode == 200) {
        return response.data['allImagesUploaded'] ?? false;
      }
      return false;
    } catch (e) {
      print('⚠️ Erreur lors de la vérification: $e');
      return false; // En cas d'erreur, on considère que c'est OK (fallback)
    }
  }

  /// Déterminer le Content-Type basé sur l'extension du fichier
  String _getContentType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'bmp':
        return 'image/bmp';
      default:
        return 'image/jpeg'; // Défaut
    }
  }
}

/// Modèle pour les URLs SAS reçues du backend
class SasUploadUrl {
  final String blobName;
  final String uploadUrl;
  final String finalUrl;
  final DateTime expiryTime;

  SasUploadUrl({
    required this.blobName,
    required this.uploadUrl,
    required this.finalUrl,
    required this.expiryTime,
  });

  factory SasUploadUrl.fromJson(Map<String, dynamic> json) {
    return SasUploadUrl(
      blobName: json['blobName'],
      uploadUrl: json['uploadUrl'],
      finalUrl: json['finalUrl'],
      expiryTime: DateTime.parse(json['expiryTime']),
    );
  }
}

/// Modèle pour une image avec son URL finale
class UploadedImage {
  final String url;
  final String fileName;
  final bool isMain;

  UploadedImage({
    required this.url,
    required this.fileName,
    this.isMain = false,
  });

  Map<String, dynamic> toJson() => {
    'imageUrl': url,
    'fileName': fileName,
    'isMain': isMain,
  };
}
