import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import '../translation/locale_keys.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);

  factory ServerFailure.fromDioError(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.cancel:
        return ServerFailure(LocaleKeys.requestCancelled.tr());

      case DioExceptionType.connectionTimeout:
        return ServerFailure(LocaleKeys.connectionTimeout.tr());

      case DioExceptionType.receiveTimeout:
        return ServerFailure(LocaleKeys.receiveTimeout.tr());

      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          dioException.response?.statusCode,
          dioException.response?.data,
          dioException.response?.data,
        );

      case DioExceptionType.sendTimeout:
        return ServerFailure(LocaleKeys.sendTimeout.tr());

      case DioExceptionType.unknown:
        return ServerFailure(LocaleKeys.noInternet.tr());

      default:
        return ServerFailure(LocaleKeys.somethingWentWrong.tr());
    }
  }

  factory ServerFailure.fromResponse(
    int? statusCode,
    dynamic error,
    dynamic messageError,
  ) {
    String errorMessage = LocaleKeys.somethingWentWrong.tr();

    // Extraire le message d'erreur du serveur si possible
    if (messageError is Map<String, dynamic>) {
      final errors = messageError['errors'];

      if (errors is List && errors.isNotEmpty) {
        final firstError = errors.first;
        if (firstError is Map<String, dynamic>) {
          errorMessage = firstError['detail']?.toString() ?? errorMessage;
        } else if (firstError is String) {
          errorMessage = firstError;
        }
      }
    } else if (messageError is String) {
      final messageStr = messageError as String;
      errorMessage = messageStr;

      if (messageStr.contains('Un utilisateur avec ce numéro existe déjà') ||
          messageStr.contains('User with this phone number already exists')) {
        errorMessage = 'Un utilisateur avec ce numéro de téléphone existe déjà';
      }
    }

    String msg(dynamic fallback) {
      if (messageError is Map<String, dynamic>) {
        final m = messageError['message'];
        if (m != null) return m.toString();
      }
      return fallback;
    }

    switch (statusCode) {
      case 400:
        return ServerFailure(msg(LocaleKeys.badRequest.tr()));

      case 401:
        return ServerFailure(msg(LocaleKeys.unauthorized.tr()));

      case 403:
        return ServerFailure(msg(LocaleKeys.forbidden.tr()));

      case 404:
        return ServerFailure(
          msg((error is Map && error['message'] != null)
              ? error['message'].toString()
              : LocaleKeys.notFound.tr()),
        );

      case 422:
        final joinMsg = messageError is Map
            ? messageError.values.join(' , ').replaceAll(RegExp(r'[^\w\s]+'), '')
            : '';
        return ServerFailure(msg(joinMsg.isEmpty ? errorMessage : joinMsg));

      case 500:
        if (messageError is Map<String, dynamic>) {
          final detail = messageError['detail']?.toString() ?? '';
          if (detail.isNotEmpty) {
            return ServerFailure(ServerFailure._parseBankilyError(detail));
          }
        }
        return ServerFailure(msg(LocaleKeys.internalServerError.tr()));

      case 502:
        return ServerFailure(msg(LocaleKeys.badGateway.tr()));

      default:
        return ServerFailure(msg(LocaleKeys.somethingWentWrong.tr()));
    }
  }

  static String _parseBankilyError(String detail) {
    final lower = detail.toLowerCase();
    if (lower.contains('numero de mobile') ||
        lower.contains("n'est pas enregistre") ||
        lower.contains('not registered') ||
        lower.contains('mobile non enregistre')) {
      return LocaleKeys.bankilyErrorPhoneNotRegistered.tr();
    }
    if (lower.contains('code de verification') ||
        lower.contains('passcode') ||
        lower.contains('code incorrect') ||
        lower.contains('invalid passcode') ||
        lower.contains('code invalide')) {
      return LocaleKeys.bankilyErrorInvalidPasscode.tr();
    }
    if (lower.contains('solde') ||
        lower.contains('insufficient') ||
        lower.contains('insuffisant') ||
        lower.contains('balance')) {
      return LocaleKeys.bankilyErrorInsufficientBalance.tr();
    }
    if (lower.contains('operation') &&
        (lower.contains('exist') || lower.contains('deja') || lower.contains('already'))) {
      return LocaleKeys.bankilyErrorOperationExists.tr();
    }
    if (lower.contains('paiement') || lower.contains('payment') ||
        lower.contains('echoue') || lower.contains('échoué')) {
      return '${LocaleKeys.bankilyPaymentError.tr()} : $detail';
    }
    return detail;
  }
}

class LocalDatabaseFailure extends Failure {
  const LocalDatabaseFailure(super.message);

  factory LocalDatabaseFailure.fromError(String error) {
    return LocalDatabaseFailure(error);
  }
}