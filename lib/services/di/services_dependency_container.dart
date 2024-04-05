import 'package:get_it/get_it.dart';
import 'package:zachranobed/routes/app_router.dart';
import 'package:zachranobed/services/auth_service.dart';
import 'package:zachranobed/services/box_movement_srvice.dart';
import 'package:zachranobed/services/box_service.dart';
import 'package:zachranobed/services/delivery_service.dart';
import 'package:zachranobed/services/entity_pairs_service.dart';
import 'package:zachranobed/services/entity_service.dart';
import 'package:zachranobed/services/offered_food_service.dart';
import 'package:zachranobed/services/shipping_of_boxes_service.dart';

class ServicesDependencyContainer {
  const ServicesDependencyContainer._();

  static void setup() {
    GetIt.I.registerSingleton(EntityService());
    GetIt.I.registerSingleton(EntityPairService());
    GetIt.I.registerSingleton(
      AuthService(
        GetIt.I<EntityService>(),
        GetIt.I<EntityPairService>(),
      ),
    );
    GetIt.I.registerSingleton(OfferedFoodService());
    GetIt.I.registerSingleton(DeliveryService());
    GetIt.I.registerSingleton(AppRouter());
    GetIt.I.registerSingleton(BoxService());
    GetIt.I.registerSingleton(BoxMovementService());
    GetIt.I.registerSingleton(ShippingOfBoxesService());
  }
}
