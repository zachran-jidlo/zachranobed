import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/prefs/app_preferences.dart';
import 'package:zachranobed/routes/app_router.dart';
import 'package:zachranobed/services/auth_service.dart';
import 'package:zachranobed/services/carrier_service.dart';
import 'package:zachranobed/services/configuration_service.dart';
import 'package:zachranobed/services/delivery_service.dart';
import 'package:zachranobed/services/entity_notification_service.dart';
import 'package:zachranobed/services/entity_pairs_service.dart';
import 'package:zachranobed/services/entity_service.dart';
import 'package:zachranobed/services/food_box_service.dart';
import 'package:zachranobed/services/meal_service.dart';

class ServicesDependencyContainer {
  const ServicesDependencyContainer._();

  static void setup() {
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
      ),
    );
    GetIt.I.registerSingleton(ConfigurationService());
    GetIt.I.registerSingleton(CarrierService());
    GetIt.I.registerSingleton(AppRouter());
  }
}
