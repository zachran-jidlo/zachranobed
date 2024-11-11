import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/prefs/app_preferences.dart';
import 'package:zachranobed/features/activepair/data/repository/firebase_entity_pairs_repository.dart';
import 'package:zachranobed/features/activepair/domain/repository/entity_pairs_repository.dart';
import 'package:zachranobed/features/activepair/domain/usecase/change_active_pair_use_case.dart';
import 'package:zachranobed/features/activepair/domain/usecase/get_entity_pairs_summary_use_case.dart';
import 'package:zachranobed/services/entity_pairs_service.dart';
import 'package:zachranobed/services/entity_service.dart';

/// A dependency container for active pair related classes.
class ActivePairDependencyContainer {
  /// Private constructor to prevent instantiation.
  const ActivePairDependencyContainer._();

  /// Sets up the dependencies for the active pair feature.
  static void setup() {
    GetIt.I.registerFactory<EntityPairsRepository>(
      () => FirebaseEntityPairsRepository(
        GetIt.I<EntityService>(),
        GetIt.I<EntityPairService>(),
        GetIt.I<AppPreferences>(),
      ),
    );

    GetIt.I.registerFactory<ChangeActivePairUseCase>(
      () => ChangeActivePairUseCase(
        GetIt.I<EntityPairsRepository>(),
      ),
    );

    GetIt.I.registerFactory<GetEntityPairsSummaryUseCase>(
      () => GetEntityPairsSummaryUseCase(
        GetIt.I<EntityPairsRepository>(),
      ),
    );
  }
}
