import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../errors/failure.dart';
import '../errors/server_exception.dart';

class HandleRequestService {
  /// Handles API calls with error handling
  static Future<Either<Failure, T>> handleApiCall<T>(
      Future<T> Function() apiCall) async {
    try {
      final result = await apiCall();
      return Right(result);
    } on DioException catch (error) {
      return Left(ServerFailure.fromDioError(error));
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.message));
    } catch (e) {
      return Left(ServerFailure.fromResponse(
          400, e.toString(), {'message': e.toString()}));
    }
  }

  /// Handles local database or shared preferences operations
  static Future<Either<Failure, T>> handleLocalCall<T>(
      Future<T> Function() localCall) async {
    try {
      final result = await localCall();
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure('Local operation failed: ${e.toString()}'));
    }
  }
}
