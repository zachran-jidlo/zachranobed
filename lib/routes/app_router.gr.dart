// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:cloud_firestore/cloud_firestore.dart' as _i13;
import 'package:flutter/material.dart' as _i10;
import 'package:zachranobed/models/box_movement.dart' as _i11;
import 'package:zachranobed/models/offered_food.dart' as _i12;
import 'package:zachranobed/ui/screens/box_movement_detail_screen.dart' as _i1;
import 'package:zachranobed/ui/screens/change_password_screen.dart' as _i2;
import 'package:zachranobed/ui/screens/donated_food_detail_screen.dart' as _i3;
import 'package:zachranobed/ui/screens/home_screen.dart' as _i4;
import 'package:zachranobed/ui/screens/login_screen.dart' as _i5;
import 'package:zachranobed/ui/screens/menu_screen.dart' as _i6;
import 'package:zachranobed/ui/screens/offer_food_screen.dart' as _i7;
import 'package:zachranobed/ui/screens/thank_you_screen.dart' as _i8;

abstract class $AppRouter extends _i9.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i9.PageFactory> pagesMap = {
    BoxMovementDetailRoute.name: (routeData) {
      final args = routeData.argsAs<BoxMovementDetailRouteArgs>();
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.BoxMovementDetailScreen(
          key: args.key,
          boxMovement: args.boxMovement,
        ),
      );
    },
    ChangePasswordRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.ChangePasswordScreen(),
      );
    },
    DonatedFoodDetailRoute.name: (routeData) {
      final args = routeData.argsAs<DonatedFoodDetailRouteArgs>();
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.DonatedFoodDetailScreen(
          key: args.key,
          offeredFood: args.offeredFood,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.HomeScreen(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.LoginScreen(),
      );
    },
    MenuRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.MenuScreen(),
      );
    },
    OfferFoodRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.OfferFoodScreen(),
      );
    },
    ThankYouRoute.name: (routeData) {
      final args = routeData.argsAs<ThankYouRouteArgs>();
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i8.ThankYouScreen(
          key: args.key,
          response: args.response,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.BoxMovementDetailScreen]
class BoxMovementDetailRoute
    extends _i9.PageRouteInfo<BoxMovementDetailRouteArgs> {
  BoxMovementDetailRoute({
    _i10.Key? key,
    required _i11.BoxMovement boxMovement,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          BoxMovementDetailRoute.name,
          args: BoxMovementDetailRouteArgs(
            key: key,
            boxMovement: boxMovement,
          ),
          initialChildren: children,
        );

  static const String name = 'BoxMovementDetailRoute';

  static const _i9.PageInfo<BoxMovementDetailRouteArgs> page =
      _i9.PageInfo<BoxMovementDetailRouteArgs>(name);
}

class BoxMovementDetailRouteArgs {
  const BoxMovementDetailRouteArgs({
    this.key,
    required this.boxMovement,
  });

  final _i10.Key? key;

  final _i11.BoxMovement boxMovement;

  @override
  String toString() {
    return 'BoxMovementDetailRouteArgs{key: $key, boxMovement: $boxMovement}';
  }
}

/// generated route for
/// [_i2.ChangePasswordScreen]
class ChangePasswordRoute extends _i9.PageRouteInfo<void> {
  const ChangePasswordRoute({List<_i9.PageRouteInfo>? children})
      : super(
          ChangePasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChangePasswordRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i3.DonatedFoodDetailScreen]
class DonatedFoodDetailRoute
    extends _i9.PageRouteInfo<DonatedFoodDetailRouteArgs> {
  DonatedFoodDetailRoute({
    _i10.Key? key,
    required _i12.OfferedFood offeredFood,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          DonatedFoodDetailRoute.name,
          args: DonatedFoodDetailRouteArgs(
            key: key,
            offeredFood: offeredFood,
          ),
          initialChildren: children,
        );

  static const String name = 'DonatedFoodDetailRoute';

  static const _i9.PageInfo<DonatedFoodDetailRouteArgs> page =
      _i9.PageInfo<DonatedFoodDetailRouteArgs>(name);
}

class DonatedFoodDetailRouteArgs {
  const DonatedFoodDetailRouteArgs({
    this.key,
    required this.offeredFood,
  });

  final _i10.Key? key;

  final _i12.OfferedFood offeredFood;

  @override
  String toString() {
    return 'DonatedFoodDetailRouteArgs{key: $key, offeredFood: $offeredFood}';
  }
}

/// generated route for
/// [_i4.HomeScreen]
class HomeRoute extends _i9.PageRouteInfo<void> {
  const HomeRoute({List<_i9.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i5.LoginScreen]
class LoginRoute extends _i9.PageRouteInfo<void> {
  const LoginRoute({List<_i9.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i6.MenuScreen]
class MenuRoute extends _i9.PageRouteInfo<void> {
  const MenuRoute({List<_i9.PageRouteInfo>? children})
      : super(
          MenuRoute.name,
          initialChildren: children,
        );

  static const String name = 'MenuRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i7.OfferFoodScreen]
class OfferFoodRoute extends _i9.PageRouteInfo<void> {
  const OfferFoodRoute({List<_i9.PageRouteInfo>? children})
      : super(
          OfferFoodRoute.name,
          initialChildren: children,
        );

  static const String name = 'OfferFoodRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i8.ThankYouScreen]
class ThankYouRoute extends _i9.PageRouteInfo<ThankYouRouteArgs> {
  ThankYouRoute({
    _i10.Key? key,
    required _i13.DocumentReference<_i12.OfferedFood>? response,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          ThankYouRoute.name,
          args: ThankYouRouteArgs(
            key: key,
            response: response,
          ),
          initialChildren: children,
        );

  static const String name = 'ThankYouRoute';

  static const _i9.PageInfo<ThankYouRouteArgs> page =
      _i9.PageInfo<ThankYouRouteArgs>(name);
}

class ThankYouRouteArgs {
  const ThankYouRouteArgs({
    this.key,
    required this.response,
  });

  final _i10.Key? key;

  final _i13.DocumentReference<_i12.OfferedFood>? response;

  @override
  String toString() {
    return 'ThankYouRouteArgs{key: $key, response: $response}';
  }
}
