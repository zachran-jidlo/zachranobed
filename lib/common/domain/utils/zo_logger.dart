/// `ZOLogger` is a utility class for logging messages and exceptions.
class ZOLogger {
  static List<ZOLoggerInstance>? _loggers;

  /// Initializes the logger with the provided list of loggers..
  static void init(List<ZOLoggerInstance> loggers) {
    _loggers = loggers;
  }

  /// Logs a message. This method differentiates between normal log messages and error messages.
  ///
  /// Parameters:
  ///   - `message` (String): The message to be logged.
  ///   - `isError` (bool, optional): A flag indicating whether the message is an error.
  ///     Defaults to `false`. If `true`, the message is treated as an error.
  static void logMessage(String message, {bool isError = false}) {
    _loggers?.forEach((logger) => logger.logMessage(message, isError: isError));
  }

  /// Logs an exception. This method is specifically designed for exception logging.
  ///
  /// Parameters:
  ///   - `exception` (Exception): The exception to be logged.
  ///   - `customMessage` (String): A custom message that provides additional context
  ///     about the exception.
  static void logException(Exception exception, String customMessage) {
    _loggers?.forEach((logger) => logger.logException(exception, customMessage));
  }
}

/// An abstract class defining the contract for logger instances.
abstract class ZOLoggerInstance {
  /// Logs a message. This method differentiates between normal log messages and error messages.
  ///
  /// Parameters:
  ///   - `message` (String): The message to be logged.
  ///   - `isError` (bool, optional): A flag indicating whether the message is an error.
  ///     Defaults to `false`. If `true`, the message is treated as an error.
  void logMessage(String message, {bool isError = false});

  /// Logs an exception. This method is specifically designed for exception logging.
  ///
  /// Parameters:
  ///   - `exception` (Exception): The exception to be logged.
  ///   - `customMessage` (String): A custom message that provides additional context
  ///     about the exception.
  void logException(Exception exception, String customMessage);
}
