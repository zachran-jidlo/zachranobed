// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i19;
import 'package:collection/collection.dart' as _i24;
import 'package:flutter/foundation.dart' as _i21;
import 'package:flutter/material.dart' as _i20;
import 'package:zachranobed/app/presentation/home_screen.dart' as _i11;
import 'package:zachranobed/common/domain/model/user_data.dart' as _i22;
import 'package:zachranobed/features/activepair/presentation/change_active_pair_screen.dart'
    as _i2;
import 'package:zachranobed/features/appTerms/presentation/app_terms_screen.dart'
    as _i1;
import 'package:zachranobed/features/debug/components_screen.dart' as _i4;
import 'package:zachranobed/features/debug/debug_screen.dart' as _i6;
import 'package:zachranobed/features/food/domain/model/food_box_type.dart'
    as _i23;
import 'package:zachranobed/features/food/domain/model/food_info.dart' as _i25;
import 'package:zachranobed/features/food/presentation/screens/delivery_detail_screen.dart'
    as _i7;
import 'package:zachranobed/features/food/presentation/screens/food_boxes_detail_screen.dart'
    as _i8;
import 'package:zachranobed/features/food/presentation/screens/offer_food_boxes_screen.dart'
    as _i14;
import 'package:zachranobed/features/food/presentation/screens/offer_food_detail_screen.dart'
    as _i13;
import 'package:zachranobed/features/food/presentation/screens/offer_food_overview_screen.dart'
    as _i15;
import 'package:zachranobed/features/food/presentation/screens/order_shipping_of_boxes_screen.dart'
    as _i16;
import 'package:zachranobed/features/food/presentation/screens/thank_you_screen.dart'
    as _i18;
import 'package:zachranobed/features/forceupdate/presentation/force_update_screen.dart'
    as _i9;
import 'package:zachranobed/features/login/presentation/screen/change_password_screen.dart'
    as _i3;
import 'package:zachranobed/features/login/presentation/screen/forgot_password_screen.dart'
    as _i10;
import 'package:zachranobed/features/login/presentation/screen/login_screen.dart'
    as _i12;
import 'package:zachranobed/features/menu/presentation/contacts_screen.dart'
    as _i5;
import 'package:zachranobed/features/menu/presentation/profile_screen.dart'
    as _i17;

/// generated route for
/// [_i1.AppTermsScreen]
class AppTermsRoute extends _i19.PageRouteInfo<AppTermsRouteArgs> {
  AppTermsRoute({
    _i20.Key? key,
    required bool hasNoAcceptedVersion,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          AppTermsRoute.name,
          args: AppTermsRouteArgs(
            key: key,
            hasNoAcceptedVersion: hasNoAcceptedVersion,
          ),
          initialChildren: children,
        );

  static const String name = 'AppTermsRoute';

  static _i19.PageInfo page = _i19.PageInfo(
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

  final _i20.Key? key;

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
class ChangeActivePairRoute extends _i19.PageRouteInfo<void> {
  const ChangeActivePairRoute({List<_i19.PageRouteInfo>? children})
      : super(ChangeActivePairRoute.name, initialChildren: children);

  static const String name = 'ChangeActivePairRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i2.ChangeActivePairScreen();
    },
  );
}

/// generated route for
/// [_i3.ChangePasswordScreen]
class ChangePasswordRoute extends _i19.PageRouteInfo<void> {
  const ChangePasswordRoute({List<_i19.PageRouteInfo>? children})
      : super(ChangePasswordRoute.name, initialChildren: children);

  static const String name = 'ChangePasswordRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i3.ChangePasswordScreen();
    },
  );
}

/// generated route for
/// [_i4.ComponentsScreen]
class ComponentsRoute extends _i19.PageRouteInfo<void> {
  const ComponentsRoute({List<_i19.PageRouteInfo>? children})
      : super(ComponentsRoute.name, initialChildren: children);

  static const String name = 'ComponentsRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i4.ComponentsScreen();
    },
  );
}

/// generated route for
/// [_i5.ContactsScreen]
class ContactsRoute extends _i19.PageRouteInfo<void> {
  const ContactsRoute({List<_i19.PageRouteInfo>? children})
      : super(ContactsRoute.name, initialChildren: children);

  static const String name = 'ContactsRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i5.ContactsScreen();
    },
  );
}

/// generated route for
/// [_i6.DebugScreen]
class DebugRoute extends _i19.PageRouteInfo<void> {
  const DebugRoute({List<_i19.PageRouteInfo>? children})
      : super(DebugRoute.name, initialChildren: children);

  static const String name = 'DebugRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i6.DebugScreen();
    },
  );
}

/// generated route for
/// [_i7.DeliveryDetailScreen]
class DeliveryDetailRoute extends _i19.PageRouteInfo<DeliveryDetailRouteArgs> {
  DeliveryDetailRoute({
    _i21.Key? key,
    required String deliveryId,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          DeliveryDetailRoute.name,
          args: DeliveryDetailRouteArgs(key: key, deliveryId: deliveryId),
          initialChildren: children,
        );

  static const String name = 'DeliveryDetailRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DeliveryDetailRouteArgs>();
      return _i7.DeliveryDetailScreen(
        key: args.key,
        deliveryId: args.deliveryId,
      );
    },
  );
}

class DeliveryDetailRouteArgs {
  const DeliveryDetailRouteArgs({this.key, required this.deliveryId});

  final _i21.Key? key;

  final String deliveryId;

  @override
  String toString() {
    return 'DeliveryDetailRouteArgs{key: $key, deliveryId: $deliveryId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DeliveryDetailRouteArgs) return false;
    return key == other.key && deliveryId == other.deliveryId;
  }

  @override
  int get hashCode => key.hashCode ^ deliveryId.hashCode;
}

/// generated route for
/// [_i8.FoodBoxesDetailScreen]
class FoodBoxesDetailRoute
    extends _i19.PageRouteInfo<FoodBoxesDetailRouteArgs> {
  FoodBoxesDetailRoute({
    _i20.Key? key,
    required _i22.UserData user,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          FoodBoxesDetailRoute.name,
          args: FoodBoxesDetailRouteArgs(key: key, user: user),
          initialChildren: children,
        );

  static const String name = 'FoodBoxesDetailRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<FoodBoxesDetailRouteArgs>();
      return _i8.FoodBoxesDetailScreen(key: args.key, user: args.user);
    },
  );
}

class FoodBoxesDetailRouteArgs {
  const FoodBoxesDetailRouteArgs({this.key, required this.user});

  final _i20.Key? key;

  final _i22.UserData user;

  @override
  String toString() {
    return 'FoodBoxesDetailRouteArgs{key: $key, user: $user}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FoodBoxesDetailRouteArgs) return false;
    return key == other.key && user == other.user;
  }

  @override
  int get hashCode => key.hashCode ^ user.hashCode;
}

/// generated route for
/// [_i9.ForceUpdateScreen]
class ForceUpdateRoute extends _i19.PageRouteInfo<void> {
  const ForceUpdateRoute({List<_i19.PageRouteInfo>? children})
      : super(ForceUpdateRoute.name, initialChildren: children);

  static const String name = 'ForceUpdateRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i9.ForceUpdateScreen();
    },
  );
}

/// generated route for
/// [_i10.ForgotPasswordScreen]
class ForgotPasswordRoute extends _i19.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i19.PageRouteInfo>? children})
      : super(ForgotPasswordRoute.name, initialChildren: children);

  static const String name = 'ForgotPasswordRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i10.ForgotPasswordScreen();
    },
  );
}

/// generated route for
/// [_i11.HomeScreen]
class HomeRoute extends _i19.PageRouteInfo<void> {
  const HomeRoute({List<_i19.PageRouteInfo>? children})
      : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i11.HomeScreen();
    },
  );
}

/// generated route for
/// [_i12.LoginScreen]
class LoginRoute extends _i19.PageRouteInfo<void> {
  const LoginRoute({List<_i19.PageRouteInfo>? children})
      : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i12.LoginScreen();
    },
  );
}

/// generated route for
/// [_i13.OfferFoodAddNewScreen]
class OfferFoodAddNewRoute extends _i19.PageRouteInfo<void> {
  const OfferFoodAddNewRoute({List<_i19.PageRouteInfo>? children})
      : super(OfferFoodAddNewRoute.name, initialChildren: children);

  static const String name = 'OfferFoodAddNewRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i13.OfferFoodAddNewScreen();
    },
  );
}

/// generated route for
/// [_i14.OfferFoodBoxesScreen]
class OfferFoodBoxesRoute extends _i19.PageRouteInfo<OfferFoodBoxesRouteArgs> {
  OfferFoodBoxesRoute({
    _i20.Key? key,
    required Map<_i23.FoodBoxType, int> currentBoxesQuantity,
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

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OfferFoodBoxesRouteArgs>();
      return _i14.OfferFoodBoxesScreen(
        key: args.key,
        currentBoxesQuantity: args.currentBoxesQuantity,
      );
    },
  );
}

class OfferFoodBoxesRouteArgs {
  const OfferFoodBoxesRouteArgs({this.key, required this.currentBoxesQuantity});

  final _i20.Key? key;

  final Map<_i23.FoodBoxType, int> currentBoxesQuantity;

  @override
  String toString() {
    return 'OfferFoodBoxesRouteArgs{key: $key, currentBoxesQuantity: $currentBoxesQuantity}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OfferFoodBoxesRouteArgs) return false;
    return key == other.key &&
        const _i24.MapEquality().equals(
          currentBoxesQuantity,
          other.currentBoxesQuantity,
        );
  }

  @override
  int get hashCode =>
      key.hashCode ^ const _i24.MapEquality().hash(currentBoxesQuantity);
}

/// generated route for
/// [_i13.OfferFoodEditExistingScreen]
class OfferFoodEditExistingRoute
    extends _i19.PageRouteInfo<OfferFoodEditExistingRouteArgs> {
  OfferFoodEditExistingRoute({
    _i20.Key? key,
    required _i25.FoodInfo foodInfo,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          OfferFoodEditExistingRoute.name,
          args: OfferFoodEditExistingRouteArgs(key: key, foodInfo: foodInfo),
          initialChildren: children,
        );

  static const String name = 'OfferFoodEditExistingRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OfferFoodEditExistingRouteArgs>();
      return _i13.OfferFoodEditExistingScreen(
        key: args.key,
        foodInfo: args.foodInfo,
      );
    },
  );
}

class OfferFoodEditExistingRouteArgs {
  const OfferFoodEditExistingRouteArgs({this.key, required this.foodInfo});

  final _i20.Key? key;

  final _i25.FoodInfo foodInfo;

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
/// [_i13.OfferFoodInitialScreen]
class OfferFoodInitialRoute extends _i19.PageRouteInfo<void> {
  const OfferFoodInitialRoute({List<_i19.PageRouteInfo>? children})
      : super(OfferFoodInitialRoute.name, initialChildren: children);

  static const String name = 'OfferFoodInitialRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i13.OfferFoodInitialScreen();
    },
  );
}

/// generated route for
/// [_i15.OfferFoodOverviewScreen]
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

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OfferFoodOverviewRouteArgs>();
      return _i15.OfferFoodOverviewScreen(
        key: args.key,
        initialFoodInfos: args.initialFoodInfos,
      );
    },
  );
}

class OfferFoodOverviewRouteArgs {
  const OfferFoodOverviewRouteArgs({this.key, required this.initialFoodInfos});

  final _i20.Key? key;

  final List<_i25.FoodInfo> initialFoodInfos;

  @override
  String toString() {
    return 'OfferFoodOverviewRouteArgs{key: $key, initialFoodInfos: $initialFoodInfos}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OfferFoodOverviewRouteArgs) return false;
    return key == other.key &&
        const _i24.ListEquality().equals(
          initialFoodInfos,
          other.initialFoodInfos,
        );
  }

  @override
  int get hashCode =>
      key.hashCode ^ const _i24.ListEquality().hash(initialFoodInfos);
}

/// generated route for
/// [_i16.OrderShippingOfBoxesScreen]
class OrderShippingOfBoxesRoute extends _i19.PageRouteInfo<void> {
  const OrderShippingOfBoxesRoute({List<_i19.PageRouteInfo>? children})
      : super(OrderShippingOfBoxesRoute.name, initialChildren: children);

  static const String name = 'OrderShippingOfBoxesRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i16.OrderShippingOfBoxesScreen();
    },
  );
}

/// generated route for
/// [_i17.ProfileScreen]
class ProfileRoute extends _i19.PageRouteInfo<void> {
  const ProfileRoute({List<_i19.PageRouteInfo>? children})
      : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i17.ProfileScreen();
    },
  );
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

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ThankYouRouteArgs>();
      return _i18.ThankYouScreen(
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

  final _i20.Key? key;

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
