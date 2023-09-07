import 'package:get_it/get_it.dart';
import 'package:zachranobed/routes/app_router.dart';
import 'package:zachranobed/services/auth_service.dart';
import 'package:zachranobed/services/box_movement_srvice.dart';
import 'package:zachranobed/services/box_service.dart';
import 'package:zachranobed/services/canteen_service.dart';
import 'package:zachranobed/services/charity_service.dart';
import 'package:zachranobed/services/delivery_service.dart';
import 'package:zachranobed/services/fcm_token_service.dart';
import 'package:zachranobed/services/offered_food_service.dart';

class IoCContainer {
  const IoCContainer._();

  static void setup() {
    GetIt.I.registerSingleton(CanteenService());
    GetIt.I.registerSingleton(CharityService());
    GetIt.I.registerSingleton(AuthService(
      GetIt.I<CanteenService>(),
      GetIt.I<CharityService>(),
    ));
    GetIt.I.registerSingleton(OfferedFoodService());
    GetIt.I.registerSingleton(DeliveryService());
    GetIt.I.registerSingleton(FCMTokenService(GetIt.I<AuthService>()));
    GetIt.I.registerSingleton(AppRouter());
    GetIt.I.registerSingleton(BoxService());
    GetIt.I.registerSingleton(BoxMovementService());
  }
}
