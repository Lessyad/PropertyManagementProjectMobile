import 'package:dartz/dartz.dart';
import '../../../../../../core/errors/failure.dart';
import '../../data/models/contact_us_request_model.dart';

abstract class BaseContactUsRepository {
  Future<Either<Failure, void>> contactUs(ContactUsRequestModel params);
}