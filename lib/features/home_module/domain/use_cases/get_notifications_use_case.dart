import 'package:dartz/dartz.dart';
import 'package:enmaa/features/home_module/domain/entities/banner_entity.dart';
import 'package:enmaa/features/home_module/domain/entities/notification_entity.dart';
import '../../../../core/errors/failure.dart';
import '../repository/base_home_repository.dart';

class GetNotificationsUseCase {
  final BaseHomeRepository _baseHomeRepository;

  GetNotificationsUseCase(this._baseHomeRepository);

  Future<Either<Failure, List<NotificationEntity>>> call( ) =>
      _baseHomeRepository.getNotifications();
}