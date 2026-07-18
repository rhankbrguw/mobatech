import 'package:dio/dio.dart';
import 'package:mobatech_app/core/constants/strings/error_strings.dart';

class ErrorHandler {
  static String getMessage(dynamic error) {
    if (error == null) return ErrorStrings.errUnknown;

    if (error is DioException) {
      return _handleDioError(error);
    }

    return _handleStringError(error.toString());
  }

  static String _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.connectionError) {
      return ErrorStrings.errConnection;
    }

    if (error.response?.data != null) {
      final payload = error.response?.data;
      if (payload is Map<String, dynamic>) {
        return _extractMessageFromMap(payload);
      }
    }
    return ErrorStrings.errRequestFailed;
  }

  static String _extractMessageFromMap(Map<String, dynamic> payload) {
    if (payload.containsKey('errors') && payload['errors'] != null) {
      final errors = payload['errors'] as Map<String, dynamic>;
      if (errors.isNotEmpty) {
        final firstError = errors.values.first;
        if (firstError is List && firstError.isNotEmpty) {
          return firstError.first.toString();
        }
      }
    }
    if (payload.containsKey('message')) return payload['message'].toString();
    if (payload.containsKey('error')) return payload['error'].toString();
    return ErrorStrings.errRequestFailed;
  }

  static String _handleStringError(String e) {
    String eLower = e.toLowerCase();

    if (eLower.contains('unauthenticated') || eLower.contains('401')) {
      return ErrorStrings.errSessionExpired;
    }
    if (eLower.contains('unauthorized') || eLower.contains('403')) {
      return ErrorStrings.errUnauthorized;
    }
    if (eLower.contains('validation_error') || eLower.contains('422')) {
      return ErrorStrings.errValidation;
    }
    if (eLower.contains('not_found') || eLower.contains('404')) {
      return ErrorStrings.errNotFound;
    }
    if (eLower.contains('conflict') || eLower.contains('409')) {
      return ErrorStrings.errConflict;
    }
    if (eLower.contains('internal_error') || eLower.contains('500')) {
      return ErrorStrings.errServer;
    }

    if (eLower.contains('invalid credentials') ||
        eLower.contains('password salah') ||
        eLower.contains('user not found')) {
      return ErrorStrings.errInvalidCreds;
    }
    if (eLower.contains('email already exists') ||
        eLower.contains('duplicate')) {
      return ErrorStrings.errEmailExists;
    }

    e = e.replaceAll('Exception:', '').replaceAll('Error:', '').trim();
    if (e.isEmpty) return ErrorStrings.errRequestFailed;
    if (e.length > 50) return ErrorStrings.errTimeout;

    return '${e[0].toUpperCase()}${e.substring(1)}';
  }
}
