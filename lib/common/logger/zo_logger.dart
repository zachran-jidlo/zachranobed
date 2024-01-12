import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart';

/// `ZOLogger` is a utility class for logging messages and exceptions.
/// It supports both console logging with enhanced readability via PrettyPrinter
/// and error logging to Firebase Crashlytics.
class ZOLogger {
  /// Logs a message to the console and Firebase Crashlytics.
  ///
  /// This method differentiates between normal log messages and error messages.
  /// If it's an error message, it records an exception in Firebase Crashlytics
  /// along with logging it to the console using PrettyPrinter for better formatting.
  ///
  /// Parameters:
  ///   - `message` (String): The message to be logged.
  ///   - `isError` (bool, optional): A flag indicating whether the message is an error.
  ///     Defaults to `false`. If `true`, the message is treated as an error.
  static void logMessage(String message, {bool isError = false}) {
    var logger = Logger(printer: PrettyPrinter());

    if (isError) {
      logger.e(message);
      FirebaseCrashlytics.instance.recordError(Exception(message), null);
    } else {
      logger.d(message);
      FirebaseCrashlytics.instance.log(message);
    }
  }

  /// Logs an exception to the console and Firebase Crashlytics.
  ///
  /// This method is specifically designed for exception logging.
  /// It uses PrettyPrinter to print the custom message and exception details
  /// to the console, and also records the exception in Firebase Crashlytics.
  ///
  /// Parameters:
  ///   - `exception` (Exception): The exception to be logged.
  ///   - `customMessage` (String): A custom message that provides additional context
  ///     about the exception.
  static void logException(Exception exception, String customMessage) {
    var logger = Logger(printer: PrettyPrinter(methodCount: 0));
    logger.e("$customMessage-Exception: $exception");
    FirebaseCrashlytics.instance.recordError(exception, null);
  }
}
