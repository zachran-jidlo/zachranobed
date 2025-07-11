import 'package:auto_route/auto_route.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/routes/guards/auth_guard.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<MaterialRoute> get routes => [
        MaterialRoute(
          page: HomeRoute.page,
          initial: true,
          guards: [AuthGuard()],
        ),
        MaterialRoute(page: LoginRoute.page),
        MaterialRoute(page: ForgotPasswordRoute.page),
        MaterialRoute(
          page: MenuRoute.page,
          guards: [AuthGuard()],
        ),
        MaterialRoute(
          page: NotificationsRoute.page,
          guards: [AuthGuard()],
        ),
        MaterialRoute(
          page: ContactsRoute.page,
          guards: [AuthGuard()],
        ),
        MaterialRoute(
          page: ChangePasswordRoute.page,
          guards: [AuthGuard()],
        ),
        MaterialRoute(
          page: DonatedFoodDetailRoute.page,
          guards: [AuthGuard()],
        ),
        MaterialRoute(
          page: BoxMovementDetailRoute.page,
          guards: [AuthGuard()],
        ),
        MaterialRoute(
          page: ThankYouRoute.page,
          guards: [AuthGuard()],
        ),
        MaterialRoute(
          page: OrderShippingOfBoxesRoute.page,
          guards: [AuthGuard()],
        ),
        MaterialRoute(page: DebugRoute.page),
        MaterialRoute(page: AppTermsRoute.page),
        MaterialRoute(
          page: OfferFoodOverviewRoute.page,
          guards: [AuthGuard()],
        ),
        MaterialRoute(
          page: OfferFoodInitialRoute.page,
          guards: [AuthGuard()],
        ),
        MaterialRoute(
          page: OfferFoodAddNewRoute.page,
          guards: [AuthGuard()],
        ),
        MaterialRoute(
          page: OfferFoodEditExistingRoute.page,
          guards: [AuthGuard()],
        ),
        MaterialRoute(
          page: OfferFoodBoxesRoute.page,
          guards: [AuthGuard()],
        ),
        MaterialRoute(
          page: ChangeActivePairRoute.page,
          guards: [AuthGuard()],
        ),
        MaterialRoute(
          page: ForceUpdateRoute.page,
        ),
      ];
}
