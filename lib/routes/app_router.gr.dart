// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i17;
import 'package:flutter/material.dart' as _i18;
import 'package:zachranobed/features/activepair/presentation/change_active_pair_screen.dart'
    as _i3;
import 'package:zachranobed/features/appTerms/presentation/app_terms_screen.dart'
    as _i1;
import 'package:zachranobed/features/debug/debug_screen.dart' as _i6;
import 'package:zachranobed/features/foodboxes/domain/model/box_movement.dart'
    as _i19;
import 'package:zachranobed/features/foodboxes/presentation/screen/box_movement_detail_screen.dart'
    as _i2;
import 'package:zachranobed/features/login/presentation/screen/login_screen.dart'
    as _i10;
import 'package:zachranobed/features/menu/presentation/contacts_screen.dart'
    as _i5;
import 'package:zachranobed/features/menu/presentation/menu_screen.dart'
    as _i11;
import 'package:zachranobed/features/offeredfood/domain/model/food_info.dart'
    as _i21;
import 'package:zachranobed/features/offeredfood/domain/model/offered_food.dart'
    as _i20;
import 'package:zachranobed/features/offeredfood/presentation/screens/donated_food_detail_screen.dart'
    as _i7;
import 'package:zachranobed/ui/screens/change_password_screen.dart' as _i4;
import 'package:zachranobed/ui/screens/forgot_password_screen.dart' as _i8;
import 'package:zachranobed/ui/screens/home_screen.dart' as _i9;
import 'package:zachranobed/ui/screens/offer_food_detail_screen.dart' as _i12;
import 'package:zachranobed/ui/screens/offer_food_overview_screen.dart' as _i13;
import 'package:zachranobed/ui/screens/offer_food_screen.dart' as _i14;
import 'package:zachranobed/ui/screens/order_shipping_of_boxes_screen.dart'
    as _i15;
import 'package:zachranobed/ui/screens/thank_you_screen.dart' as _i16;

abstract class $AppRouter extends _i17.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i17.PageFactory> pagesMap = {
    AppTermsRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.AppTermsScreen(),
      );
    },
    BoxMovementDetailRoute.name: (routeData) {
      final args = routeData.argsAs<BoxMovementDetailRouteArgs>();
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.BoxMovementDetailScreen(
          key: args.key,
          boxMovement: args.boxMovement,
        ),
      );
    },
    ChangeActivePairRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.ChangeActivePairScreen(),
      );
    },
    ChangePasswordRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.ChangePasswordScreen(),
      );
    },
    ContactsRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.ContactsScreen(),
      );
    },
    DebugRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.DebugScreen(),
      );
    },
    DonatedFoodDetailRoute.name: (routeData) {
      final args = routeData.argsAs<DonatedFoodDetailRouteArgs>();
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i7.DonatedFoodDetailScreen(
          key: args.key,
          offeredFood: args.offeredFood,
        ),
      );
    },
    ForgotPasswordRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.ForgotPasswordScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.HomeScreen(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.LoginScreen(),
      );
    },
    MenuRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.MenuScreen(),
      );
    },
    OfferFoodDetailRoute.name: (routeData) {
      final args = routeData.argsAs<OfferFoodDetailRouteArgs>();
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i12.OfferFoodDetailScreen(
          key: args.key,
          editedFoodInfo: args.editedFoodInfo,
          allFoodInfos: args.allFoodInfos,
        ),
      );
    },
    OfferFoodOverviewRoute.name: (routeData) {
      final args = routeData.argsAs<OfferFoodOverviewRouteArgs>();
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i13.OfferFoodOverviewScreen(
          key: args.key,
          foodInfos: args.foodInfos,
        ),
      );
    },
    OfferFoodRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i14.OfferFoodScreen(),
      );
    },
    OrderShippingOfBoxesRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i15.OrderShippingOfBoxesScreen(),
      );
    },
    ThankYouRoute.name: (routeData) {
      final args = routeData.argsAs<ThankYouRouteArgs>();
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i16.ThankYouScreen(
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
class AppTermsRoute extends _i17.PageRouteInfo<void> {
  const AppTermsRoute({List<_i17.PageRouteInfo>? children})
      : super(
          AppTermsRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppTermsRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i2.BoxMovementDetailScreen]
class BoxMovementDetailRoute
    extends _i17.PageRouteInfo<BoxMovementDetailRouteArgs> {
  BoxMovementDetailRoute({
    _i18.Key? key,
    required _i19.BoxMovement boxMovement,
    List<_i17.PageRouteInfo>? children,
  }) : super(
          BoxMovementDetailRoute.name,
          args: BoxMovementDetailRouteArgs(
            key: key,
            boxMovement: boxMovement,
          ),
          initialChildren: children,
        );

  static const String name = 'BoxMovementDetailRoute';

  static const _i17.PageInfo<BoxMovementDetailRouteArgs> page =
      _i17.PageInfo<BoxMovementDetailRouteArgs>(name);
}

class BoxMovementDetailRouteArgs {
  const BoxMovementDetailRouteArgs({
    this.key,
    required this.boxMovement,
  });

  final _i18.Key? key;

  final _i19.BoxMovement boxMovement;

  @override
  String toString() {
    return 'BoxMovementDetailRouteArgs{key: $key, boxMovement: $boxMovement}';
  }
}

/// generated route for
/// [_i3.ChangeActivePairScreen]
class ChangeActivePairRoute extends _i17.PageRouteInfo<void> {
  const ChangeActivePairRoute({List<_i17.PageRouteInfo>? children})
      : super(
          ChangeActivePairRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChangeActivePairRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i4.ChangePasswordScreen]
class ChangePasswordRoute extends _i17.PageRouteInfo<void> {
  const ChangePasswordRoute({List<_i17.PageRouteInfo>? children})
      : super(
          ChangePasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChangePasswordRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i5.ContactsScreen]
class ContactsRoute extends _i17.PageRouteInfo<void> {
  const ContactsRoute({List<_i17.PageRouteInfo>? children})
      : super(
          ContactsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ContactsRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i6.DebugScreen]
class DebugRoute extends _i17.PageRouteInfo<void> {
  const DebugRoute({List<_i17.PageRouteInfo>? children})
      : super(
          DebugRoute.name,
          initialChildren: children,
        );

  static const String name = 'DebugRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i7.DonatedFoodDetailScreen]
class DonatedFoodDetailRoute
    extends _i17.PageRouteInfo<DonatedFoodDetailRouteArgs> {
  DonatedFoodDetailRoute({
    _i18.Key? key,
    required _i20.OfferedFood offeredFood,
    List<_i17.PageRouteInfo>? children,
  }) : super(
          DonatedFoodDetailRoute.name,
          args: DonatedFoodDetailRouteArgs(
            key: key,
            offeredFood: offeredFood,
          ),
          initialChildren: children,
        );

  static const String name = 'DonatedFoodDetailRoute';

  static const _i17.PageInfo<DonatedFoodDetailRouteArgs> page =
      _i17.PageInfo<DonatedFoodDetailRouteArgs>(name);
}

class DonatedFoodDetailRouteArgs {
  const DonatedFoodDetailRouteArgs({
    this.key,
    required this.offeredFood,
  });

  final _i18.Key? key;

  final _i20.OfferedFood offeredFood;

  @override
  String toString() {
    return 'DonatedFoodDetailRouteArgs{key: $key, offeredFood: $offeredFood}';
  }
}

/// generated route for
/// [_i8.ForgotPasswordScreen]
class ForgotPasswordRoute extends _i17.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i17.PageRouteInfo>? children})
      : super(
          ForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i9.HomeScreen]
class HomeRoute extends _i17.PageRouteInfo<void> {
  const HomeRoute({List<_i17.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i10.LoginScreen]
class LoginRoute extends _i17.PageRouteInfo<void> {
  const LoginRoute({List<_i17.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i11.MenuScreen]
class MenuRoute extends _i17.PageRouteInfo<void> {
  const MenuRoute({List<_i17.PageRouteInfo>? children})
      : super(
          MenuRoute.name,
          initialChildren: children,
        );

  static const String name = 'MenuRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i12.OfferFoodDetailScreen]
class OfferFoodDetailRoute
    extends _i17.PageRouteInfo<OfferFoodDetailRouteArgs> {
  OfferFoodDetailRoute({
    _i18.Key? key,
    required _i21.FoodInfo editedFoodInfo,
    required List<_i21.FoodInfo> allFoodInfos,
    List<_i17.PageRouteInfo>? children,
  }) : super(
          OfferFoodDetailRoute.name,
          args: OfferFoodDetailRouteArgs(
            key: key,
            editedFoodInfo: editedFoodInfo,
            allFoodInfos: allFoodInfos,
          ),
          initialChildren: children,
        );

  static const String name = 'OfferFoodDetailRoute';

  static const _i17.PageInfo<OfferFoodDetailRouteArgs> page =
      _i17.PageInfo<OfferFoodDetailRouteArgs>(name);
}

class OfferFoodDetailRouteArgs {
  const OfferFoodDetailRouteArgs({
    this.key,
    required this.editedFoodInfo,
    required this.allFoodInfos,
  });

  final _i18.Key? key;

  final _i21.FoodInfo editedFoodInfo;

  final List<_i21.FoodInfo> allFoodInfos;

  @override
  String toString() {
    return 'OfferFoodDetailRouteArgs{key: $key, editedFoodInfo: $editedFoodInfo, allFoodInfos: $allFoodInfos}';
  }
}

/// generated route for
/// [_i13.OfferFoodOverviewScreen]
class OfferFoodOverviewRoute
    extends _i17.PageRouteInfo<OfferFoodOverviewRouteArgs> {
  OfferFoodOverviewRoute({
    _i18.Key? key,
    required List<_i21.FoodInfo> foodInfos,
    List<_i17.PageRouteInfo>? children,
  }) : super(
          OfferFoodOverviewRoute.name,
          args: OfferFoodOverviewRouteArgs(
            key: key,
            foodInfos: foodInfos,
          ),
          initialChildren: children,
        );

  static const String name = 'OfferFoodOverviewRoute';

  static const _i17.PageInfo<OfferFoodOverviewRouteArgs> page =
      _i17.PageInfo<OfferFoodOverviewRouteArgs>(name);
}

class OfferFoodOverviewRouteArgs {
  const OfferFoodOverviewRouteArgs({
    this.key,
    required this.foodInfos,
  });

  final _i18.Key? key;

  final List<_i21.FoodInfo> foodInfos;

  @override
  String toString() {
    return 'OfferFoodOverviewRouteArgs{key: $key, foodInfos: $foodInfos}';
  }
}

/// generated route for
/// [_i14.OfferFoodScreen]
class OfferFoodRoute extends _i17.PageRouteInfo<void> {
  const OfferFoodRoute({List<_i17.PageRouteInfo>? children})
      : super(
          OfferFoodRoute.name,
          initialChildren: children,
        );

  static const String name = 'OfferFoodRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i15.OrderShippingOfBoxesScreen]
class OrderShippingOfBoxesRoute extends _i17.PageRouteInfo<void> {
  const OrderShippingOfBoxesRoute({List<_i17.PageRouteInfo>? children})
      : super(
          OrderShippingOfBoxesRoute.name,
          initialChildren: children,
        );

  static const String name = 'OrderShippingOfBoxesRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i16.ThankYouScreen]
class ThankYouRoute extends _i17.PageRouteInfo<ThankYouRouteArgs> {
  ThankYouRoute({
    _i18.Key? key,
    required bool isSuccess,
    required String message,
    List<_i17.PageRouteInfo>? children,
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

  static const _i17.PageInfo<ThankYouRouteArgs> page =
      _i17.PageInfo<ThankYouRouteArgs>(name);
}

class ThankYouRouteArgs {
  const ThankYouRouteArgs({
    this.key,
    required this.isSuccess,
    required this.message,
  });

  final _i18.Key? key;

  final bool isSuccess;

  final String message;

  @override
  String toString() {
    return 'ThankYouRouteArgs{key: $key, isSuccess: $isSuccess, message: $message}';
  }
}
