// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i25;
import 'package:collection/collection.dart' as _i28;
import 'package:flutter/material.dart' as _i26;
import 'package:zachranobed/app/presentation/home_screen.dart' as _i14;
import 'package:zachranobed/common/domain/model/user_data.dart' as _i29;
import 'package:zachranobed/features/activepair/presentation/change_active_pair_screen.dart'
    as _i2;
import 'package:zachranobed/features/appTerms/presentation/app_terms_screen.dart'
    as _i1;
import 'package:zachranobed/features/debug/components_screen.dart' as _i4;
import 'package:zachranobed/features/debug/debug_screen.dart' as _i6;
import 'package:zachranobed/features/faq/domain/model/faq_item.dart' as _i27;
import 'package:zachranobed/features/faq/presentation/screen/faq_detail_screen.dart'
    as _i8;
import 'package:zachranobed/features/faq/presentation/screen/faq_questions_screen.dart'
    as _i9;
import 'package:zachranobed/features/food/domain/model/food_box_statistics.dart'
    as _i30;
import 'package:zachranobed/features/food/domain/model/food_box_type.dart'
    as _i32;
import 'package:zachranobed/features/food/domain/model/food_info.dart' as _i33;
import 'package:zachranobed/features/food/domain/model/meal_suggestion.dart'
    as _i31;
import 'package:zachranobed/features/food/presentation/screens/delivery_detail_screen.dart'
    as _i7;
import 'package:zachranobed/features/food/presentation/screens/food_boxes_checkup_mismatch_screen.dart'
    as _i10;
import 'package:zachranobed/features/food/presentation/screens/food_boxes_detail_screen.dart'
    as _i11;
import 'package:zachranobed/features/food/presentation/screens/meal_suggestion_form_screen.dart'
    as _i16;
import 'package:zachranobed/features/food/presentation/screens/meal_suggestions_list_screen.dart'
    as _i17;
import 'package:zachranobed/features/food/presentation/screens/offer_food_boxes_screen.dart'
    as _i19;
import 'package:zachranobed/features/food/presentation/screens/offer_food_detail_screen.dart'
    as _i18;
import 'package:zachranobed/features/food/presentation/screens/offer_food_overview_screen.dart'
    as _i20;
import 'package:zachranobed/features/food/presentation/screens/order_shipping_of_boxes_screen.dart'
    as _i21;
import 'package:zachranobed/features/food/presentation/screens/thank_you_screen.dart'
    as _i23;
import 'package:zachranobed/features/forceupdate/presentation/force_update_screen.dart'
    as _i12;
import 'package:zachranobed/features/login/presentation/screen/change_password_screen.dart'
    as _i3;
import 'package:zachranobed/features/login/presentation/screen/forgot_password_screen.dart'
    as _i13;
import 'package:zachranobed/features/login/presentation/screen/login_screen.dart'
    as _i15;
import 'package:zachranobed/features/menu/presentation/contacts_screen.dart'
    as _i5;
import 'package:zachranobed/features/menu/presentation/profile_screen.dart'
    as _i22;
import 'package:zachranobed/features/whatsnew/presentation/whats_new_screen.dart'
    as _i24;

/// generated route for
/// [_i1.AppTermsScreen]
class AppTermsRoute extends _i25.PageRouteInfo<AppTermsRouteArgs> {
  AppTermsRoute({
    _i26.Key? key,
    required bool hasNoAcceptedVersion,
    List<_i25.PageRouteInfo>? children,
  }) : super(
          AppTermsRoute.name,
          args: AppTermsRouteArgs(
            key: key,
            hasNoAcceptedVersion: hasNoAcceptedVersion,
          ),
          initialChildren: children,
        );

  static const String name = 'AppTermsRoute';

  static _i25.PageInfo page = _i25.PageInfo(
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

  final _i26.Key? key;

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
class ChangeActivePairRoute extends _i25.PageRouteInfo<void> {
  const ChangeActivePairRoute({List<_i25.PageRouteInfo>? children})
      : super(ChangeActivePairRoute.name, initialChildren: children);

  static const String name = 'ChangeActivePairRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i2.ChangeActivePairScreen();
    },
  );
}

/// generated route for
/// [_i3.ChangePasswordScreen]
class ChangePasswordRoute extends _i25.PageRouteInfo<void> {
  const ChangePasswordRoute({List<_i25.PageRouteInfo>? children})
      : super(ChangePasswordRoute.name, initialChildren: children);

  static const String name = 'ChangePasswordRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i3.ChangePasswordScreen();
    },
  );
}

/// generated route for
/// [_i4.ComponentsScreen]
class ComponentsRoute extends _i25.PageRouteInfo<void> {
  const ComponentsRoute({List<_i25.PageRouteInfo>? children})
      : super(ComponentsRoute.name, initialChildren: children);

  static const String name = 'ComponentsRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i4.ComponentsScreen();
    },
  );
}

/// generated route for
/// [_i5.ContactsScreen]
class ContactsRoute extends _i25.PageRouteInfo<void> {
  const ContactsRoute({List<_i25.PageRouteInfo>? children})
      : super(ContactsRoute.name, initialChildren: children);

  static const String name = 'ContactsRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i5.ContactsScreen();
    },
  );
}

/// generated route for
/// [_i6.DebugScreen]
class DebugRoute extends _i25.PageRouteInfo<void> {
  const DebugRoute({List<_i25.PageRouteInfo>? children})
      : super(DebugRoute.name, initialChildren: children);

  static const String name = 'DebugRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i6.DebugScreen();
    },
  );
}

/// generated route for
/// [_i7.DeliveryDetailScreen]
class DeliveryDetailRoute extends _i25.PageRouteInfo<DeliveryDetailRouteArgs> {
  DeliveryDetailRoute({
    _i26.Key? key,
    required String deliveryId,
    List<_i25.PageRouteInfo>? children,
  }) : super(
          DeliveryDetailRoute.name,
          args: DeliveryDetailRouteArgs(key: key, deliveryId: deliveryId),
          initialChildren: children,
        );

  static const String name = 'DeliveryDetailRoute';

  static _i25.PageInfo page = _i25.PageInfo(
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

  final _i26.Key? key;

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
/// [_i8.FaqDetailScreen]
class FaqDetailRoute extends _i25.PageRouteInfo<FaqDetailRouteArgs> {
  FaqDetailRoute({
    _i26.Key? key,
    required _i27.FaqItem item,
    List<_i25.PageRouteInfo>? children,
  }) : super(
          FaqDetailRoute.name,
          args: FaqDetailRouteArgs(key: key, item: item),
          initialChildren: children,
        );

  static const String name = 'FaqDetailRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<FaqDetailRouteArgs>();
      return _i8.FaqDetailScreen(key: args.key, item: args.item);
    },
  );
}

class FaqDetailRouteArgs {
  const FaqDetailRouteArgs({this.key, required this.item});

  final _i26.Key? key;

  final _i27.FaqItem item;

  @override
  String toString() {
    return 'FaqDetailRouteArgs{key: $key, item: $item}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FaqDetailRouteArgs) return false;
    return key == other.key && item == other.item;
  }

  @override
  int get hashCode => key.hashCode ^ item.hashCode;
}

/// generated route for
/// [_i9.FaqQuestionsScreen]
class FaqQuestionsRoute extends _i25.PageRouteInfo<FaqQuestionsRouteArgs> {
  FaqQuestionsRoute({
    _i26.Key? key,
    required List<_i27.FaqItem> items,
    List<_i25.PageRouteInfo>? children,
  }) : super(
          FaqQuestionsRoute.name,
          args: FaqQuestionsRouteArgs(key: key, items: items),
          initialChildren: children,
        );

  static const String name = 'FaqQuestionsRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<FaqQuestionsRouteArgs>();
      return _i9.FaqQuestionsScreen(key: args.key, items: args.items);
    },
  );
}

class FaqQuestionsRouteArgs {
  const FaqQuestionsRouteArgs({this.key, required this.items});

  final _i26.Key? key;

  final List<_i27.FaqItem> items;

  @override
  String toString() {
    return 'FaqQuestionsRouteArgs{key: $key, items: $items}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FaqQuestionsRouteArgs) return false;
    return key == other.key &&
        const _i28.ListEquality().equals(items, other.items);
  }

  @override
  int get hashCode => key.hashCode ^ const _i28.ListEquality().hash(items);
}

/// generated route for
/// [_i10.FoodBoxesCheckupMismatchScreen]
class FoodBoxesCheckupMismatchRoute
    extends _i25.PageRouteInfo<FoodBoxesCheckupMismatchRouteArgs> {
  FoodBoxesCheckupMismatchRoute({
    _i26.Key? key,
    required _i29.UserData user,
    required List<_i30.FoodBoxStatistics> statistics,
    List<_i25.PageRouteInfo>? children,
  }) : super(
          FoodBoxesCheckupMismatchRoute.name,
          args: FoodBoxesCheckupMismatchRouteArgs(
            key: key,
            user: user,
            statistics: statistics,
          ),
          initialChildren: children,
        );

  static const String name = 'FoodBoxesCheckupMismatchRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<FoodBoxesCheckupMismatchRouteArgs>();
      return _i10.FoodBoxesCheckupMismatchScreen(
        key: args.key,
        user: args.user,
        statistics: args.statistics,
      );
    },
  );
}

class FoodBoxesCheckupMismatchRouteArgs {
  const FoodBoxesCheckupMismatchRouteArgs({
    this.key,
    required this.user,
    required this.statistics,
  });

  final _i26.Key? key;

  final _i29.UserData user;

  final List<_i30.FoodBoxStatistics> statistics;

  @override
  String toString() {
    return 'FoodBoxesCheckupMismatchRouteArgs{key: $key, user: $user, statistics: $statistics}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FoodBoxesCheckupMismatchRouteArgs) return false;
    return key == other.key &&
        user == other.user &&
        const _i28.ListEquality().equals(statistics, other.statistics);
  }

  @override
  int get hashCode =>
      key.hashCode ^ user.hashCode ^ const _i28.ListEquality().hash(statistics);
}

/// generated route for
/// [_i11.FoodBoxesDetailScreen]
class FoodBoxesDetailRoute
    extends _i25.PageRouteInfo<FoodBoxesDetailRouteArgs> {
  FoodBoxesDetailRoute({
    _i26.Key? key,
    required _i29.UserData user,
    bool isCheckupMode = false,
    List<_i25.PageRouteInfo>? children,
  }) : super(
          FoodBoxesDetailRoute.name,
          args: FoodBoxesDetailRouteArgs(
            key: key,
            user: user,
            isCheckupMode: isCheckupMode,
          ),
          initialChildren: children,
        );

  static const String name = 'FoodBoxesDetailRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<FoodBoxesDetailRouteArgs>();
      return _i11.FoodBoxesDetailScreen(
        key: args.key,
        user: args.user,
        isCheckupMode: args.isCheckupMode,
      );
    },
  );
}

class FoodBoxesDetailRouteArgs {
  const FoodBoxesDetailRouteArgs({
    this.key,
    required this.user,
    this.isCheckupMode = false,
  });

  final _i26.Key? key;

  final _i29.UserData user;

  final bool isCheckupMode;

  @override
  String toString() {
    return 'FoodBoxesDetailRouteArgs{key: $key, user: $user, isCheckupMode: $isCheckupMode}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FoodBoxesDetailRouteArgs) return false;
    return key == other.key &&
        user == other.user &&
        isCheckupMode == other.isCheckupMode;
  }

  @override
  int get hashCode => key.hashCode ^ user.hashCode ^ isCheckupMode.hashCode;
}

/// generated route for
/// [_i12.ForceUpdateScreen]
class ForceUpdateRoute extends _i25.PageRouteInfo<void> {
  const ForceUpdateRoute({List<_i25.PageRouteInfo>? children})
      : super(ForceUpdateRoute.name, initialChildren: children);

  static const String name = 'ForceUpdateRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i12.ForceUpdateScreen();
    },
  );
}

/// generated route for
/// [_i13.ForgotPasswordScreen]
class ForgotPasswordRoute extends _i25.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i25.PageRouteInfo>? children})
      : super(ForgotPasswordRoute.name, initialChildren: children);

  static const String name = 'ForgotPasswordRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i13.ForgotPasswordScreen();
    },
  );
}

/// generated route for
/// [_i14.HomeScreen]
class HomeRoute extends _i25.PageRouteInfo<HomeRouteArgs> {
  HomeRoute({
    _i26.Key? key,
    int initialTabIndex = 0,
    List<_i25.PageRouteInfo>? children,
  }) : super(
          HomeRoute.name,
          args: HomeRouteArgs(key: key, initialTabIndex: initialTabIndex),
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<HomeRouteArgs>(
        orElse: () => const HomeRouteArgs(),
      );
      return _i14.HomeScreen(
        key: args.key,
        initialTabIndex: args.initialTabIndex,
      );
    },
  );
}

class HomeRouteArgs {
  const HomeRouteArgs({this.key, this.initialTabIndex = 0});

  final _i26.Key? key;

  final int initialTabIndex;

  @override
  String toString() {
    return 'HomeRouteArgs{key: $key, initialTabIndex: $initialTabIndex}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! HomeRouteArgs) return false;
    return key == other.key && initialTabIndex == other.initialTabIndex;
  }

  @override
  int get hashCode => key.hashCode ^ initialTabIndex.hashCode;
}

/// generated route for
/// [_i15.LoginScreen]
class LoginRoute extends _i25.PageRouteInfo<void> {
  const LoginRoute({List<_i25.PageRouteInfo>? children})
      : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i15.LoginScreen();
    },
  );
}

/// generated route for
/// [_i16.MealSuggestionAddScreen]
class MealSuggestionAddRoute extends _i25.PageRouteInfo<void> {
  const MealSuggestionAddRoute({List<_i25.PageRouteInfo>? children})
      : super(MealSuggestionAddRoute.name, initialChildren: children);

  static const String name = 'MealSuggestionAddRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i16.MealSuggestionAddScreen();
    },
  );
}

/// generated route for
/// [_i16.MealSuggestionEditScreen]
class MealSuggestionEditRoute
    extends _i25.PageRouteInfo<MealSuggestionEditRouteArgs> {
  MealSuggestionEditRoute({
    _i26.Key? key,
    required _i31.MealSuggestion suggestion,
    List<_i25.PageRouteInfo>? children,
  }) : super(
          MealSuggestionEditRoute.name,
          args: MealSuggestionEditRouteArgs(key: key, suggestion: suggestion),
          initialChildren: children,
        );

  static const String name = 'MealSuggestionEditRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MealSuggestionEditRouteArgs>();
      return _i16.MealSuggestionEditScreen(
        key: args.key,
        suggestion: args.suggestion,
      );
    },
  );
}

class MealSuggestionEditRouteArgs {
  const MealSuggestionEditRouteArgs({this.key, required this.suggestion});

  final _i26.Key? key;

  final _i31.MealSuggestion suggestion;

  @override
  String toString() {
    return 'MealSuggestionEditRouteArgs{key: $key, suggestion: $suggestion}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MealSuggestionEditRouteArgs) return false;
    return key == other.key && suggestion == other.suggestion;
  }

  @override
  int get hashCode => key.hashCode ^ suggestion.hashCode;
}

/// generated route for
/// [_i17.MealSuggestionsListScreen]
class MealSuggestionsListRoute extends _i25.PageRouteInfo<void> {
  const MealSuggestionsListRoute({List<_i25.PageRouteInfo>? children})
      : super(MealSuggestionsListRoute.name, initialChildren: children);

  static const String name = 'MealSuggestionsListRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i17.MealSuggestionsListScreen();
    },
  );
}

/// generated route for
/// [_i18.OfferFoodAddNewScreen]
class OfferFoodAddNewRoute extends _i25.PageRouteInfo<void> {
  const OfferFoodAddNewRoute({List<_i25.PageRouteInfo>? children})
      : super(OfferFoodAddNewRoute.name, initialChildren: children);

  static const String name = 'OfferFoodAddNewRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i18.OfferFoodAddNewScreen();
    },
  );
}

/// generated route for
/// [_i19.OfferFoodBoxesScreen]
class OfferFoodBoxesRoute extends _i25.PageRouteInfo<OfferFoodBoxesRouteArgs> {
  OfferFoodBoxesRoute({
    _i26.Key? key,
    required Map<_i32.FoodBoxType, int> currentBoxesQuantity,
    List<_i25.PageRouteInfo>? children,
  }) : super(
          OfferFoodBoxesRoute.name,
          args: OfferFoodBoxesRouteArgs(
            key: key,
            currentBoxesQuantity: currentBoxesQuantity,
          ),
          initialChildren: children,
        );

  static const String name = 'OfferFoodBoxesRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OfferFoodBoxesRouteArgs>();
      return _i19.OfferFoodBoxesScreen(
        key: args.key,
        currentBoxesQuantity: args.currentBoxesQuantity,
      );
    },
  );
}

class OfferFoodBoxesRouteArgs {
  const OfferFoodBoxesRouteArgs({this.key, required this.currentBoxesQuantity});

  final _i26.Key? key;

  final Map<_i32.FoodBoxType, int> currentBoxesQuantity;

  @override
  String toString() {
    return 'OfferFoodBoxesRouteArgs{key: $key, currentBoxesQuantity: $currentBoxesQuantity}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OfferFoodBoxesRouteArgs) return false;
    return key == other.key &&
        const _i28.MapEquality().equals(
          currentBoxesQuantity,
          other.currentBoxesQuantity,
        );
  }

  @override
  int get hashCode =>
      key.hashCode ^ const _i28.MapEquality().hash(currentBoxesQuantity);
}

/// generated route for
/// [_i18.OfferFoodEditExistingScreen]
class OfferFoodEditExistingRoute
    extends _i25.PageRouteInfo<OfferFoodEditExistingRouteArgs> {
  OfferFoodEditExistingRoute({
    _i26.Key? key,
    required _i33.FoodInfo foodInfo,
    List<_i25.PageRouteInfo>? children,
  }) : super(
          OfferFoodEditExistingRoute.name,
          args: OfferFoodEditExistingRouteArgs(key: key, foodInfo: foodInfo),
          initialChildren: children,
        );

  static const String name = 'OfferFoodEditExistingRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OfferFoodEditExistingRouteArgs>();
      return _i18.OfferFoodEditExistingScreen(
        key: args.key,
        foodInfo: args.foodInfo,
      );
    },
  );
}

class OfferFoodEditExistingRouteArgs {
  const OfferFoodEditExistingRouteArgs({this.key, required this.foodInfo});

  final _i26.Key? key;

  final _i33.FoodInfo foodInfo;

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
/// [_i18.OfferFoodInitialScreen]
class OfferFoodInitialRoute extends _i25.PageRouteInfo<void> {
  const OfferFoodInitialRoute({List<_i25.PageRouteInfo>? children})
      : super(OfferFoodInitialRoute.name, initialChildren: children);

  static const String name = 'OfferFoodInitialRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i18.OfferFoodInitialScreen();
    },
  );
}

/// generated route for
/// [_i20.OfferFoodOverviewScreen]
class OfferFoodOverviewRoute
    extends _i25.PageRouteInfo<OfferFoodOverviewRouteArgs> {
  OfferFoodOverviewRoute({
    _i26.Key? key,
    required List<_i33.FoodInfo> initialFoodInfos,
    List<_i25.PageRouteInfo>? children,
  }) : super(
          OfferFoodOverviewRoute.name,
          args: OfferFoodOverviewRouteArgs(
            key: key,
            initialFoodInfos: initialFoodInfos,
          ),
          initialChildren: children,
        );

  static const String name = 'OfferFoodOverviewRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OfferFoodOverviewRouteArgs>();
      return _i20.OfferFoodOverviewScreen(
        key: args.key,
        initialFoodInfos: args.initialFoodInfos,
      );
    },
  );
}

class OfferFoodOverviewRouteArgs {
  const OfferFoodOverviewRouteArgs({this.key, required this.initialFoodInfos});

  final _i26.Key? key;

  final List<_i33.FoodInfo> initialFoodInfos;

  @override
  String toString() {
    return 'OfferFoodOverviewRouteArgs{key: $key, initialFoodInfos: $initialFoodInfos}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OfferFoodOverviewRouteArgs) return false;
    return key == other.key &&
        const _i28.ListEquality().equals(
          initialFoodInfos,
          other.initialFoodInfos,
        );
  }

  @override
  int get hashCode =>
      key.hashCode ^ const _i28.ListEquality().hash(initialFoodInfos);
}

/// generated route for
/// [_i21.OrderShippingOfBoxesScreen]
class OrderShippingOfBoxesRoute extends _i25.PageRouteInfo<void> {
  const OrderShippingOfBoxesRoute({List<_i25.PageRouteInfo>? children})
      : super(OrderShippingOfBoxesRoute.name, initialChildren: children);

  static const String name = 'OrderShippingOfBoxesRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i21.OrderShippingOfBoxesScreen();
    },
  );
}

/// generated route for
/// [_i22.ProfileScreen]
class ProfileRoute extends _i25.PageRouteInfo<void> {
  const ProfileRoute({List<_i25.PageRouteInfo>? children})
      : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i22.ProfileScreen();
    },
  );
}

/// generated route for
/// [_i23.ThankYouScreen]
class ThankYouRoute extends _i25.PageRouteInfo<ThankYouRouteArgs> {
  ThankYouRoute({
    _i26.Key? key,
    required bool isSuccess,
    required String message,
    List<_i25.PageRouteInfo>? children,
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

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ThankYouRouteArgs>();
      return _i23.ThankYouScreen(
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

  final _i26.Key? key;

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

/// generated route for
/// [_i24.WhatsNewScreen]
class WhatsNewRoute extends _i25.PageRouteInfo<void> {
  const WhatsNewRoute({List<_i25.PageRouteInfo>? children})
      : super(WhatsNewRoute.name, initialChildren: children);

  static const String name = 'WhatsNewRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i24.WhatsNewScreen();
    },
  );
}
