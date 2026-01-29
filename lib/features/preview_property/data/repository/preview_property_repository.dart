
import 'package:dartz/dartz.dart';
import 'package:enmaa/features/preview_property/data/data_source/preview_property_remote_data_source.dart';
import 'package:enmaa/features/preview_property/domain/entities/day_and_hours_entity.dart';
import 'package:enmaa/features/preview_property/domain/repository/base_preview_property_repository.dart';

 import '../../../../core/errors/failure.dart';
 import '../../../../core/services/handle_api_request_service.dart';
import '../models/add_new_preview_time_request_model.dart';


class PreviewPropertyRepository extends BasePreviewPropertyRepository {
  final BasePreviewPropertyDataSource basePreviewPropertyDataSource;

  PreviewPropertyRepository({ required this.basePreviewPropertyDataSource});




  @override
  Future<Either<Failure, List<DayAndHoursEntity>>> getPropertyPreviewAvailableHours(String propertyId) async{
    return await HandleRequestService.handleApiCall<List<DayAndHoursEntity>>(() async {
      final result = await basePreviewPropertyDataSource.getPropertyPreviewAvailableHours(propertyId);
      return result;
    });
  }

  @override
  Future<Either<Failure, String>> getInspectionAmountToBePaid(String propertyId) async{
    return await HandleRequestService.handleApiCall<String>(() async {
      final result = await basePreviewPropertyDataSource.getInspectionAmountToBePaid(propertyId);
      return result;
    });
  }

  @override
  Future<Either<Failure, void>> addPreviewTimeForSpecificProperty(AddNewPreviewRequestModel data)async {
    return await HandleRequestService.handleApiCall<void>(() async {
      final result = await basePreviewPropertyDataSource.addNewPreviewTime(data);
      return result;
    });
  }


}