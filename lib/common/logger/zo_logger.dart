import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:zachranobed/common/firebase/firebase_helper.dart';
import 'package:zachranobed/features/login/domain/check_if_devtools_are_enabled_usecase.dart';

/// `ZOLogger` is a utility class for logging messages and exceptions.
/// It supports both console logging with enhanced readability via PrettyPrinter
/// and error logging to Firebase Crashlytics.
///
/// Logging is enabled only when CheckIfDevtoolsAreEnabledUseCase returns true.
class ZOLogger {
  static Logger? _logger;

  /// Initializes the logger based on whether developer tools are enabled.
  static void init() {
    final devtoolsAreEnabled = GetIt.I<CheckIfDevtoolsAreEnabledUseCase>();
    if (devtoolsAreEnabled.invoke()) {
      final filter = ProductionFilter();
      filter.level = Level.all;

      _logger = Logger(filter: ProductionFilter());
    }
  }

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
    if (_logger == null) {
      return;
    }

    if (isError) {
      _logger?.e(message);
      if (FirebaseHelper.isCrashlyticsSupported()) {
        FirebaseCrashlytics.instance.recordError(Exception(message), null);
      }
    } else {
      _logger?.d(message);
      if (FirebaseHelper.isCrashlyticsSupported()) {
        FirebaseCrashlytics.instance.log(message);
      }
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
    if (_logger == null) {
      return;
    }

    _logger?.e("$customMessage-Exception: $exception");
    if (FirebaseHelper.isCrashlyticsSupported()) {
      FirebaseCrashlytics.instance.recordError(exception, null);
    }
  }
}
