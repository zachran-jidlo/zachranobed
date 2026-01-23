// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i17;
import 'package:collection/collection.dart' as _i20;
import 'package:flutter/material.dart' as _i18;
import 'package:zachranobed/app/presentation/home_screen.dart' as _i9;
import 'package:zachranobed/features/activepair/presentation/change_active_pair_screen.dart'
    as _i2;
import 'package:zachranobed/features/appTerms/presentation/app_terms_screen.dart'
    as _i1;
import 'package:zachranobed/features/debug/components_screen.dart' as _i4;
import 'package:zachranobed/features/debug/debug_screen.dart' as _i6;
import 'package:zachranobed/features/food/domain/model/food_box_type.dart'
    as _i19;
import 'package:zachranobed/features/food/domain/model/food_info.dart' as _i21;
import 'package:zachranobed/features/food/presentation/screens/offer_food_boxes_screen.dart'
    as _i12;
import 'package:zachranobed/features/food/presentation/screens/offer_food_detail_screen.dart'
    as _i11;
import 'package:zachranobed/features/food/presentation/screens/offer_food_overview_screen.dart'
    as _i13;
import 'package:zachranobed/features/food/presentation/screens/order_shipping_of_boxes_screen.dart'
    as _i14;
import 'package:zachranobed/features/food/presentation/screens/thank_you_screen.dart'
    as _i16;
import 'package:zachranobed/features/forceupdate/presentation/force_update_screen.dart'
    as _i7;
import 'package:zachranobed/features/login/presentation/screen/change_password_screen.dart'
    as _i3;
import 'package:zachranobed/features/login/presentation/screen/forgot_password_screen.dart'
    as _i8;
import 'package:zachranobed/features/login/presentation/screen/login_screen.dart'
    as _i10;
import 'package:zachranobed/features/menu/presentation/contacts_screen.dart'
    as _i5;
import 'package:zachranobed/features/menu/presentation/profile_screen.dart'
    as _i15;

/// generated route for
/// [_i1.AppTermsScreen]
class AppTermsRoute extends _i17.PageRouteInfo<AppTermsRouteArgs> {
  AppTermsRoute({
    _i18.Key? key,
    required bool hasNoAcceptedVersion,
    List<_i17.PageRouteInfo>? children,
  }) : super(
          AppTermsRoute.name,
          args: AppTermsRouteArgs(
            key: key,
            hasNoAcceptedVersion: hasNoAcceptedVersion,
          ),
          initialChildren: children,
        );

  static const String name = 'AppTermsRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AppTermsRouteArgs>();
      return _i1.AppTermsScreen(
        key: args.key,
        hasNoAcceptedVersion: args.hasNoAcceptedVersion,
      );
    },
  );
}

class AppTermsRouteArgs {
  const AppTermsRouteArgs({this.key, required this.hasNoAcceptedVersion});

  final _i18.Key? key;

  final bool hasNoAcceptedVersion;

  @override
  String toString() {
    return 'AppTermsRouteArgs{key: $key, hasNoAcceptedVersion: $hasNoAcceptedVersion}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AppTermsRouteArgs) return false;
    return key == other.key &&
        hasNoAcceptedVersion == other.hasNoAcceptedVersion;
  }

  @override
  int get hashCode => key.hashCode ^ hasNoAcceptedVersion.hashCode;
}

/// generated route for
/// [_i2.ChangeActivePairScreen]
class ChangeActivePairRoute extends _i17.PageRouteInfo<void> {
  const ChangeActivePairRoute({List<_i17.PageRouteInfo>? children})
      : super(ChangeActivePairRoute.name, initialChildren: children);

  static const String name = 'ChangeActivePairRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i2.ChangeActivePairScreen();
    },
  );
}

/// generated route for
/// [_i3.ChangePasswordScreen]
class ChangePasswordRoute extends _i17.PageRouteInfo<void> {
  const ChangePasswordRoute({List<_i17.PageRouteInfo>? children})
      : super(ChangePasswordRoute.name, initialChildren: children);

  static const String name = 'ChangePasswordRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i3.ChangePasswordScreen();
    },
  );
}

/// generated route for
/// [_i4.ComponentsScreen]
class ComponentsRoute extends _i17.PageRouteInfo<void> {
  const ComponentsRoute({List<_i17.PageRouteInfo>? children})
      : super(ComponentsRoute.name, initialChildren: children);

  static const String name = 'ComponentsRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i4.ComponentsScreen();
    },
  );
}

/// generated route for
/// [_i5.ContactsScreen]
class ContactsRoute extends _i17.PageRouteInfo<void> {
  const ContactsRoute({List<_i17.PageRouteInfo>? children})
      : super(ContactsRoute.name, initialChildren: children);

  static const String name = 'ContactsRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i5.ContactsScreen();
    },
  );
}

/// generated route for
/// [_i6.DebugScreen]
class DebugRoute extends _i17.PageRouteInfo<void> {
  const DebugRoute({List<_i17.PageRouteInfo>? children})
      : super(DebugRoute.name, initialChildren: children);

  static const String name = 'DebugRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i6.DebugScreen();
    },
  );
}

/// generated route for
/// [_i7.ForceUpdateScreen]
class ForceUpdateRoute extends _i17.PageRouteInfo<void> {
  const ForceUpdateRoute({List<_i17.PageRouteInfo>? children})
      : super(ForceUpdateRoute.name, initialChildren: children);

  static const String name = 'ForceUpdateRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i7.ForceUpdateScreen();
    },
  );
}

/// generated route for
/// [_i8.ForgotPasswordScreen]
class ForgotPasswordRoute extends _i17.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i17.PageRouteInfo>? children})
      : super(ForgotPasswordRoute.name, initialChildren: children);

  static const String name = 'ForgotPasswordRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i8.ForgotPasswordScreen();
    },
  );
}

/// generated route for
/// [_i9.HomeScreen]
class HomeRoute extends _i17.PageRouteInfo<void> {
  const HomeRoute({List<_i17.PageRouteInfo>? children})
      : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i9.HomeScreen();
    },
  );
}

/// generated route for
/// [_i10.LoginScreen]
class LoginRoute extends _i17.PageRouteInfo<void> {
  const LoginRoute({List<_i17.PageRouteInfo>? children})
      : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i10.LoginScreen();
    },
  );
}

/// generated route for
/// [_i11.OfferFoodAddNewScreen]
class OfferFoodAddNewRoute extends _i17.PageRouteInfo<void> {
  const OfferFoodAddNewRoute({List<_i17.PageRouteInfo>? children})
      : super(OfferFoodAddNewRoute.name, initialChildren: children);

  static const String name = 'OfferFoodAddNewRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i11.OfferFoodAddNewScreen();
    },
  );
}

/// generated route for
/// [_i12.OfferFoodBoxesScreen]
class OfferFoodBoxesRoute extends _i17.PageRouteInfo<OfferFoodBoxesRouteArgs> {
  OfferFoodBoxesRoute({
    _i18.Key? key,
    required Map<_i19.FoodBoxType, int> currentBoxesQuantity,
    List<_i17.PageRouteInfo>? children,
  }) : super(
          OfferFoodBoxesRoute.name,
          args: OfferFoodBoxesRouteArgs(
            key: key,
            currentBoxesQuantity: currentBoxesQuantity,
          ),
          initialChildren: children,
        );

  static const String name = 'OfferFoodBoxesRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OfferFoodBoxesRouteArgs>();
      return _i12.OfferFoodBoxesScreen(
        key: args.key,
        currentBoxesQuantity: args.currentBoxesQuantity,
      );
    },
  );
}

class OfferFoodBoxesRouteArgs {
  const OfferFoodBoxesRouteArgs({this.key, required this.currentBoxesQuantity});

  final _i18.Key? key;

  final Map<_i19.FoodBoxType, int> currentBoxesQuantity;

  @override
  String toString() {
    return 'OfferFoodBoxesRouteArgs{key: $key, currentBoxesQuantity: $currentBoxesQuantity}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OfferFoodBoxesRouteArgs) return false;
    return key == other.key &&
        const _i20.MapEquality().equals(
          currentBoxesQuantity,
          other.currentBoxesQuantity,
        );
  }

  @override
  int get hashCode =>
      key.hashCode ^ const _i20.MapEquality().hash(currentBoxesQuantity);
}

/// generated route for
/// [_i11.OfferFoodEditExistingScreen]
class OfferFoodEditExistingRoute
    extends _i17.PageRouteInfo<OfferFoodEditExistingRouteArgs> {
  OfferFoodEditExistingRoute({
    _i18.Key? key,
    required _i21.FoodInfo foodInfo,
    List<_i17.PageRouteInfo>? children,
  }) : super(
          OfferFoodEditExistingRoute.name,
          args: OfferFoodEditExistingRouteArgs(key: key, foodInfo: foodInfo),
          initialChildren: children,
        );

  static const String name = 'OfferFoodEditExistingRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OfferFoodEditExistingRouteArgs>();
      return _i11.OfferFoodEditExistingScreen(
        key: args.key,
        foodInfo: args.foodInfo,
      );
    },
  );
}

class OfferFoodEditExistingRouteArgs {
  const OfferFoodEditExistingRouteArgs({this.key, required this.foodInfo});

  final _i18.Key? key;

  final _i21.FoodInfo foodInfo;

  @override
  String toString() {
    return 'OfferFoodEditExistingRouteArgs{key: $key, foodInfo: $foodInfo}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OfferFoodEditExistingRouteArgs) return false;
    return key == other.key && foodInfo == other.foodInfo;
  }

  @override
  int get hashCode => key.hashCode ^ foodInfo.hashCode;
}

/// generated route for
/// [_i11.OfferFoodInitialScreen]
class OfferFoodInitialRoute extends _i17.PageRouteInfo<void> {
  const OfferFoodInitialRoute({List<_i17.PageRouteInfo>? children})
      : super(OfferFoodInitialRoute.name, initialChildren: children);

  static const String name = 'OfferFoodInitialRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i11.OfferFoodInitialScreen();
    },
  );
}

/// generated route for
/// [_i13.OfferFoodOverviewScreen]
class OfferFoodOverviewRoute
    extends _i17.PageRouteInfo<OfferFoodOverviewRouteArgs> {
  OfferFoodOverviewRoute({
    _i18.Key? key,
    required List<_i21.FoodInfo> initialFoodInfos,
    List<_i17.PageRouteInfo>? children,
  }) : super(
          OfferFoodOverviewRoute.name,
          args: OfferFoodOverviewRouteArgs(
            key: key,
            initialFoodInfos: initialFoodInfos,
          ),
          initialChildren: children,
        );

  static const String name = 'OfferFoodOverviewRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OfferFoodOverviewRouteArgs>();
      return _i13.OfferFoodOverviewScreen(
        key: args.key,
        initialFoodInfos: args.initialFoodInfos,
      );
    },
  );
}

class OfferFoodOverviewRouteArgs {
  const OfferFoodOverviewRouteArgs({this.key, required this.initialFoodInfos});

  final _i18.Key? key;

  final List<_i21.FoodInfo> initialFoodInfos;

  @override
  String toString() {
    return 'OfferFoodOverviewRouteArgs{key: $key, initialFoodInfos: $initialFoodInfos}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OfferFoodOverviewRouteArgs) return false;
    return key == other.key &&
        const _i20.ListEquality().equals(
          initialFoodInfos,
          other.initialFoodInfos,
        );
  }

  @override
  int get hashCode =>
      key.hashCode ^ const _i20.ListEquality().hash(initialFoodInfos);
}

/// generated route for
/// [_i14.OrderShippingOfBoxesScreen]
class OrderShippingOfBoxesRoute extends _i17.PageRouteInfo<void> {
  const OrderShippingOfBoxesRoute({List<_i17.PageRouteInfo>? children})
      : super(OrderShippingOfBoxesRoute.name, initialChildren: children);

  static const String name = 'OrderShippingOfBoxesRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i14.OrderShippingOfBoxesScreen();
    },
  );
}

/// generated route for
/// [_i15.ProfileScreen]
class ProfileRoute extends _i17.PageRouteInfo<void> {
  const ProfileRoute({List<_i17.PageRouteInfo>? children})
      : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i15.ProfileScreen();
    },
  );
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

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ThankYouRouteArgs>();
      return _i16.ThankYouScreen(
        key: args.key,
        isSuccess: args.isSuccess,
        message: args.message,
      );
    },
  );
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ThankYouRouteArgs) return false;
    return key == other.key &&
        isSuccess == other.isSuccess &&
        message == other.message;
  }

  @override
  int get hashCode => key.hashCode ^ isSuccess.hashCode ^ message.hashCode;
}
