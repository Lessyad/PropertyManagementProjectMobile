import 'package:dartz/dartz.dart';
import 'package:enmaa/features/my_booking/domain/repository/base_booking_repository.dart';

import '../../../../core/errors/failure.dart';
import '../../../real_estates/domain/entities/base_property_entity.dart';

class GetMyBookingUseCase {
  final BaseMyBookingRepository _baseBookingRepository;

  GetMyBookingUseCase(this._baseBookingRepository);

  Future<Either<Failure, List<PropertyEntity>>> call({
    Map<String, dynamic>? filters,
  }) async {
    return await _baseBookingRepository.getMyBookings(filters: filters);
  }
}