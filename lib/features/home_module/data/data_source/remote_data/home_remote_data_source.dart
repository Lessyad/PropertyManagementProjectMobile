import 'package:dio/dio.dart';
import 'package:enmaa/core/models/image_model.dart';
import 'package:enmaa/features/home_module/data/models/app_service_model.dart';
import 'package:enmaa/features/home_module/data/models/banner_model.dart';
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
  Future<List<ImageEntity>> getBanners()async {
    final response = await dioService.get(
      url: ApiConstants.banners,
    );

    List<dynamic> jsonResponse = response.data['results'] ?? [];

    List<ImageModel> banners = jsonResponse.map((banner) {
      return ImageModel.fromJson(banner);
    }).toList();


    return banners;
  }

  @override
  Future<List<AppServiceModel>> getAppServicesData() async {
    return [];
  }

  @override
  Future<void> updateUserLocation(String cityID) async{
    final response = await dioService.patch(
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

    List<dynamic> jsonResponse = response.data['results'] ?? [];

    List<NotificationModel> notifications = jsonResponse.map((notification) {
      return NotificationModel.fromJson(notification);
    }).toList();


    return notifications;
  }

}