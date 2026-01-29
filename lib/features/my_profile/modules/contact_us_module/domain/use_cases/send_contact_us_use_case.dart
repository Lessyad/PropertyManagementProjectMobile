import 'package:dartz/dartz.dart';
import 'package:enmaa/features/my_profile/modules/contact_us_module/domain/entities/contact_us_request_entity.dart';
import 'package:enmaa/features/my_profile/modules/contact_us_module/domain/repository/base_contact_us_repository.dart';

import '../../../../../../core/errors/failure.dart';
import '../../data/models/contact_us_request_model.dart';

class SendContactUsUseCase {

  final BaseContactUsRepository _baseContactUsRepository;

  SendContactUsUseCase(this._baseContactUsRepository);

  Future<Either<Failure, void>> call(
      ContactUsRequestModel contactUsRequestEntity,
      ) async {
    return await _baseContactUsRepository.contactUs(contactUsRequestEntity);
  }

}