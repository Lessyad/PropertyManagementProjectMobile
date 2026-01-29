import 'package:dartz/dartz.dart';
import 'package:enmaa/features/my_profile/modules/contact_us_module/data/data_source/contact_us_remote_data_source.dart';
import 'package:enmaa/features/my_profile/modules/contact_us_module/data/models/contact_us_request_model.dart';
import 'package:enmaa/features/my_profile/modules/contact_us_module/domain/repository/base_contact_us_repository.dart';
import '../../../../../../core/errors/failure.dart';
import '../../../../../../core/services/handle_api_request_service.dart';


class ContactUsRepository extends BaseContactUsRepository {
  final BaseContactUsRemoteData baseContactUsRemoteData;

  ContactUsRepository({required this.baseContactUsRemoteData});


  @override
  Future<Either<Failure, void>> contactUs(ContactUsRequestModel params) {
    return HandleRequestService.handleApiCall<void>(() async {
      final result = await baseContactUsRemoteData.sendContactUsData(params);
      return result;
    });
  }


}