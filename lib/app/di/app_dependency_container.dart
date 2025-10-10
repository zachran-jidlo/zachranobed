import 'package:zachranobed/common/di/common_dependency_container.dart';
import 'package:zachranobed/features/activepair/di/active_pair_dependency_container.dart';
import 'package:zachranobed/features/appTerms/di/app_terms_dependency_container.dart';
import 'package:zachranobed/features/food/di/food_dependency_container.dart';
import 'package:zachranobed/features/forceupdate/domain/di/force_update_dependency_container.dart';
import 'package:zachranobed/features/login/di/login_dependency_container.dart';
import 'package:zachranobed/features/menu/di/menu_dependency_container.dart';
import 'package:zachranobed/features/notifications/di/notifications_dependency_container.dart';

class AppDependencyContainer {
  const AppDependencyContainer._();

  static void setup() {
    CommonDependencyContainer.setup();
    AppTermsDependencyContainer.setup();
    LoginDependencyContainer.setup();
    FoodDependencyContainer.setup();
    MenuDependencyContainer.setup();
    ActivePairDependencyContainer.setup();
    ForceUpdateDependencyContainer.setup();
    NotificationsDependencyContainer.setup();
  }
}
