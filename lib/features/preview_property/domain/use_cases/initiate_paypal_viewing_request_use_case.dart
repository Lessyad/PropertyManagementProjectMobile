import 'package:dartz/dartz.dart';
import 'package:enmaa/features/preview_property/data/models/add_new_preview_time_request_model.dart';
import 'package:enmaa/features/preview_property/domain/repository/base_preview_property_repository.dart';
import '../../../../core/errors/failure.dart';

class InitiatePayPalViewingRequestUseCase {
  final BasePreviewPropertyRepository _repository;

  InitiatePayPalViewingRequestUseCase(this._repository);

  Future<Either<Failure, ({String approvalUrl, String reservationToken})>> call(
          AddNewPreviewRequestModel data) =>
      _repository.initiatePayPalViewingRequest(data);
}
