import 'package:dartz/dartz.dart';

import '../../../../../../core/errors/failure.dart';
import '../entity/rental_history_entity.dart';

abstract class BaseRentalHistoryRepository {
  Future<Either<Failure, List<RentalHistoryEntity>>> getRentalHistory(
    Map<String, dynamic> data,
  );
}
