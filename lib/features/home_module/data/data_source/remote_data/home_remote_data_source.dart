import 'package:dio/dio.dart';
import 'package:enmaa/core/models/image_model.dart';
import 'package:enmaa/features/home_module/data/models/app_service_model.dart';
import 'package:enmaa/features/home_module/data/models/notification_model.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/entites/image_entity.dart';
import '../../../../../core/services/dio_service.dart';

abstract class BaseHomeRemoteData {
  Future<List<ImageEntity>> getBanners();
  Future<List<AppServiceModel>> getAppServicesData();
  Future<void> updateUserLocation(String cityID);
  Future<List<NotificationModel>> getNotifications();

}

class HomeRemoteDataSource extends BaseHomeRemoteData {
  DioService dioService;

  HomeRemoteDataSource({required this.dioService});

  @override
  Future<List<ImageEntity>> getBanners() async {
    final response = await dioService.get(
      url: ApiConstants.banners,
    );

    final dynamic data = response.data;
    List<dynamic> jsonResponse;
    if (data is List) {
      jsonResponse = data;
    } else if (data is Map) {
      jsonResponse = (data['results'] ?? data['data'] ?? data['banners'] ?? []) as List<dynamic>;
    } else {
      jsonResponse = [];
    }

    return jsonResponse.map((banner) => ImageModel(
      id: banner['id'] ?? 0,
      image: banner['imagePath'] ?? '',
      isMain: true,
    )).toList();
  }

  @override
  Future<List<AppServiceModel>> getAppServicesData() async {
    return [];
  }

  @override
  Future<void> updateUserLocation(String cityID) async{
    await dioService.patch(
      url: ApiConstants.user,
      data: {
        'city_id': cityID,
      },
      options: Options(contentType: 'application/json'),
    );

  }

  @override
  Future<List<NotificationModel>> getNotifications() async{
    final response = await dioService.get(
      url: ApiConstants.notifications,
    );

    final dynamic data = response.data;
    List<dynamic> jsonResponse;
    if (data is List) {
      jsonResponse = data;
    } else if (data is Map) {
      jsonResponse = (data['results'] ?? data['Results'] ?? data['data'] ?? []) as List<dynamic>;
    } else {
      jsonResponse = [];
    }

    List<NotificationModel> notifications = jsonResponse.map((notification) {
      return NotificationModel.fromJson(notification);
    }).toList();


    return notifications;
  }

}
