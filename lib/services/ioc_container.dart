import 'package:get_it/get_it.dart';
import 'package:zachranobed/services/auth_service.dart';
import 'package:zachranobed/services/delivery_service.dart';
import 'package:zachranobed/services/donor_service.dart';
import 'package:zachranobed/services/offered_food_service.dart';

class IoCContainer {
  const IoCContainer._();

  static void setup() {
    GetIt.I.registerSingleton(DonorService());
    GetIt.I.registerSingleton(AuthService(GetIt.I<DonorService>()));
    GetIt.I.registerSingleton(OfferedFoodService());
    GetIt.I.registerSingleton(DeliveryService());
  }
}
