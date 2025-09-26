import 'package:logger/web.dart';
import 'package:zachranobed/common/domain/utils/zo_logger.dart';

/// A [ZOLoggerInstance] that logs messages and exceptions to the console.
class ConsoleLoggerInstance implements ZOLoggerInstance {
  final Logger _logger = Logger(filter: ProductionFilter());

  @override
  void logMessage(String message, {bool isError = false}) {
    if (isError) {
      _logger.e(message);
    } else {
      _logger.d(message);
    }
  }

  @override
  void logException(Exception exception, String customMessage) {
    _logger.e("$customMessage-Exception: $exception");
  }
}
