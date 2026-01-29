import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../core/services/direct_image_upload_service.dart';
import '../../../../core/services/dio_service.dart';
import '../../data/models/apartment_request_model.dart';
import '../../data/data_source/add_new_real_estate_remote_data_source.dart';

/// Exemple d'utilisation du nouveau système d'upload direct d'images
class DirectUploadExample {
  final DirectImageUploadService _directUploadService;
  final AddNewRealEstateRemoteDataSource _propertyDataSource;

  DirectUploadExample({
    required DirectImageUploadService directUploadService,
    required AddNewRealEstateRemoteDataSource propertyDataSource,
  })  : _directUploadService = directUploadService,
        _propertyDataSource = propertyDataSource;

  /// Exemple d'ajout d'apartment avec upload direct d'images
  Future<void> createApartmentWithDirectUpload({
    required ApartmentRequestModel apartmentRequest,
    required List<File> imageFiles,
  }) async {
    try {
      // 🚀 NOUVELLE MÉTHODE : Upload direct vers Azure
      print('🎯 === DÉBUT UPLOAD DIRECT VERS AZURE ===');
      
      // 1️⃣ Upload les images directement vers Azure Blob Storage
      final imageUrls = await _directUploadService.uploadImages(
        imageFiles, 
        'properties', // Type d'entité
      );
      
      print('✅ ${imageUrls.length} images uploadées vers Azure !');
      for (int i = 0; i < imageUrls.length; i++) {
        print('  📷 Image ${i + 1}: ${imageUrls[i].substring(0, 60)}...');
      }
      
      // 2️⃣ Créer les données de l'apartment avec les URLs d'images
      final apartmentData = await apartmentRequest.toJsonWithImageUrls(imageUrls);
      
      // 3️⃣ Envoyer vers le backend (qui va juste stocker les URLs en base)
      print('📤 Envoi des données vers le backend...');
      await _propertyDataSource.addApartmentWithImageUrls(apartmentData);
      
      print('🎉 Apartment créé avec succès !');
      print('📊 Images stockées: ${imageUrls.length}');
      
    } catch (e) {
      print('❌ Erreur lors de la création avec upload direct: $e');
      throw e;
    }
  }

  /// Pour comparaison : ancienne méthode avec base64
  Future<void> createApartmentWithBase64({
    required ApartmentRequestModel apartmentRequest,
  }) async {
    try {
      // ⚠️ ANCIENNE MÉTHODE : Base64 (plus lente, plus lourde)
      print('⏳ === DÉBUT UPLOAD BASE64 (ANCIENNE MÉTHODE) ===');
      
      // Les images sont converties en base64 dans toJson()
      // Le backend reçoit du base64, le convertit et upload vers Azure
      await _propertyDataSource.addApartment(apartmentRequest);
      
      print('✅ Apartment créé avec base64 !');
      
    } catch (e) {
      print('❌ Erreur lors de la création avec base64: $e');
      throw e;
    }
  }
}

/// Widget d'exemple pour utiliser le service
class DirectUploadExampleWidget extends StatefulWidget {
  @override
  _DirectUploadExampleWidgetState createState() => _DirectUploadExampleWidgetState();
}

class _DirectUploadExampleWidgetState extends State<DirectUploadExampleWidget> {
  late final DirectImageUploadService _uploadService;
  
  @override
  void initState() {
    super.initState();
    _uploadService = DirectImageUploadService(
      dioService: DioService(dio: Dio()), // Initialiser avec une instance Dio
    );
  }
  
  bool _isUploading = false;
  List<String> _uploadedUrls = [];

  /// Exemple d'upload d'images seulement (sans property)
  Future<void> _uploadImagesOnly() async {
    setState(() => _isUploading = true);
    
    try {
      // Simuler la sélection d'images (vous utiliseriez image_picker)
      final imageFiles = <File>[
        // File('/path/to/image1.jpg'),
        // File('/path/to/image2.jpg'),
      ];
      
      if (imageFiles.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Veuillez sélectionner des images')),
        );
        return;
      }
      
      // Upload direct vers Azure
      final urls = await _uploadService.uploadImages(imageFiles, 'properties');
      
      setState(() => _uploadedUrls = urls);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${urls.length} images uploadées avec succès !')),
      );
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Direct Azure')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.cloud_upload, size: 48, color: Colors.blue),
                    SizedBox(height: 8),
                    Text(
                      'Upload Direct vers Azure Blob',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Les images sont uploadées directement vers Azure, '
                      'puis les URLs sont envoyées au backend.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 16),
            
            ElevatedButton.icon(
              onPressed: _isUploading ? null : _uploadImagesOnly,
              icon: _isUploading 
                ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : Icon(Icons.upload),
              label: Text(_isUploading ? 'Upload en cours...' : 'Uploader des Images'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            
            if (_uploadedUrls.isNotEmpty) ...[
              SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'URLs Uploadées:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      ...(_uploadedUrls.map((url) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          '✅ ${url.substring(0, 60)}...',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            color: Colors.green[700],
                          ),
                        ),
                      ))),
                    ],
                  ),
                ),
              ),
            ],
            
            SizedBox(height: 16),
            
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 Avantages:',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800]),
                  ),
                  SizedBox(height: 4),
                  Text('• Upload direct = Plus rapide', style: TextStyle(fontSize: 12)),
                  Text('• Pas de conversion base64 = Moins de mémoire', style: TextStyle(fontSize: 12)),
                  Text('• Backend allégé = Meilleur performance', style: TextStyle(fontSize: 12)),
                  Text('• URLs générées côté Azure = Plus sécurisé', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
