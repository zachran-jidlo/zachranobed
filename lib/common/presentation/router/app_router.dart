import 'package:auto_route/auto_route.dart';
import 'package:zachranobed/common/presentation/router/app_router.gr.dart';
import 'package:zachranobed/common/presentation/router/auth_guard.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  /// Resolves the link the app was opened with.
  ///
  /// On web a page reload opens the current URL as the only route. Screens
  /// other than home and login rely on state that the previous screens set up
  /// (a way back, the loaded user, route arguments), so after a reload they
  /// render broken. The app opens home instead. Its guard sends a signed out
  /// user to login, and the start checks in `AppRoot` reopen screens such as
  /// the terms or a force update when they are still needed. Links that arrive
  /// while the app runs keep the default behavior.
  DeepLink resolveDeepLink(PlatformDeepLink deepLink) {
    final matches = deepLink.matches;
    if (!deepLink.initial || matches.isEmpty) {
      return deepLink;
    }

    final isRootScreen = const [HomeRoute.name, LoginRoute.name].contains(matches.first.name);
    if (isRootScreen) {
      return deepLink;
    }

    return DeepLink.single(HomeRoute());
  }

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
      page: ProfileRoute.page,
      guards: [AuthGuard()],
    ),
    MaterialRoute(
      page: ContactsRoute.page,
      guards: [AuthGuard()],
    ),
    MaterialRoute(
      page: MealSuggestionsListRoute.page,
      guards: [AuthGuard()],
    ),
    MaterialRoute(
      page: MealSuggestionAddRoute.page,
      guards: [AuthGuard()],
    ),
    MaterialRoute(
      page: MealSuggestionEditRoute.page,
      guards: [AuthGuard()],
    ),
    MaterialRoute(
      page: ChangePasswordRoute.page,
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
    MaterialRoute(page: ComponentsRoute.page),
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
      page: FoodBoxesDetailRoute.page,
      guards: [AuthGuard()],
    ),
    MaterialRoute(
      page: FoodBoxesCheckupMismatchRoute.page,
      guards: [AuthGuard()],
    ),
    MaterialRoute(
      page: BoxDeliveryConfirmationRoute.page,
      guards: [AuthGuard()],
    ),
    MaterialRoute(
      page: DeliveryDetailRoute.page,
      guards: [AuthGuard()],
    ),
    MaterialRoute(
      page: AddMealsToHistoryRoute.page,
      guards: [AuthGuard()],
    ),
    MaterialRoute(
      page: ChangeActivePairRoute.page,
      guards: [AuthGuard()],
    ),
    MaterialRoute(
      page: ForceUpdateRoute.page,
    ),
    MaterialRoute(
      page: InactiveAccountRoute.page,
    ),
    MaterialRoute(
      page: WhatsNewRoute.page,
      guards: [AuthGuard()],
    ),
    MaterialRoute(
      page: FaqQuestionsRoute.page,
      guards: [AuthGuard()],
    ),
    MaterialRoute(
      page: FaqDetailRoute.page,
      guards: [AuthGuard()],
    ),
  ];
}
