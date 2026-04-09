import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/data/prefs/app_preferences.dart';
import 'package:zachranobed/common/data/repository/firebase_app_configuration_repository.dart';
import 'package:zachranobed/common/data/repository/firebase_delivery_repository.dart';
import 'package:zachranobed/common/data/repository/firebase_user_repository.dart';
import 'package:zachranobed/common/data/repository/platform_device_repository.dart';
import 'package:zachranobed/common/data/service/auth_service.dart';
import 'package:zachranobed/common/data/service/carrier_service.dart';
import 'package:zachranobed/common/data/service/configuration_service.dart';
import 'package:zachranobed/common/data/service/delivery_service.dart';
import 'package:zachranobed/common/data/service/entity_notification_service.dart';
import 'package:zachranobed/common/data/service/entity_pairs_service.dart';
import 'package:zachranobed/common/data/service/entity_service.dart';
import 'package:zachranobed/common/data/service/food_box_service.dart';
import 'package:zachranobed/common/data/service/meal_service.dart';
import 'package:zachranobed/common/domain/repository/app_configuration_repository.dart';
import 'package:zachranobed/common/domain/repository/delivery_repository.dart';
import 'package:zachranobed/common/domain/repository/device_repository.dart';
import 'package:zachranobed/common/domain/repository/user_repository.dart';
import 'package:zachranobed/common/domain/usecase/create_food_delivery_use_case.dart';
import 'package:zachranobed/common/domain/usecase/get_app_semantic_version_usecase.dart';
import 'package:zachranobed/common/domain/usecase/get_app_terms_status_usecase.dart';
import 'package:zachranobed/common/domain/usecase/get_app_version_usecase.dart';
import 'package:zachranobed/common/domain/usecase/get_device_id_usecase.dart';
import 'package:zachranobed/common/domain/usecase/get_last_app_terms_version_use_case.dart';
import 'package:zachranobed/common/domain/usecase/get_user_data_usecase.dart';
import 'package:zachranobed/common/domain/usecase/notify_user_data_changed_usecase.dart';
import 'package:zachranobed/common/domain/usecase/observe_user_data_usecase.dart';
import 'package:zachranobed/common/domain/usecase/remove_onboarding_for_ui_changes_flag_usecase.dart';
import 'package:zachranobed/common/domain/usecase/should_show_onboarding_for_ui_changes_usecase.dart';
import 'package:zachranobed/common/presentation/router/app_router.dart';

class CommonDependencyContainer {
  const CommonDependencyContainer._();

  static void setup() {
    _setupAppTermsComponents();
    _setupDeliveryComponents();
    _setupUserComponents();
    _setupAppConfigurationComponents();
    _setupAppPreferencesComponents();
    _setupDeviceComponents();
    _setupServiceComponents();
  }

  static void _setupAppTermsComponents() {
    // UseCases
    GetIt.I.registerFactory<GetAppTermsStatusUseCase>(
      () => GetAppTermsStatusUseCase(
        GetIt.I<GetLastAppTermsVersionUseCase>(),
      ),
    );

    GetIt.I.registerFactory<GetLastAppTermsVersionUseCase>(
      () => GetLastAppTermsVersionUseCase(
        GetIt.I<AppConfigurationRepository>(),
      ),
    );
  }

  static void _setupDeliveryComponents() {
    // Repositories
    GetIt.I.registerFactory<DeliveryRepository>(
      () => FirebaseDeliveryRepository(
        GetIt.I<DeliveryService>(),
      ),
    );

    // UseCases
    GetIt.I.registerFactory<CreateFoodDeliveryUseCase>(
      () => CreateFoodDeliveryUseCase(
        GetIt.I<DeliveryRepository>(),
      ),
    );
  }

  static void _setupUserComponents() {
    // Repositories
    // Registered as lazy singleton to allow stream-based observation of user data changes.
    GetIt.I.registerLazySingleton<UserRepository>(
      () => FirebaseUserRepository(
        GetIt.I<AuthService>(),
        GetIt.I<EntityService>(),
      ),
    );

    // UseCases
    GetIt.I.registerFactory<GetUserDataUseCase>(
      () => GetUserDataUseCase(
        GetIt.I<UserRepository>(),
      ),
    );

    GetIt.I.registerFactory<ObserveUserDataUseCase>(
      () => ObserveUserDataUseCase(
        GetIt.I<UserRepository>(),
      ),
    );

    GetIt.I.registerFactory<NotifyUserDataChangedUseCase>(
      () => NotifyUserDataChangedUseCase(
        GetIt.I<UserRepository>(),
      ),
    );

    GetIt.I.registerFactory<ShouldShowOnboardingForUiChangesUseCase>(
      () => ShouldShowOnboardingForUiChangesUseCase(
        GetIt.I<UserRepository>(),
      ),
    );

    GetIt.I.registerFactory<RemoveOnboardingForUiChangesFlagUseCase>(
      () => RemoveOnboardingForUiChangesFlagUseCase(
        GetIt.I<UserRepository>(),
      ),
    );
  }

  static void _setupAppConfigurationComponents() {
    // Repositories
    GetIt.I.registerFactory<AppConfigurationRepository>(
      () => FirebaseAppConfigurationRepository(
        GetIt.I<ConfigurationService>(),
      ),
    );
  }

  static void _setupAppPreferencesComponents() {
    GetIt.I.registerSingleton(AppPreferences());
  }

  static void _setupDeviceComponents() {
    GetIt.I.registerFactory<DeviceRepository>(() => PlatformDeviceRepository());
    GetIt.I.registerFactory<GetDeviceIdUseCase>(() => GetDeviceIdUseCase(GetIt.I<DeviceRepository>()));
    GetIt.I.registerFactory<GetAppVersionUseCase>(() => GetAppVersionUseCase(GetIt.I<DeviceRepository>()));
    GetIt.I.registerFactory<GetAppSemanticVersionUseCase>(
      () => GetAppSemanticVersionUseCase(GetIt.I<DeviceRepository>()),
    );
  }

  static void _setupServiceComponents() {
    GetIt.I.registerSingleton(FoodBoxService());
    GetIt.I.registerSingleton(EntityService());
    GetIt.I.registerSingleton(EntityPairService());
    GetIt.I.registerSingleton(EntityNotificationService());
    GetIt.I.registerSingleton(MealService());
    GetIt.I.registerSingleton(DeliveryService());
    GetIt.I.registerSingleton(
      AuthService(
        GetIt.I<EntityService>(),
        GetIt.I<EntityPairService>(),
        GetIt.I<AppPreferences>(),
        GetIt.I<GetDeviceIdUseCase>(),
      ),
    );
    GetIt.I.registerSingleton(ConfigurationService());
    GetIt.I.registerSingleton(CarrierService());
    GetIt.I.registerSingleton(AppRouter());
  }
}
