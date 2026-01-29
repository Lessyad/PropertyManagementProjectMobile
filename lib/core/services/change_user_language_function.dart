import 'package:dio/dio.dart';
import 'package:enmaa/core/services/service_locator.dart';

import '../../features/home_module/home_imports.dart';
import '../constants/api_constants.dart';
import 'dio_service.dart';
import 'handle_api_request_service.dart';

Future<void> updateUserLanguage( String language ) async {

  final dio = ServiceLocator.getIt<DioService>();

  final result = await HandleRequestService.handleApiCall<void>(
        () async {
      final response = await dio.patch(
        url: ApiConstants.user,
        // data: FormData.fromMap({
        //   "language": language,
        // }),
        data: {
          "language": language,
        },
        // options: Options(contentType: 'multipart/form-data'
        options: Options(contentType: Headers.jsonContentType
        ),
      );
    },
  );
}
