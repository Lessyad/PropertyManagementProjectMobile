import 'package:dartz/dartz.dart';

import '../../../../../../core/errors/failure.dart';
import '../../../../../../core/services/handle_api_request_service.dart';
import '../../domain/entity/rental_history_entity.dart';
import '../../domain/repository/base_rental_history_repository.dart';
import '../data_source/rental_history_remote_data_source.dart';

class RentalHistoryRepository extends BaseRentalHistoryRepository {
  final BaseRentalHistoryRemoteDataSource remoteDataSource;

  RentalHistoryRepository({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<RentalHistoryEntity>>> getRentalHistory(
    Map<String, dynamic> data,
  ) {
    return HandleRequestService.handleApiCall<List<RentalHistoryEntity>>(
      () async {
        final rentals = await remoteDataSource.getRentalHistory(data);
        return List<RentalHistoryEntity>.from(rentals);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> cancelRental(int rentalId) {
    return HandleRequestService.handleApiCall<bool>(
      () async {
        await remoteDataSource.cancelRental(rentalId);
        return true;
      },
    );
  }
}
