import 'package:dartz/dartz.dart';
import 'package:enmaa/features/home_module/domain/entities/app_service_entity.dart';
import '../../../../core/errors/failure.dart';
import '../repository/base_home_repository.dart';

class GetAppServicesUseCase {
  final BaseHomeRepository _baseHomeRepository;

  GetAppServicesUseCase(this._baseHomeRepository);

  Future<Either<Failure, List<AppServiceEntity>>> call( ) =>
      _baseHomeRepository.getAppServicesData();
}