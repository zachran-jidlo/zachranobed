import 'package:zachranobed/common/logger/zo_logger.dart';
import 'package:zachranobed/common/domain/usecase/get_last_app_terms_version_use_case.dart';
import 'package:zachranobed/features/appTerms/domain/repository/app_terms_repository.dart';
import 'package:zachranobed/models/user_data.dart';

class SetNewestAcceptedAppTermsUseCase {
  final AppTermsRepository _appTermsRepository;
  final GetLastAppTermsVersionUseCase _getLastAppTermsVersionUseCase;

  SetNewestAcceptedAppTermsUseCase(
    this._appTermsRepository,
    this._getLastAppTermsVersionUseCase,
  );

  Future<void> invoke(UserData user) async {
    final lastAppTermsVersion = await _getLastAppTermsVersionUseCase.getLastAppTerms();

    if (lastAppTermsVersion != null) {
      _appTermsRepository.updateAcceptedAppTermsVersion(
        entityId: user.entityId,
        appTermsVersion: lastAppTermsVersion,
      );
    } else {
      ZOLogger.logMessage(
        "Unable to set the last accepted app terms because the remote value is null",
        isError: true,
      );
    }
  }
}
