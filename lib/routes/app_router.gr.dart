// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i19;
import 'package:flutter/foundation.dart' as _i22;
import 'package:flutter/material.dart' as _i20;
import 'package:zachranobed/features/activepair/presentation/change_active_pair_screen.dart'
    as _i3;
import 'package:zachranobed/features/appTerms/presentation/app_terms_screen.dart'
    as _i1;
import 'package:zachranobed/features/debug/debug_screen.dart' as _i6;
import 'package:zachranobed/features/foodboxes/domain/model/box_movement.dart'
    as _i21;
import 'package:zachranobed/features/foodboxes/domain/model/food_box_type.dart'
    as _i24;
import 'package:zachranobed/features/foodboxes/presentation/screen/box_movement_detail_screen.dart'
    as _i2;
import 'package:zachranobed/features/forceupdate/presentation/force_update_screen.dart'
    as _i8;
import 'package:zachranobed/features/login/presentation/screen/login_screen.dart'
    as _i11;
import 'package:zachranobed/features/menu/presentation/contacts_screen.dart'
    as _i5;
import 'package:zachranobed/features/menu/presentation/menu_screen.dart'
    as _i12;
import 'package:zachranobed/features/notifications/presentation/notifications_screen.dart'
    as _i13;
import 'package:zachranobed/features/offeredfood/domain/model/food_info.dart'
    as _i25;
import 'package:zachranobed/features/offeredfood/domain/model/offered_food.dart'
    as _i23;
import 'package:zachranobed/features/offeredfood/presentation/screens/donated_food_detail_screen.dart'
    as _i7;
import 'package:zachranobed/ui/screens/change_password_screen.dart' as _i4;
import 'package:zachranobed/ui/screens/forgot_password_screen.dart' as _i9;
import 'package:zachranobed/ui/screens/home_screen.dart' as _i10;
import 'package:zachranobed/ui/screens/offer_food_boxes_screen.dart' as _i15;
import 'package:zachranobed/ui/screens/offer_food_detail_screen.dart' as _i14;
import 'package:zachranobed/ui/screens/offer_food_overview_screen.dart' as _i16;
import 'package:zachranobed/ui/screens/order_shipping_of_boxes_screen.dart'
    as _i17;
import 'package:zachranobed/ui/screens/thank_you_screen.dart' as _i18;

abstract class $AppRouter extends _i19.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i19.PageFactory> pagesMap = {
    AppTermsRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.AppTermsScreen(),
      );
    },
    BoxMovementDetailRoute.name: (routeData) {
      final args = routeData.argsAs<BoxMovementDetailRouteArgs>();
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.BoxMovementDetailScreen(
          key: args.key,
          boxMovement: args.boxMovement,
        ),
      );
    },
    ChangeActivePairRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.ChangeActivePairScreen(),
      );
    },
    ChangePasswordRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.ChangePasswordScreen(),
      );
    },
    ContactsRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.ContactsScreen(),
      );
    },
    DebugRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.DebugScreen(),
      );
    },
    DonatedFoodDetailRoute.name: (routeData) {
      final args = routeData.argsAs<DonatedFoodDetailRouteArgs>();
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i7.DonatedFoodDetailScreen(
          key: args.key,
          offeredFood: args.offeredFood,
        ),
      );
    },
    ForceUpdateRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.ForceUpdateScreen(),
      );
    },
    ForgotPasswordRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.ForgotPasswordScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.HomeScreen(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.LoginScreen(),
      );
    },
    MenuRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.MenuScreen(),
      );
    },
    NotificationsRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.NotificationsScreen(),
      );
    },
    OfferFoodAddNewRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i14.OfferFoodAddNewScreen(),
      );
    },
    OfferFoodBoxesRoute.name: (routeData) {
      final args = routeData.argsAs<OfferFoodBoxesRouteArgs>();
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i15.OfferFoodBoxesScreen(
          key: args.key,
          currentBoxesQuantity: args.currentBoxesQuantity,
        ),
      );
    },
    OfferFoodEditExistingRoute.name: (routeData) {
      final args = routeData.argsAs<OfferFoodEditExistingRouteArgs>();
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i14.OfferFoodEditExistingScreen(
          key: args.key,
          foodInfo: args.foodInfo,
        ),
      );
    },
    OfferFoodInitialRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i14.OfferFoodInitialScreen(),
      );
    },
    OfferFoodOverviewRoute.name: (routeData) {
      final args = routeData.argsAs<OfferFoodOverviewRouteArgs>();
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i16.OfferFoodOverviewScreen(
          key: args.key,
          initialFoodInfos: args.initialFoodInfos,
        ),
      );
    },
    OrderShippingOfBoxesRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i17.OrderShippingOfBoxesScreen(),
      );
    },
    ThankYouRoute.name: (routeData) {
      final args = routeData.argsAs<ThankYouRouteArgs>();
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i18.ThankYouScreen(
          key: args.key,
          isSuccess: args.isSuccess,
          message: args.message,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.AppTermsScreen]
class AppTermsRoute extends _i19.PageRouteInfo<void> {
  const AppTermsRoute({List<_i19.PageRouteInfo>? children})
      : super(
          AppTermsRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppTermsRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i2.BoxMovementDetailScreen]
class BoxMovementDetailRoute
    extends _i19.PageRouteInfo<BoxMovementDetailRouteArgs> {
  BoxMovementDetailRoute({
    _i20.Key? key,
    required _i21.BoxMovement boxMovement,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          BoxMovementDetailRoute.name,
          args: BoxMovementDetailRouteArgs(
            key: key,
            boxMovement: boxMovement,
          ),
          initialChildren: children,
        );

  static const String name = 'BoxMovementDetailRoute';

  static const _i19.PageInfo<BoxMovementDetailRouteArgs> page =
      _i19.PageInfo<BoxMovementDetailRouteArgs>(name);
}

class BoxMovementDetailRouteArgs {
  const BoxMovementDetailRouteArgs({
    this.key,
    required this.boxMovement,
  });

  final _i20.Key? key;

  final _i21.BoxMovement boxMovement;

  @override
  String toString() {
    return 'BoxMovementDetailRouteArgs{key: $key, boxMovement: $boxMovement}';
  }
}

/// generated route for
/// [_i3.ChangeActivePairScreen]
class ChangeActivePairRoute extends _i19.PageRouteInfo<void> {
  const ChangeActivePairRoute({List<_i19.PageRouteInfo>? children})
      : super(
          ChangeActivePairRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChangeActivePairRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i4.ChangePasswordScreen]
class ChangePasswordRoute extends _i19.PageRouteInfo<void> {
  const ChangePasswordRoute({List<_i19.PageRouteInfo>? children})
      : super(
          ChangePasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChangePasswordRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i5.ContactsScreen]
class ContactsRoute extends _i19.PageRouteInfo<void> {
  const ContactsRoute({List<_i19.PageRouteInfo>? children})
      : super(
          ContactsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ContactsRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i6.DebugScreen]
class DebugRoute extends _i19.PageRouteInfo<void> {
  const DebugRoute({List<_i19.PageRouteInfo>? children})
      : super(
          DebugRoute.name,
          initialChildren: children,
        );

  static const String name = 'DebugRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i7.DonatedFoodDetailScreen]
class DonatedFoodDetailRoute
    extends _i19.PageRouteInfo<DonatedFoodDetailRouteArgs> {
  DonatedFoodDetailRoute({
    _i22.Key? key,
    required _i23.OfferedFood offeredFood,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          DonatedFoodDetailRoute.name,
          args: DonatedFoodDetailRouteArgs(
            key: key,
            offeredFood: offeredFood,
          ),
          initialChildren: children,
        );

  static const String name = 'DonatedFoodDetailRoute';

  static const _i19.PageInfo<DonatedFoodDetailRouteArgs> page =
      _i19.PageInfo<DonatedFoodDetailRouteArgs>(name);
}

class DonatedFoodDetailRouteArgs {
  const DonatedFoodDetailRouteArgs({
    this.key,
    required this.offeredFood,
  });

  final _i22.Key? key;

  final _i23.OfferedFood offeredFood;

  @override
  String toString() {
    return 'DonatedFoodDetailRouteArgs{key: $key, offeredFood: $offeredFood}';
  }
}

/// generated route for
/// [_i8.ForceUpdateScreen]
class ForceUpdateRoute extends _i19.PageRouteInfo<void> {
  const ForceUpdateRoute({List<_i19.PageRouteInfo>? children})
      : super(
          ForceUpdateRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForceUpdateRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i9.ForgotPasswordScreen]
class ForgotPasswordRoute extends _i19.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i19.PageRouteInfo>? children})
      : super(
          ForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i10.HomeScreen]
class HomeRoute extends _i19.PageRouteInfo<void> {
  const HomeRoute({List<_i19.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i11.LoginScreen]
class LoginRoute extends _i19.PageRouteInfo<void> {
  const LoginRoute({List<_i19.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i12.MenuScreen]
class MenuRoute extends _i19.PageRouteInfo<void> {
  const MenuRoute({List<_i19.PageRouteInfo>? children})
      : super(
          MenuRoute.name,
          initialChildren: children,
        );

  static const String name = 'MenuRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i13.NotificationsScreen]
class NotificationsRoute extends _i19.PageRouteInfo<void> {
  const NotificationsRoute({List<_i19.PageRouteInfo>? children})
      : super(
          NotificationsRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationsRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i14.OfferFoodAddNewScreen]
class OfferFoodAddNewRoute extends _i19.PageRouteInfo<void> {
  const OfferFoodAddNewRoute({List<_i19.PageRouteInfo>? children})
      : super(
          OfferFoodAddNewRoute.name,
          initialChildren: children,
        );

  static const String name = 'OfferFoodAddNewRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i15.OfferFoodBoxesScreen]
class OfferFoodBoxesRoute extends _i19.PageRouteInfo<OfferFoodBoxesRouteArgs> {
  OfferFoodBoxesRoute({
    _i20.Key? key,
    required Map<_i24.FoodBoxType, int> currentBoxesQuantity,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          OfferFoodBoxesRoute.name,
          args: OfferFoodBoxesRouteArgs(
            key: key,
            currentBoxesQuantity: currentBoxesQuantity,
          ),
          initialChildren: children,
        );

  static const String name = 'OfferFoodBoxesRoute';

  static const _i19.PageInfo<OfferFoodBoxesRouteArgs> page =
      _i19.PageInfo<OfferFoodBoxesRouteArgs>(name);
}

class OfferFoodBoxesRouteArgs {
  const OfferFoodBoxesRouteArgs({
    this.key,
    required this.currentBoxesQuantity,
  });

  final _i20.Key? key;

  final Map<_i24.FoodBoxType, int> currentBoxesQuantity;

  @override
  String toString() {
    return 'OfferFoodBoxesRouteArgs{key: $key, currentBoxesQuantity: $currentBoxesQuantity}';
  }
}

/// generated route for
/// [_i14.OfferFoodEditExistingScreen]
class OfferFoodEditExistingRoute
    extends _i19.PageRouteInfo<OfferFoodEditExistingRouteArgs> {
  OfferFoodEditExistingRoute({
    _i20.Key? key,
    required _i25.FoodInfo foodInfo,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          OfferFoodEditExistingRoute.name,
          args: OfferFoodEditExistingRouteArgs(
            key: key,
            foodInfo: foodInfo,
          ),
          initialChildren: children,
        );

  static const String name = 'OfferFoodEditExistingRoute';

  static const _i19.PageInfo<OfferFoodEditExistingRouteArgs> page =
      _i19.PageInfo<OfferFoodEditExistingRouteArgs>(name);
}

class OfferFoodEditExistingRouteArgs {
  const OfferFoodEditExistingRouteArgs({
    this.key,
    required this.foodInfo,
  });

  final _i20.Key? key;

  final _i25.FoodInfo foodInfo;

  @override
  String toString() {
    return 'OfferFoodEditExistingRouteArgs{key: $key, foodInfo: $foodInfo}';
  }
}

/// generated route for
/// [_i14.OfferFoodInitialScreen]
class OfferFoodInitialRoute extends _i19.PageRouteInfo<void> {
  const OfferFoodInitialRoute({List<_i19.PageRouteInfo>? children})
      : super(
          OfferFoodInitialRoute.name,
          initialChildren: children,
        );

  static const String name = 'OfferFoodInitialRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i16.OfferFoodOverviewScreen]
class OfferFoodOverviewRoute
    extends _i19.PageRouteInfo<OfferFoodOverviewRouteArgs> {
  OfferFoodOverviewRoute({
    _i20.Key? key,
    required List<_i25.FoodInfo> initialFoodInfos,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          OfferFoodOverviewRoute.name,
          args: OfferFoodOverviewRouteArgs(
            key: key,
            initialFoodInfos: initialFoodInfos,
          ),
          initialChildren: children,
        );

  static const String name = 'OfferFoodOverviewRoute';

  static const _i19.PageInfo<OfferFoodOverviewRouteArgs> page =
      _i19.PageInfo<OfferFoodOverviewRouteArgs>(name);
}

class OfferFoodOverviewRouteArgs {
  const OfferFoodOverviewRouteArgs({
    this.key,
    required this.initialFoodInfos,
  });

  final _i20.Key? key;

  final List<_i25.FoodInfo> initialFoodInfos;

  @override
  String toString() {
    return 'OfferFoodOverviewRouteArgs{key: $key, initialFoodInfos: $initialFoodInfos}';
  }
}

/// generated route for
/// [_i17.OrderShippingOfBoxesScreen]
class OrderShippingOfBoxesRoute extends _i19.PageRouteInfo<void> {
  const OrderShippingOfBoxesRoute({List<_i19.PageRouteInfo>? children})
      : super(
          OrderShippingOfBoxesRoute.name,
          initialChildren: children,
        );

  static const String name = 'OrderShippingOfBoxesRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i18.ThankYouScreen]
class ThankYouRoute extends _i19.PageRouteInfo<ThankYouRouteArgs> {
  ThankYouRoute({
    _i20.Key? key,
    required bool isSuccess,
    required String message,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          ThankYouRoute.name,
          args: ThankYouRouteArgs(
            key: key,
            isSuccess: isSuccess,
            message: message,
          ),
          initialChildren: children,
        );

  static const String name = 'ThankYouRoute';

  static const _i19.PageInfo<ThankYouRouteArgs> page =
      _i19.PageInfo<ThankYouRouteArgs>(name);
}

class ThankYouRouteArgs {
  const ThankYouRouteArgs({
    this.key,
    required this.isSuccess,
    required this.message,
  });

  final _i20.Key? key;

  final bool isSuccess;

  final String message;

  @override
  String toString() {
    return 'ThankYouRouteArgs{key: $key, isSuccess: $isSuccess, message: $message}';
  }
}
