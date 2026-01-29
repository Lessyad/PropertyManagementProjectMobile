import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:enmaa/core/services/shared_preferences_service.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DioService {
  final Dio dio;

  DioService({
    required this.dio,
  }) {
    {
      dio
      // ..options.baseUrl = ApiConstance.baseUrl
        ..options.connectTimeout = const Duration(minutes: 2)
        ..options.receiveTimeout = const Duration(minutes: 2)
        ..options.responseType = ResponseType.json
        ..options.headers = {'content-type': 'application/json'};

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {

            final prefs = await SharedPreferences.getInstance();
            Object? accessToken = prefs.get('access_token') ;
            log('access token is $accessToken');
            options.headers.addAll({
              "Authorization": 'Bearer $accessToken',
              "Accept-Language": SharedPreferencesService().language,
            });
          

           /* var userBox = await Hive.openBox<User>('userBox');
            var authLocalDataSource = AuthenticationLocalDataSourceImp(userBox);
            User? user = authLocalDataSource.getUser();

            options.headers.addAll({
              if (user != null) "Authorization": 'Bearer ${user.token}',
              "Accept-Language": 'en',
              "X-API-KEY": ApiConstants.pointsToken,
            });
*/



            return handler.next(options);
          },
        ),
      );
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }
  }

  String createBasicAuthHeader(String username, String password) {
    String credentials = '$username:$password';
    String encodedCredentials = base64.encode(
        utf8.encode(credentials));
    return 'Basic $encodedCredentials';
  }

  Future<Response> get({
    required String url,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await dio.get(
        url,
        data: body,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: options,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future post({
    required String url,
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    FormData? formData,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
  //  try {
      final Response response = await dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return response;
    // } catch (e) {
    //   rethrow;
    // }
  }

  Future<Response> put({
    required String url,
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> patch({
    required String url,
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await dio.patch(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> delete({
    required String url,
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}