import 'package:zachranobed/common/domain/model/app_terms_status.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/domain/usecase/get_last_app_terms_version_use_case.dart';

/// Determines the status of the app terms for a given user.
class GetAppTermsStatusUseCase {
  final GetLastAppTermsVersionUseCase _getLastAppTermsVersionUseCase;

  GetAppTermsStatusUseCase(
    this._getLastAppTermsVersionUseCase,
  );

  Future<AppTermsStatus> invoke(UserData user) async {
    final lastAcceptedVersion = user.lastAcceptedAppTermsVersion;
    if (lastAcceptedVersion == null) {
      return AppTermsStatus.notAccepted;
    }

    final lastAppTermsVersion = await _getLastAppTermsVersionUseCase.getLastAppTerms();
    if (lastAppTermsVersion != null && lastAppTermsVersion > lastAcceptedVersion) {
      return AppTermsStatus.newVersionIsAvailable;
    }

    return AppTermsStatus.accepted;
  }
}
