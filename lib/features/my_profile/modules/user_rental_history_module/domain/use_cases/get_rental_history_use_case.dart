import 'package:dartz/dartz.dart';

import '../../../../../../core/errors/failure.dart';
import '../entity/rental_history_entity.dart';
import '../repository/base_rental_history_repository.dart';

class GetRentalHistoryUseCase {
  final BaseRentalHistoryRepository repository;

  GetRentalHistoryUseCase(this.repository);

  Future<Either<Failure, List<RentalHistoryEntity>>> call(
    Map<String, dynamic> data,
  ) {
    return repository.getRentalHistory(data);
  }
}
