import 'package:auto_route/auto_route.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/routes/guards/auth_guard.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends $AppRouter {
  @override
  List<MaterialRoute> get routes => [
        MaterialRoute(
          page: HomeRoute.page,
          initial: true,
          guards: [AuthGuard()],
        ),
        MaterialRoute(page: LoginRoute.page),
        MaterialRoute(page: OfferFoodRoute.page),
        MaterialRoute(page: MenuRoute.page),
        MaterialRoute(page: DonatedFoodDetailRoute.page),
        MaterialRoute(page: ThankYouRoute.page),
      ];
}
