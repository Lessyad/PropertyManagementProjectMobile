import 'package:dio/dio.dart';
import 'package:enmaa/features/home_module/data/models/app_service_model.dart';
import 'package:enmaa/features/home_module/data/models/banner_model.dart';
import 'package:enmaa/features/preview_property/data/models/day_and_hours_model.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/entites/image_entity.dart';
import '../../../../../core/services/dio_service.dart';
import '../models/add_new_preview_time_request_model.dart';

abstract class BasePreviewPropertyDataSource {
  Future<List<DayAndHoursModel>> getPropertyPreviewAvailableHours(String propertyId);
  Future<String> getInspectionAmountToBePaid(String propertyId);
  Future<void> addNewPreviewTime(AddNewPreviewRequestModel data);
  Future<({String approvalUrl, String reservationToken})> initiatePayPalViewingRequest(AddNewPreviewRequestModel data);
}

class PreviewPropertyRemoteDataSource extends BasePreviewPropertyDataSource {
  DioService dioService;

  PreviewPropertyRemoteDataSource({required this.dioService});



  @override
  Future<List<DayAndHoursModel>> getPropertyPreviewAvailableHours(String propertyId) async {
    print('>>> Appel API pour récupérer les jours occupés de la propriété: $propertyId');
    final response = await dioService.get(
      url: '${ApiConstants.propertyBusyDays}/$propertyId/',
    );
    print('>>> Réponse brute: ${response.data}');
    List<dynamic> jsonResponse = response.data is List ? response.data : [];
    print('>>> JSON après validation du type List: $jsonResponse');
    List<Map<String, dynamic>> busyDays = jsonResponse
        .map((day) => Map<String, dynamic>.from(day as Map))
        .toList();

    List<DayAndHoursModel> availableHours = DayAndHoursModel.generateAvailableHoursFor60Days(busyDays);
    print('>>> Heures disponibles générées: $availableHours');
    return availableHours;
  }

  @override
  Future<String> getInspectionAmountToBePaid(String propertyId) async {
    final response = await dioService.get(
      url: '${ApiConstants.propertyOrderDetails}/$propertyId/',
    );
    return response.data?['viewing_request_amount']?.toString() ?? '0';
  }

  @override
  Future<void> addNewPreviewTime(AddNewPreviewRequestModel data) async {
    await dioService.post(
      url: '${ApiConstants.preview}/',
      data: data.toJson(),
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  @override
  Future<({String approvalUrl, String reservationToken})> initiatePayPalViewingRequest(
      AddNewPreviewRequestModel data) async {
    final res = await dioService.post(
      url: ApiConstants.previewPayPalInitiate,
      data: data.toJson(),
      options: Options(contentType: Headers.jsonContentType),
    );
    return (
      approvalUrl: res.data['approvalUrl'] as String,
      reservationToken: res.data['reservationToken'] as String,
    );
  }
}