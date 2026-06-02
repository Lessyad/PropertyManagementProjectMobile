import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:enmaa/core/constants/api_constants.dart';
import 'package:enmaa/core/services/auth_service.dart';
import 'package:enmaa/core/services/shared_preferences_service.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioService {
  final Dio dio;
  Future<String?>? _refreshTokenFuture;

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
            final accessToken = SharedPreferencesService().accessToken;
            options.headers.addAll({
              "Accept-Language": SharedPreferencesService().language,
            });

            if (_shouldAttachAuthorizationHeader(options) &&
                accessToken.isNotEmpty) {
              options.headers["Authorization"] = 'Bearer $accessToken';
            }

            return handler.next(options);
          },
          onError: (DioException error, ErrorInterceptorHandler handler) async {
            if (!_shouldAttemptTokenRefresh(error)) {
              return handler.next(error);
            }

            final newAccessToken = await _refreshAccessToken();

            if (newAccessToken == null || newAccessToken.isEmpty) {
              await AuthService().performLogout();
              return handler.next(error);
            }

            try {
              final retryResponse = await _retryRequest(
                error.requestOptions,
                newAccessToken,
              );
              return handler.resolve(retryResponse);
            } catch (retryError) {
              if (retryError is DioException &&
                  retryError.response?.statusCode == 401) {
                await AuthService().performLogout();
              }
            }

            return handler.next(error);
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

  bool _shouldAttachAuthorizationHeader(RequestOptions options) {
    final extraFlag = options.extra['requiresAuth'];
    if (extraFlag is bool) {
      return extraFlag;
    }

    return !_isAuthFreeEndpoint(options.path);
  }

  bool _isAuthFreeEndpoint(String path) {
    return path == ApiConstants.login ||
        path == ApiConstants.signUp ||
        path == ApiConstants.sendOTP ||
        path == ApiConstants.verifyOTP ||
        path == ApiConstants.resetPassword ||
        path == ApiConstants.refreshToken;
  }

  bool _shouldAttemptTokenRefresh(DioException error) {
    if (error.response?.statusCode != 401) {
      return false;
    }

    if (SharedPreferencesService().accessToken.isEmpty ||
        SharedPreferencesService().refreshToken.isEmpty) {
      return false;
    }

    final requestOptions = error.requestOptions;
    if (requestOptions.extra['skipRefresh'] == true ||
        requestOptions.path == ApiConstants.refreshToken) {
      return false;
    }

    return true;
  }

  Future<String?> _refreshAccessToken() async {
    if (_refreshTokenFuture != null) {
      return _refreshTokenFuture;
    }

    final completer = Future<String?>(() async {
      final refreshToken = SharedPreferencesService().refreshToken;
      if (refreshToken.isEmpty) {
        return null;
      }

      try {
        final refreshDio = Dio(
          BaseOptions(
            connectTimeout: dio.options.connectTimeout,
            receiveTimeout: dio.options.receiveTimeout,
            responseType: ResponseType.json,
            headers: {
              'content-type': 'application/json',
              'Accept-Language': SharedPreferencesService().language,
            },
          ),
        );

        final response = await refreshDio.post(
          ApiConstants.refreshToken,
          data: {'refreshToken': refreshToken},
          options: Options(
            extra: {
              'skipRefresh': true,
              'requiresAuth': false,
            },
          ),
        );

        final newAccessToken = response.data['access'] as String?;
        final newRefreshToken = response.data['refresh'] as String?;

        if (newAccessToken == null || newAccessToken.isEmpty) {
          return null;
        }

        await SharedPreferencesService().setAccessToken(newAccessToken);
        if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
          await SharedPreferencesService().setRefreshToken(newRefreshToken);
        }

        log('Access token refreshed successfully');
        return newAccessToken;
      } catch (error) {
        log('Refresh token failed: $error');
        return null;
      } finally {
        _refreshTokenFuture = null;
      }
    });

    _refreshTokenFuture = completer;
    return completer;
  }

  Future<Response<dynamic>> _retryRequest(
    RequestOptions requestOptions,
    String accessToken,
  ) {
    final headers = Map<String, dynamic>.from(requestOptions.headers);
    headers['Authorization'] = 'Bearer $accessToken';

    final options = Options(
      method: requestOptions.method,
      headers: headers,
      responseType: requestOptions.responseType,
      contentType: requestOptions.contentType,
      followRedirects: requestOptions.followRedirects,
      receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
      extra: Map<String, dynamic>.from(requestOptions.extra)
        ..['skipRefresh'] = true,
      listFormat: requestOptions.listFormat,
      maxRedirects: requestOptions.maxRedirects,
      persistentConnection: requestOptions.persistentConnection,
      receiveTimeout: requestOptions.receiveTimeout,
      requestEncoder: requestOptions.requestEncoder,
      responseDecoder: requestOptions.responseDecoder,
      sendTimeout: requestOptions.sendTimeout,
      validateStatus: requestOptions.validateStatus,
    );

    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
      cancelToken: requestOptions.cancelToken,
      onReceiveProgress: requestOptions.onReceiveProgress,
      onSendProgress: requestOptions.onSendProgress,
    );
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
