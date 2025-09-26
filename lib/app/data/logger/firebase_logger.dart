import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:zachranobed/common/domain/utils/zo_logger.dart';

/// A [ZOLoggerInstance] that logs messages and exceptions to Firebase Crashlytics.
class FirebaseLoggerInstance implements ZOLoggerInstance {
  @override
  void logMessage(String message, {bool isError = false}) {
    if (isError) {
      FirebaseCrashlytics.instance.recordError(Exception(message), null);
    } else {
      FirebaseCrashlytics.instance.log(message);
    }
  }

  @override
  void logException(Exception exception, String customMessage) {
    FirebaseCrashlytics.instance.recordError(exception, null);
  }
}
