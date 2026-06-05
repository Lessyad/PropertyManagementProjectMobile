import 'package:dartz/dartz.dart';

import '../../../../../../core/errors/failure.dart';
import '../repository/base_rental_history_repository.dart';

class CancelRentalUseCase {
  final BaseRentalHistoryRepository repository;

  CancelRentalUseCase(this.repository);

  Future<Either<Failure, bool>> call(int rentalId) {
    return repository.cancelRental(rentalId);
  }
}
