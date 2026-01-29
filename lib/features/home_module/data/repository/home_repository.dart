
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:enmaa/features/home_module/data/models/banner_model.dart';
import 'package:enmaa/features/home_module/domain/entities/app_service_entity.dart';
import 'package:enmaa/features/home_module/domain/entities/banner_entity.dart';
import 'package:enmaa/features/home_module/domain/entities/notification_entity.dart';

import '../../../../core/entites/image_entity.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/handle_api_request_service.dart';
import '../../domain/repository/base_home_repository.dart';
import '../data_source/remote_data/home_remote_data_source.dart';


class HomeRepository extends BaseHomeRepository {
  final BaseHomeRemoteData baseHomeRemoteData;

  HomeRepository({ required this.baseHomeRemoteData});


  @override
  Future<Either<Failure, List<ImageEntity>>> getBannersData() async{
    return await HandleRequestService.handleApiCall<List<ImageEntity>>(() async {
      final result = await baseHomeRemoteData.getBanners();
      return result;
    });
  }

  @override
  Future<Either<Failure, List<AppServiceEntity>>> getAppServicesData() async{
    return await HandleRequestService.handleApiCall<List<AppServiceEntity>>(() async {
      final result = await baseHomeRemoteData.getAppServicesData();
      return result;
    });
  }

  @override
  Future<Either<Failure, void>> updateUserLocation(String cityID) async{
    return HandleRequestService.handleApiCall<void>(() async {
      await baseHomeRemoteData.updateUserLocation(cityID);
    });
  }

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() {
    return HandleRequestService.handleApiCall<List<NotificationEntity>>(() async {
      final result = await baseHomeRemoteData.getNotifications();
      return result;
    });
  }


}