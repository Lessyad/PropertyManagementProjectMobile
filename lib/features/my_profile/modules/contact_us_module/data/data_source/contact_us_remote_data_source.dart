import 'package:dio/dio.dart';
import 'package:enmaa/features/my_profile/modules/contact_us_module/data/models/contact_us_request_model.dart';
import 'package:enmaa/features/my_profile/modules/user_appointments/data/models/appointment_model.dart';
import 'package:enmaa/features/real_estates/data/models/property_model.dart';
import 'package:enmaa/features/real_estates/domain/entities/base_property_entity.dart';

import '../../../../../../core/constants/api_constants.dart';
import '../../../../../../core/services/dio_service.dart';

abstract class BaseContactUsRemoteData {
  Future<void> sendContactUsData (ContactUsRequestModel data);
}

class ContactUsRemoteDataSource extends BaseContactUsRemoteData {
  DioService dioService;

  ContactUsRemoteDataSource({required this.dioService});


  @override
  Future<void> sendContactUsData(ContactUsRequestModel data)async {
    // FormData formData = FormData.fromMap(data.toJson());
    // final response = await dioService.post(
    //   url: ApiConstants.contact,
    //   data: formData
    //   ,
    //   options: Options(contentType: 'application/json'
    //   ),
    // );
    final reponse = await dioService.post(url: ApiConstants.contact,
    data: data.toJson(),
      options: Options(contentType: Headers.jsonContentType),
    );

  }



}