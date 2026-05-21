import 'dart:developer' as developer;
import '../../core_import.dart';

class ErrorHandler {
  static void log(dynamic error, [StackTrace? stack]) {
    developer.log('❌ ERROR: $error', name: 'ErrorHandler');
    if (stack != null) {
      developer.log('STACKTRACE: $stack', name: 'ErrorHandler');
    }
  }

  static String message(dynamic error) {
    if (error == null) return 'Something went wrong. Please try again.';

    if (error is ApiFailure) return error.userMessage;

    if (error is DioException) {
      final code = error.response?.statusCode;
      final msg = error.message?.toLowerCase() ?? '';

      if (code == 400) {
        return 'Some information seems missing or incorrect. Please review and try again.';
      }
      if (code == 401) {
        return 'Your session has expired. Please login again to continue.';
      }
      if (code == 403) {
        return "You don't have access to this feature. Please contact support.";
      }
      if (code == 404) return 'No information is available at the moment.';
      if (code == 500) {
        return "We're having trouble right now. Please try again later.";
      }
      if (msg.contains('timeout') || msg.contains('connection')) {
        return 'Unable to connect. Please check your internet connection and try again.';
      }
      return 'Network error. Please try again.';
    }

    if (error is FormatException) {
      return 'Something went wrong while processing your data.';
    }

    if (error is ArgumentError) {
      return 'Some information is invalid. Please check and try again.';
    }

    if (error is TypeError) return 'Something went wrong. Please try again.';

    return 'Something went wrong. Please try again.';
  }

  static String handle(dynamic error, [StackTrace? stack]) {
    log(error, stack);
    return message(error);
  }
}
