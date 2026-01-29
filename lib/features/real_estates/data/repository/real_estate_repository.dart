import 'package:dartz/dartz.dart';
import 'package:enmaa/features/real_estates/data/data_source/remote_data/real_estate_remote_data_source.dart';
import 'package:enmaa/features/real_estates/data/models/property_details_model.dart';
import 'package:enmaa/features/real_estates/domain/entities/property_details_entity.dart';
import 'package:enmaa/features/real_estates/domain/entities/base_property_entity.dart';
import 'package:enmaa/features/real_estates/domain/repository/base_real_estate_repository.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/services/handle_api_request_service.dart';


class RealEstateRepository extends BaseRealEstateRepository {
  final BaseRealEstateRemoteData baseRealEstateRemoteData;

  RealEstateRepository({required this.baseRealEstateRemoteData});

  @override
  Future<Either<Failure, List<PropertyEntity>>> getProperties({
    Map<String, dynamic>? filters,
  }) async {
    return await HandleRequestService.handleApiCall<List<PropertyEntity>>(() async {
      final result = await baseRealEstateRemoteData.getProperties(filters: filters);
      return result;
    });
  }

  @override
  Future<Either<Failure, BasePropertyDetailsEntity>> getPropertyDetails(String propertyId) async {
    return HandleRequestService.handleApiCall<BasePropertyDetailsEntity>(() async {
      final result = await baseRealEstateRemoteData.getPropertyDetails(propertyId);
      return result;
    });
  }
}