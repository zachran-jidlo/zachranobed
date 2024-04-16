import 'package:zachranobed/common/logger/zo_logger.dart';
import 'package:zachranobed/features/appTerms/domain/update_current_user_data_use_case.dart';
import 'package:zachranobed/features/appConfiguration/data/get_last_app_terms_version_use_case.dart';

class SetNewestAcceptedAppTermsUseCase {
  final UpdateCurrentUserDataUseCase _updateCurrentUserDataUseCase;
  final GetLastAppTermsVersionUseCase _getLastAppTermsVersionUseCase;

  SetNewestAcceptedAppTermsUseCase(this._updateCurrentUserDataUseCase, this._getLastAppTermsVersionUseCase);

  Future<void> invoke() async {
    int? lastAppTermsVersion = await _getLastAppTermsVersionUseCase.getLastAppTerms();

    if (lastAppTermsVersion != null) {
      _updateCurrentUserDataUseCase.updateLastAcceptedAppTermsVersion(lastAppTermsVersion);
    } else {
      ZOLogger.logMessage("Unable to set the last accepted app terms because the remote value is `${lastAppTermsVersion}`", isError: true);
    }
  }
}