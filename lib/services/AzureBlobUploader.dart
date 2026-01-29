// import 'dart:io';
// import 'package:azblob/azblob.dart';
//
// class AzureBlobUploader {
//   static const String sasUrl =
//       "https://<storage-account-name>.blob.core.windows.net/<container-name>?<sas-token>"; // colle ton SAS complet ici
//
//   static Future<String> uploadImage(File imageFile) async {
//     final fileName = imageFile.path.split('/').last;
//
//     try {
//       // final blobClient = AzBlob(sasUrl);
//       final result = await blobClient.putBlob(
//         fileName,
//         bodyBytes: await imageFile.readAsBytes(),
//         contentType: 'image/jpeg',
//       );
//
//       if (result.statusCode == 201) {
//         return "${sasUrl.split('?')[0]}/$fileName";
//       } else {
//         throw Exception("Upload failed with status: ${result.statusCode}");
//       }
//     } catch (e) {
//       throw Exception("Erreur upload Azure Blob: $e");
//     }
//   }
// }
