import 'package:dartz/dartz.dart';
import 'package:enmaa/features/home_module/domain/entities/app_service_entity.dart';
import 'package:enmaa/features/home_module/domain/entities/banner_entity.dart';

import '../../../../core/entites/image_entity.dart';
import '../../../../core/errors/failure.dart';
import '../entities/notification_entity.dart';


abstract class BaseHomeRepository {
  Future<Either<Failure, List<ImageEntity>>> getBannersData();
  Future<Either<Failure, List<AppServiceEntity>>> getAppServicesData();
  Future<Either<Failure, void>> updateUserLocation(String cityID);

  Future<Either<Failure, List<NotificationEntity>>> getNotifications();

}