// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i10;

import 'package:auto_route/auto_route.dart' as _i7;
import 'package:cloud_firestore/cloud_firestore.dart' as _i11;
import 'package:flutter/material.dart' as _i8;
import 'package:zachranobed/models/offered_food.dart' as _i9;
import 'package:zachranobed/ui/screens/donated_food_detail_screen.dart' as _i1;
import 'package:zachranobed/ui/screens/home_screen.dart' as _i2;
import 'package:zachranobed/ui/screens/login_screen.dart' as _i3;
import 'package:zachranobed/ui/screens/menu_screen.dart' as _i4;
import 'package:zachranobed/ui/screens/offer_food_screen.dart' as _i5;
import 'package:zachranobed/ui/screens/thank_you_screen.dart' as _i6;

abstract class $AppRouter extends _i7.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i7.PageFactory> pagesMap = {
    DonatedFoodDetailRoute.name: (routeData) {
      final args = routeData.argsAs<DonatedFoodDetailRouteArgs>();
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.DonatedFoodDetailScreen(
          key: args.key,
          offeredFood: args.offeredFood,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.HomeScreen(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.LoginScreen(),
      );
    },
    MenuRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.MenuScreen(),
      );
    },
    OfferFoodRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.OfferFoodScreen(),
      );
    },
    ThankYouRoute.name: (routeData) {
      final args = routeData.argsAs<ThankYouRouteArgs>();
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i6.ThankYouScreen(
          key: args.key,
          response: args.response,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.DonatedFoodDetailScreen]
class DonatedFoodDetailRoute
    extends _i7.PageRouteInfo<DonatedFoodDetailRouteArgs> {
  DonatedFoodDetailRoute({
    _i8.Key? key,
    required _i9.OfferedFood offeredFood,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          DonatedFoodDetailRoute.name,
          args: DonatedFoodDetailRouteArgs(
            key: key,
            offeredFood: offeredFood,
          ),
          initialChildren: children,
        );

  static const String name = 'DonatedFoodDetailRoute';

  static const _i7.PageInfo<DonatedFoodDetailRouteArgs> page =
      _i7.PageInfo<DonatedFoodDetailRouteArgs>(name);
}

class DonatedFoodDetailRouteArgs {
  const DonatedFoodDetailRouteArgs({
    this.key,
    required this.offeredFood,
  });

  final _i8.Key? key;

  final _i9.OfferedFood offeredFood;

  @override
  String toString() {
    return 'DonatedFoodDetailRouteArgs{key: $key, offeredFood: $offeredFood}';
  }
}

/// generated route for
/// [_i2.HomeScreen]
class HomeRoute extends _i7.PageRouteInfo<void> {
  const HomeRoute({List<_i7.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i3.LoginScreen]
class LoginRoute extends _i7.PageRouteInfo<void> {
  const LoginRoute({List<_i7.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i4.MenuScreen]
class MenuRoute extends _i7.PageRouteInfo<void> {
  const MenuRoute({List<_i7.PageRouteInfo>? children})
      : super(
          MenuRoute.name,
          initialChildren: children,
        );

  static const String name = 'MenuRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i5.OfferFoodScreen]
class OfferFoodRoute extends _i7.PageRouteInfo<void> {
  const OfferFoodRoute({List<_i7.PageRouteInfo>? children})
      : super(
          OfferFoodRoute.name,
          initialChildren: children,
        );

  static const String name = 'OfferFoodRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i6.ThankYouScreen]
class ThankYouRoute extends _i7.PageRouteInfo<ThankYouRouteArgs> {
  ThankYouRoute({
    _i8.Key? key,
    required _i10.Future<_i11.DocumentReference<_i9.OfferedFood>> response,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          ThankYouRoute.name,
          args: ThankYouRouteArgs(
            key: key,
            response: response,
          ),
          initialChildren: children,
        );

  static const String name = 'ThankYouRoute';

  static const _i7.PageInfo<ThankYouRouteArgs> page =
      _i7.PageInfo<ThankYouRouteArgs>(name);
}

class ThankYouRouteArgs {
  const ThankYouRouteArgs({
    this.key,
    required this.response,
  });

  final _i8.Key? key;

  final _i10.Future<_i11.DocumentReference<_i9.OfferedFood>> response;

  @override
  String toString() {
    return 'ThankYouRouteArgs{key: $key, response: $response}';
  }
}
