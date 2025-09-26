import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/app/data/logger/console_logger.dart';
import 'package:zachranobed/app/data/logger/firebase_logger.dart';
import 'package:zachranobed/common/domain/usecase/check_if_devtools_are_enabled_usecase.dart';
import 'package:zachranobed/common/domain/utils/zo_logger.dart';
import 'package:zachranobed/common/data/utils/firebase_helper.dart';

/// A class responsible for initializing the [ZOLogger] with appropriate logger instances.
class ZoLoggerInitializer {
  /// Initializes the [ZOLogger] with a list of [ZOLoggerInstance]s.
  static void init() {
    final devToolsAreEnabled = GetIt.I<CheckIfDevtoolsAreEnabledUseCase>().invoke();
    final loggers = [
      if (kDebugMode || devToolsAreEnabled) ConsoleLoggerInstance(),
      if (FirebaseHelper.isCrashlyticsSupported()) FirebaseLoggerInstance(),
    ];

    ZOLogger.init(loggers);
  }
}
