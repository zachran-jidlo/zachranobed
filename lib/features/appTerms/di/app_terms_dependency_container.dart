import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/domain/usecase/get_last_app_terms_version_use_case.dart';
import 'package:zachranobed/features/appTerms/data/repository/firebase_app_terms_repository.dart';
import 'package:zachranobed/features/appTerms/domain/repository/app_terms_repository.dart';
import 'package:zachranobed/features/appTerms/domain/set_newest_accepted_app_terms_usecase.dart';
import 'package:zachranobed/services/entity_service.dart';

/// Container for app terms dependencies
class AppTermsDependencyContainer {
  const AppTermsDependencyContainer._();

  static void setup() {
    GetIt.I.registerFactory<AppTermsRepository>(
      () => FirebaseAppTermsRepository(
        GetIt.I<EntityService>(),
      ),
    );

    GetIt.I.registerFactory<SetNewestAcceptedAppTermsUseCase>(
      () => SetNewestAcceptedAppTermsUseCase(
        GetIt.I<AppTermsRepository>(),
        GetIt.I<GetLastAppTermsVersionUseCase>(),
      ),
    );
  }
}
