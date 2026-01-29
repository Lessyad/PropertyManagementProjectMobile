import 'package:dartz/dartz.dart';
import 'package:enmaa/features/my_booking/data/data_source/my_booking_remote_data_source.dart';
import 'package:enmaa/features/my_booking/domain/repository/base_booking_repository.dart';
import 'package:enmaa/features/real_estates/domain/entities/base_property_entity.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/services/handle_api_request_service.dart';


class MyBookingRepository extends BaseMyBookingRepository {
  final BaseMyBookingRemoteData baseMyBookingRemoteData;

  MyBookingRepository({required this.baseMyBookingRemoteData});



  @override
  Future<Either<Failure, List<PropertyEntity>>> getMyBookings({Map<String, dynamic>? filters}) {
   return HandleRequestService.handleApiCall<List<PropertyEntity>>(() async {
     final result = await baseMyBookingRemoteData.getMyBookings(filters: filters);
     return result;
   });
  }
}