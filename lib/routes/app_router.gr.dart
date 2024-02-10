// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i12;
import 'package:cloud_firestore/cloud_firestore.dart' as _i17;
import 'package:flutter/material.dart' as _i13;
import 'package:zachranobed/features/debug/DebugScreen.dart' as _i3;
import 'package:zachranobed/features/login/presentation/screen/login_screen.dart'
    as _i7;
import 'package:zachranobed/models/box_movement.dart' as _i14;
import 'package:zachranobed/models/offered_food.dart' as _i16;
import 'package:zachranobed/models/user_data.dart' as _i15;
import 'package:zachranobed/ui/screens/box_movement_detail_screen.dart' as _i1;
import 'package:zachranobed/ui/screens/change_password_screen.dart' as _i2;
import 'package:zachranobed/ui/screens/donated_food_detail_screen.dart' as _i4;
import 'package:zachranobed/ui/screens/forgot_password_screen.dart' as _i5;
import 'package:zachranobed/ui/screens/home_screen.dart' as _i6;
import 'package:zachranobed/ui/screens/menu_screen.dart' as _i8;
import 'package:zachranobed/ui/screens/offer_food_screen.dart' as _i9;
import 'package:zachranobed/ui/screens/order_shipping_of_boxes_screen.dart'
    as _i10;
import 'package:zachranobed/ui/screens/thank_you_screen.dart' as _i11;

abstract class $AppRouter extends _i12.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i12.PageFactory> pagesMap = {
    BoxMovementDetailRoute.name: (routeData) {
      final args = routeData.argsAs<BoxMovementDetailRouteArgs>();
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.BoxMovementDetailScreen(
          key: args.key,
          boxMovement: args.boxMovement,
          user: args.user,
        ),
      );
    },
    ChangePasswordRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.ChangePasswordScreen(),
      );
    },
    DebugRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.DebugScreen(),
      );
    },
    DonatedFoodDetailRoute.name: (routeData) {
      final args = routeData.argsAs<DonatedFoodDetailRouteArgs>();
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.DonatedFoodDetailScreen(
          key: args.key,
          offeredFood: args.offeredFood,
        ),
      );
    },
    ForgotPasswordRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.ForgotPasswordScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.HomeScreen(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.LoginScreen(),
      );
    },
    MenuRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.MenuScreen(),
      );
    },
    OfferFoodRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.OfferFoodScreen(),
      );
    },
    OrderShippingOfBoxesRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.OrderShippingOfBoxesScreen(),
      );
    },
    ThankYouRoute.name: (routeData) {
      final args = routeData.argsAs<ThankYouRouteArgs>();
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i11.ThankYouScreen(
          key: args.key,
          response: args.response,
          message: args.message,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.BoxMovementDetailScreen]
class BoxMovementDetailRoute
    extends _i12.PageRouteInfo<BoxMovementDetailRouteArgs> {
  BoxMovementDetailRoute({
    _i13.Key? key,
    required _i14.BoxMovement boxMovement,
    required _i15.UserData user,
    List<_i12.PageRouteInfo>? children,
  }) : super(
          BoxMovementDetailRoute.name,
          args: BoxMovementDetailRouteArgs(
            key: key,
            boxMovement: boxMovement,
            user: user,
          ),
          initialChildren: children,
        );

  static const String name = 'BoxMovementDetailRoute';

  static const _i12.PageInfo<BoxMovementDetailRouteArgs> page =
      _i12.PageInfo<BoxMovementDetailRouteArgs>(name);
}

class BoxMovementDetailRouteArgs {
  const BoxMovementDetailRouteArgs({
    this.key,
    required this.boxMovement,
    required this.user,
  });

  final _i13.Key? key;

  final _i14.BoxMovement boxMovement;

  final _i15.UserData user;

  @override
  String toString() {
    return 'BoxMovementDetailRouteArgs{key: $key, boxMovement: $boxMovement, user: $user}';
  }
}

/// generated route for
/// [_i2.ChangePasswordScreen]
class ChangePasswordRoute extends _i12.PageRouteInfo<void> {
  const ChangePasswordRoute({List<_i12.PageRouteInfo>? children})
      : super(
          ChangePasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChangePasswordRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i3.DebugScreen]
class DebugRoute extends _i12.PageRouteInfo<void> {
  const DebugRoute({List<_i12.PageRouteInfo>? children})
      : super(
          DebugRoute.name,
          initialChildren: children,
        );

  static const String name = 'DebugRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i4.DonatedFoodDetailScreen]
class DonatedFoodDetailRoute
    extends _i12.PageRouteInfo<DonatedFoodDetailRouteArgs> {
  DonatedFoodDetailRoute({
    _i13.Key? key,
    required _i16.OfferedFood offeredFood,
    List<_i12.PageRouteInfo>? children,
  }) : super(
          DonatedFoodDetailRoute.name,
          args: DonatedFoodDetailRouteArgs(
            key: key,
            offeredFood: offeredFood,
          ),
          initialChildren: children,
        );

  static const String name = 'DonatedFoodDetailRoute';

  static const _i12.PageInfo<DonatedFoodDetailRouteArgs> page =
      _i12.PageInfo<DonatedFoodDetailRouteArgs>(name);
}

class DonatedFoodDetailRouteArgs {
  const DonatedFoodDetailRouteArgs({
    this.key,
    required this.offeredFood,
  });

  final _i13.Key? key;

  final _i16.OfferedFood offeredFood;

  @override
  String toString() {
    return 'DonatedFoodDetailRouteArgs{key: $key, offeredFood: $offeredFood}';
  }
}

/// generated route for
/// [_i5.ForgotPasswordScreen]
class ForgotPasswordRoute extends _i12.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i12.PageRouteInfo>? children})
      : super(
          ForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i6.HomeScreen]
class HomeRoute extends _i12.PageRouteInfo<void> {
  const HomeRoute({List<_i12.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i7.LoginScreen]
class LoginRoute extends _i12.PageRouteInfo<void> {
  const LoginRoute({List<_i12.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i8.MenuScreen]
class MenuRoute extends _i12.PageRouteInfo<void> {
  const MenuRoute({List<_i12.PageRouteInfo>? children})
      : super(
          MenuRoute.name,
          initialChildren: children,
        );

  static const String name = 'MenuRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i9.OfferFoodScreen]
class OfferFoodRoute extends _i12.PageRouteInfo<void> {
  const OfferFoodRoute({List<_i12.PageRouteInfo>? children})
      : super(
          OfferFoodRoute.name,
          initialChildren: children,
        );

  static const String name = 'OfferFoodRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i10.OrderShippingOfBoxesScreen]
class OrderShippingOfBoxesRoute extends _i12.PageRouteInfo<void> {
  const OrderShippingOfBoxesRoute({List<_i12.PageRouteInfo>? children})
      : super(
          OrderShippingOfBoxesRoute.name,
          initialChildren: children,
        );

  static const String name = 'OrderShippingOfBoxesRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i11.ThankYouScreen]
class ThankYouRoute extends _i12.PageRouteInfo<ThankYouRouteArgs> {
  ThankYouRoute({
    _i13.Key? key,
    required _i17.DocumentReference<Object>? response,
    required String message,
    List<_i12.PageRouteInfo>? children,
  }) : super(
          ThankYouRoute.name,
          args: ThankYouRouteArgs(
            key: key,
            response: response,
            message: message,
          ),
          initialChildren: children,
        );

  static const String name = 'ThankYouRoute';

  static const _i12.PageInfo<ThankYouRouteArgs> page =
      _i12.PageInfo<ThankYouRouteArgs>(name);
}

class ThankYouRouteArgs {
  const ThankYouRouteArgs({
    this.key,
    required this.response,
    required this.message,
  });

  final _i13.Key? key;

  final _i17.DocumentReference<Object>? response;

  final String message;

  @override
  String toString() {
    return 'ThankYouRouteArgs{key: $key, response: $response, message: $message}';
  }
}
