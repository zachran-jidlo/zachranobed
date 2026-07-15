import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/data/prefs/app_preferences.dart';
import 'package:zachranobed/common/domain/usecase/get_app_semantic_version_usecase.dart';
import 'package:zachranobed/features/banners/data/repository/firebase_banner_repository.dart';
import 'package:zachranobed/features/banners/data/service/banner_service.dart';
import 'package:zachranobed/features/banners/domain/repository/banner_repository.dart';
import 'package:zachranobed/features/banners/domain/usecase/dismiss_banner_use_case.dart';
import 'package:zachranobed/features/banners/domain/usecase/observe_active_banners_use_case.dart';

/// DI setup for banners feature.
class BannersDependencyContainer {
  const BannersDependencyContainer._();

  static void setup() {
    GetIt.I.registerSingleton(BannerService());

    GetIt.I.registerSingleton<BannerRepository>(
      FirebaseBannerRepository(
        GetIt.I<BannerService>(),
        GetIt.I<AppPreferences>(),
      ),
    );

    GetIt.I.registerFactory<ObserveActiveBannersUseCase>(
      () => ObserveActiveBannersUseCase(
        GetIt.I<BannerRepository>(),
        GetIt.I<GetAppSemanticVersionUseCase>(),
      ),
    );

    GetIt.I.registerFactory<DismissBannerUseCase>(
      () => DismissBannerUseCase(
        GetIt.I<BannerRepository>(),
      ),
    );
  }
}
