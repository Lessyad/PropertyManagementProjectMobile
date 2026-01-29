import 'package:dartz/dartz.dart';
import 'package:enmaa/features/home_module/domain/entities/banner_entity.dart';
import '../../../../core/entites/image_entity.dart';
import '../../../../core/errors/failure.dart';
import '../repository/base_home_repository.dart';

class GetBannersUseCase {
  final BaseHomeRepository _baseHomeRepository;

  GetBannersUseCase(this._baseHomeRepository);

  Future<Either<Failure, List<ImageEntity>>> call( ) =>
      _baseHomeRepository.getBannersData();
}