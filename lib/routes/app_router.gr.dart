// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i8;
import 'package:cloud_firestore/cloud_firestore.dart' as _i11;
import 'package:flutter/material.dart' as _i9;
import 'package:zachranobed/models/offered_food.dart' as _i10;
import 'package:zachranobed/ui/screens/change_password_screen.dart' as _i1;
import 'package:zachranobed/ui/screens/donated_food_detail_screen.dart' as _i2;
import 'package:zachranobed/ui/screens/home_screen.dart' as _i3;
import 'package:zachranobed/ui/screens/login_screen.dart' as _i4;
import 'package:zachranobed/ui/screens/menu_screen.dart' as _i5;
import 'package:zachranobed/ui/screens/offer_food_screen.dart' as _i6;
import 'package:zachranobed/ui/screens/thank_you_screen.dart' as _i7;

abstract class $AppRouter extends _i8.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i8.PageFactory> pagesMap = {
    ChangePasswordRoute.name: (routeData) {
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.ChangePasswordScreen(),
      );
    },
    DonatedFoodDetailRoute.name: (routeData) {
      final args = routeData.argsAs<DonatedFoodDetailRouteArgs>();
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.DonatedFoodDetailScreen(
          key: args.key,
          offeredFood: args.offeredFood,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.HomeScreen(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.LoginScreen(),
      );
    },
    MenuRoute.name: (routeData) {
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.MenuScreen(),
      );
    },
    OfferFoodRoute.name: (routeData) {
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.OfferFoodScreen(),
      );
    },
    ThankYouRoute.name: (routeData) {
      final args = routeData.argsAs<ThankYouRouteArgs>();
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i7.ThankYouScreen(
          key: args.key,
          response: args.response,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.ChangePasswordScreen]
class ChangePasswordRoute extends _i8.PageRouteInfo<void> {
  const ChangePasswordRoute({List<_i8.PageRouteInfo>? children})
      : super(
          ChangePasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChangePasswordRoute';

  static const _i8.PageInfo<void> page = _i8.PageInfo<void>(name);
}

/// generated route for
/// [_i2.DonatedFoodDetailScreen]
class DonatedFoodDetailRoute
    extends _i8.PageRouteInfo<DonatedFoodDetailRouteArgs> {
  DonatedFoodDetailRoute({
    _i9.Key? key,
    required _i10.OfferedFood offeredFood,
    List<_i8.PageRouteInfo>? children,
  }) : super(
          DonatedFoodDetailRoute.name,
          args: DonatedFoodDetailRouteArgs(
            key: key,
            offeredFood: offeredFood,
          ),
          initialChildren: children,
        );

  static const String name = 'DonatedFoodDetailRoute';

  static const _i8.PageInfo<DonatedFoodDetailRouteArgs> page =
      _i8.PageInfo<DonatedFoodDetailRouteArgs>(name);
}

class DonatedFoodDetailRouteArgs {
  const DonatedFoodDetailRouteArgs({
    this.key,
    required this.offeredFood,
  });

  final _i9.Key? key;

  final _i10.OfferedFood offeredFood;

  @override
  String toString() {
    return 'DonatedFoodDetailRouteArgs{key: $key, offeredFood: $offeredFood}';
  }
}

/// generated route for
/// [_i3.HomeScreen]
class HomeRoute extends _i8.PageRouteInfo<void> {
  const HomeRoute({List<_i8.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i8.PageInfo<void> page = _i8.PageInfo<void>(name);
}

/// generated route for
/// [_i4.LoginScreen]
class LoginRoute extends _i8.PageRouteInfo<void> {
  const LoginRoute({List<_i8.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i8.PageInfo<void> page = _i8.PageInfo<void>(name);
}

/// generated route for
/// [_i5.MenuScreen]
class MenuRoute extends _i8.PageRouteInfo<void> {
  const MenuRoute({List<_i8.PageRouteInfo>? children})
      : super(
          MenuRoute.name,
          initialChildren: children,
        );

  static const String name = 'MenuRoute';

  static const _i8.PageInfo<void> page = _i8.PageInfo<void>(name);
}

/// generated route for
/// [_i6.OfferFoodScreen]
class OfferFoodRoute extends _i8.PageRouteInfo<void> {
  const OfferFoodRoute({List<_i8.PageRouteInfo>? children})
      : super(
          OfferFoodRoute.name,
          initialChildren: children,
        );

  static const String name = 'OfferFoodRoute';

  static const _i8.PageInfo<void> page = _i8.PageInfo<void>(name);
}

/// generated route for
/// [_i7.ThankYouScreen]
class ThankYouRoute extends _i8.PageRouteInfo<ThankYouRouteArgs> {
  ThankYouRoute({
    _i9.Key? key,
    required _i11.DocumentReference<_i10.OfferedFood>? response,
    List<_i8.PageRouteInfo>? children,
  }) : super(
          ThankYouRoute.name,
          args: ThankYouRouteArgs(
            key: key,
            response: response,
          ),
          initialChildren: children,
        );

  static const String name = 'ThankYouRoute';

  static const _i8.PageInfo<ThankYouRouteArgs> page =
      _i8.PageInfo<ThankYouRouteArgs>(name);
}

class ThankYouRouteArgs {
  const ThankYouRouteArgs({
    this.key,
    required this.response,
  });

  final _i9.Key? key;

  final _i11.DocumentReference<_i10.OfferedFood>? response;

  @override
  String toString() {
    return 'ThankYouRouteArgs{key: $key, response: $response}';
  }
}
