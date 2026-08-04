// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i27;
import 'package:collection/collection.dart' as _i31;
import 'package:flutter/material.dart' as _i28;
import 'package:zachranobed/app/presentation/home_screen.dart' as _i16;
import 'package:zachranobed/common/domain/model/user_data.dart' as _i32;
import 'package:zachranobed/features/activepair/presentation/change_active_pair_screen.dart'
    as _i4;
import 'package:zachranobed/features/appTerms/presentation/app_terms_screen.dart'
    as _i2;
import 'package:zachranobed/features/debug/components_screen.dart' as _i6;
import 'package:zachranobed/features/debug/debug_screen.dart' as _i8;
import 'package:zachranobed/features/faq/domain/model/faq_item.dart' as _i30;
import 'package:zachranobed/features/faq/presentation/screen/faq_detail_screen.dart'
    as _i10;
import 'package:zachranobed/features/faq/presentation/screen/faq_questions_screen.dart'
    as _i11;
import 'package:zachranobed/features/food/domain/model/box_delivery_confirmation.dart'
    as _i29;
import 'package:zachranobed/features/food/domain/model/food_box_statistics.dart'
    as _i33;
import 'package:zachranobed/features/food/domain/model/food_box_type.dart'
    as _i35;
import 'package:zachranobed/features/food/domain/model/food_info.dart' as _i36;
import 'package:zachranobed/features/food/domain/model/meal_suggestion.dart'
    as _i34;
import 'package:zachranobed/features/food/presentation/screens/add_meals_to_history_screen.dart'
    as _i1;
import 'package:zachranobed/features/food/presentation/screens/box_delivery_confirmation_screen.dart'
    as _i3;
import 'package:zachranobed/features/food/presentation/screens/delivery_detail_screen.dart'
    as _i9;
import 'package:zachranobed/features/food/presentation/screens/food_boxes_checkup_mismatch_screen.dart'
    as _i12;
import 'package:zachranobed/features/food/presentation/screens/food_boxes_detail_screen.dart'
    as _i13;
import 'package:zachranobed/features/food/presentation/screens/meal_suggestion_form_screen.dart'
    as _i18;
import 'package:zachranobed/features/food/presentation/screens/meal_suggestions_list_screen.dart'
    as _i19;
import 'package:zachranobed/features/food/presentation/screens/offer_food_boxes_screen.dart'
    as _i21;
import 'package:zachranobed/features/food/presentation/screens/offer_food_detail_screen.dart'
    as _i20;
import 'package:zachranobed/features/food/presentation/screens/offer_food_overview_screen.dart'
    as _i22;
import 'package:zachranobed/features/food/presentation/screens/order_shipping_of_boxes_screen.dart'
    as _i23;
import 'package:zachranobed/features/food/presentation/screens/thank_you_screen.dart'
    as _i25;
import 'package:zachranobed/features/forceupdate/presentation/force_update_screen.dart'
    as _i14;
import 'package:zachranobed/features/login/presentation/screen/change_password_screen.dart'
    as _i5;
import 'package:zachranobed/features/login/presentation/screen/forgot_password_screen.dart'
    as _i15;
import 'package:zachranobed/features/login/presentation/screen/login_screen.dart'
    as _i17;
import 'package:zachranobed/features/menu/presentation/contacts_screen.dart'
    as _i7;
import 'package:zachranobed/features/menu/presentation/profile_screen.dart'
    as _i24;
import 'package:zachranobed/features/whatsnew/presentation/whats_new_screen.dart'
    as _i26;

/// generated route for
/// [_i1.AddMealsToHistoryScreen]
class AddMealsToHistoryRoute extends _i27.PageRouteInfo<void> {
  const AddMealsToHistoryRoute({List<_i27.PageRouteInfo>? children})
      : super(AddMealsToHistoryRoute.name, initialChildren: children);

  static const String name = 'AddMealsToHistoryRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i1.AddMealsToHistoryScreen();
    },
  );
}

/// generated route for
/// [_i2.AppTermsScreen]
class AppTermsRoute extends _i27.PageRouteInfo<AppTermsRouteArgs> {
  AppTermsRoute({
    _i28.Key? key,
    required bool hasNoAcceptedVersion,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          AppTermsRoute.name,
          args: AppTermsRouteArgs(
            key: key,
            hasNoAcceptedVersion: hasNoAcceptedVersion,
          ),
          initialChildren: children,
        );

  static const String name = 'AppTermsRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AppTermsRouteArgs>();
      return _i2.AppTermsScreen(
        key: args.key,
        hasNoAcceptedVersion: args.hasNoAcceptedVersion,
      );
    },
  );
}

class AppTermsRouteArgs {
  const AppTermsRouteArgs({this.key, required this.hasNoAcceptedVersion});

  final _i28.Key? key;

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
/// [_i3.BoxDeliveryConfirmationScreen]
class BoxDeliveryConfirmationRoute
    extends _i27.PageRouteInfo<BoxDeliveryConfirmationRouteArgs> {
  BoxDeliveryConfirmationRoute({
    _i28.Key? key,
    required _i29.BoxDeliveryConfirmation confirmation,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          BoxDeliveryConfirmationRoute.name,
          args: BoxDeliveryConfirmationRouteArgs(
            key: key,
            confirmation: confirmation,
          ),
          initialChildren: children,
        );

  static const String name = 'BoxDeliveryConfirmationRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BoxDeliveryConfirmationRouteArgs>();
      return _i3.BoxDeliveryConfirmationScreen(
        key: args.key,
        confirmation: args.confirmation,
      );
    },
  );
}

class BoxDeliveryConfirmationRouteArgs {
  const BoxDeliveryConfirmationRouteArgs({
    this.key,
    required this.confirmation,
  });

  final _i28.Key? key;

  final _i29.BoxDeliveryConfirmation confirmation;

  @override
  String toString() {
    return 'BoxDeliveryConfirmationRouteArgs{key: $key, confirmation: $confirmation}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BoxDeliveryConfirmationRouteArgs) return false;
    return key == other.key && confirmation == other.confirmation;
  }

  @override
  int get hashCode => key.hashCode ^ confirmation.hashCode;
}

/// generated route for
/// [_i4.ChangeActivePairScreen]
class ChangeActivePairRoute extends _i27.PageRouteInfo<void> {
  const ChangeActivePairRoute({List<_i27.PageRouteInfo>? children})
      : super(ChangeActivePairRoute.name, initialChildren: children);

  static const String name = 'ChangeActivePairRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i4.ChangeActivePairScreen();
    },
  );
}

/// generated route for
/// [_i5.ChangePasswordScreen]
class ChangePasswordRoute extends _i27.PageRouteInfo<void> {
  const ChangePasswordRoute({List<_i27.PageRouteInfo>? children})
      : super(ChangePasswordRoute.name, initialChildren: children);

  static const String name = 'ChangePasswordRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i5.ChangePasswordScreen();
    },
  );
}

/// generated route for
/// [_i6.ComponentsScreen]
class ComponentsRoute extends _i27.PageRouteInfo<void> {
  const ComponentsRoute({List<_i27.PageRouteInfo>? children})
      : super(ComponentsRoute.name, initialChildren: children);

  static const String name = 'ComponentsRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i6.ComponentsScreen();
    },
  );
}

/// generated route for
/// [_i7.ContactsScreen]
class ContactsRoute extends _i27.PageRouteInfo<void> {
  const ContactsRoute({List<_i27.PageRouteInfo>? children})
      : super(ContactsRoute.name, initialChildren: children);

  static const String name = 'ContactsRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i7.ContactsScreen();
    },
  );
}

/// generated route for
/// [_i8.DebugScreen]
class DebugRoute extends _i27.PageRouteInfo<void> {
  const DebugRoute({List<_i27.PageRouteInfo>? children})
      : super(DebugRoute.name, initialChildren: children);

  static const String name = 'DebugRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i8.DebugScreen();
    },
  );
}

/// generated route for
/// [_i9.DeliveryDetailScreen]
class DeliveryDetailRoute extends _i27.PageRouteInfo<DeliveryDetailRouteArgs> {
  DeliveryDetailRoute({
    _i28.Key? key,
    required String deliveryId,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          DeliveryDetailRoute.name,
          args: DeliveryDetailRouteArgs(key: key, deliveryId: deliveryId),
          initialChildren: children,
        );

  static const String name = 'DeliveryDetailRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DeliveryDetailRouteArgs>();
      return _i9.DeliveryDetailScreen(
        key: args.key,
        deliveryId: args.deliveryId,
      );
    },
  );
}

class DeliveryDetailRouteArgs {
  const DeliveryDetailRouteArgs({this.key, required this.deliveryId});

  final _i28.Key? key;

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
/// [_i10.FaqDetailScreen]
class FaqDetailRoute extends _i27.PageRouteInfo<FaqDetailRouteArgs> {
  FaqDetailRoute({
    _i28.Key? key,
    required _i30.FaqItem item,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          FaqDetailRoute.name,
          args: FaqDetailRouteArgs(key: key, item: item),
          initialChildren: children,
        );

  static const String name = 'FaqDetailRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<FaqDetailRouteArgs>();
      return _i10.FaqDetailScreen(key: args.key, item: args.item);
    },
  );
}

class FaqDetailRouteArgs {
  const FaqDetailRouteArgs({this.key, required this.item});

  final _i28.Key? key;

  final _i30.FaqItem item;

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
/// [_i11.FaqQuestionsScreen]
class FaqQuestionsRoute extends _i27.PageRouteInfo<FaqQuestionsRouteArgs> {
  FaqQuestionsRoute({
    _i28.Key? key,
    required List<_i30.FaqItem> items,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          FaqQuestionsRoute.name,
          args: FaqQuestionsRouteArgs(key: key, items: items),
          initialChildren: children,
        );

  static const String name = 'FaqQuestionsRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<FaqQuestionsRouteArgs>();
      return _i11.FaqQuestionsScreen(key: args.key, items: args.items);
    },
  );
}

class FaqQuestionsRouteArgs {
  const FaqQuestionsRouteArgs({this.key, required this.items});

  final _i28.Key? key;

  final List<_i30.FaqItem> items;

  @override
  String toString() {
    return 'FaqQuestionsRouteArgs{key: $key, items: $items}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FaqQuestionsRouteArgs) return false;
    return key == other.key &&
        const _i31.ListEquality().equals(items, other.items);
  }

  @override
  int get hashCode => key.hashCode ^ const _i31.ListEquality().hash(items);
}

/// generated route for
/// [_i12.FoodBoxesCheckupMismatchScreen]
class FoodBoxesCheckupMismatchRoute
    extends _i27.PageRouteInfo<FoodBoxesCheckupMismatchRouteArgs> {
  FoodBoxesCheckupMismatchRoute({
    _i28.Key? key,
    required _i32.UserData user,
    required List<_i33.FoodBoxStatistics> statistics,
    List<_i27.PageRouteInfo>? children,
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

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<FoodBoxesCheckupMismatchRouteArgs>();
      return _i12.FoodBoxesCheckupMismatchScreen(
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

  final _i28.Key? key;

  final _i32.UserData user;

  final List<_i33.FoodBoxStatistics> statistics;

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
        const _i31.ListEquality().equals(statistics, other.statistics);
  }

  @override
  int get hashCode =>
      key.hashCode ^ user.hashCode ^ const _i31.ListEquality().hash(statistics);
}

/// generated route for
/// [_i13.FoodBoxesDetailScreen]
class FoodBoxesDetailRoute
    extends _i27.PageRouteInfo<FoodBoxesDetailRouteArgs> {
  FoodBoxesDetailRoute({
    _i28.Key? key,
    required _i32.UserData user,
    bool isCheckupMode = false,
    List<_i27.PageRouteInfo>? children,
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

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<FoodBoxesDetailRouteArgs>();
      return _i13.FoodBoxesDetailScreen(
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

  final _i28.Key? key;

  final _i32.UserData user;

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
/// [_i14.ForceUpdateScreen]
class ForceUpdateRoute extends _i27.PageRouteInfo<void> {
  const ForceUpdateRoute({List<_i27.PageRouteInfo>? children})
      : super(ForceUpdateRoute.name, initialChildren: children);

  static const String name = 'ForceUpdateRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i14.ForceUpdateScreen();
    },
  );
}

/// generated route for
/// [_i15.ForgotPasswordScreen]
class ForgotPasswordRoute extends _i27.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i27.PageRouteInfo>? children})
      : super(ForgotPasswordRoute.name, initialChildren: children);

  static const String name = 'ForgotPasswordRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i15.ForgotPasswordScreen();
    },
  );
}

/// generated route for
/// [_i16.HomeScreen]
class HomeRoute extends _i27.PageRouteInfo<HomeRouteArgs> {
  HomeRoute({
    _i28.Key? key,
    int initialTabIndex = 0,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          HomeRoute.name,
          args: HomeRouteArgs(key: key, initialTabIndex: initialTabIndex),
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<HomeRouteArgs>(
        orElse: () => const HomeRouteArgs(),
      );
      return _i16.HomeScreen(
        key: args.key,
        initialTabIndex: args.initialTabIndex,
      );
    },
  );
}

class HomeRouteArgs {
  const HomeRouteArgs({this.key, this.initialTabIndex = 0});

  final _i28.Key? key;

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
/// [_i17.LoginScreen]
class LoginRoute extends _i27.PageRouteInfo<void> {
  const LoginRoute({List<_i27.PageRouteInfo>? children})
      : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i17.LoginScreen();
    },
  );
}

/// generated route for
/// [_i18.MealSuggestionAddScreen]
class MealSuggestionAddRoute extends _i27.PageRouteInfo<void> {
  const MealSuggestionAddRoute({List<_i27.PageRouteInfo>? children})
      : super(MealSuggestionAddRoute.name, initialChildren: children);

  static const String name = 'MealSuggestionAddRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i18.MealSuggestionAddScreen();
    },
  );
}

/// generated route for
/// [_i18.MealSuggestionEditScreen]
class MealSuggestionEditRoute
    extends _i27.PageRouteInfo<MealSuggestionEditRouteArgs> {
  MealSuggestionEditRoute({
    _i28.Key? key,
    required _i34.MealSuggestion suggestion,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          MealSuggestionEditRoute.name,
          args: MealSuggestionEditRouteArgs(key: key, suggestion: suggestion),
          initialChildren: children,
        );

  static const String name = 'MealSuggestionEditRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MealSuggestionEditRouteArgs>();
      return _i18.MealSuggestionEditScreen(
        key: args.key,
        suggestion: args.suggestion,
      );
    },
  );
}

class MealSuggestionEditRouteArgs {
  const MealSuggestionEditRouteArgs({this.key, required this.suggestion});

  final _i28.Key? key;

  final _i34.MealSuggestion suggestion;

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
/// [_i19.MealSuggestionsListScreen]
class MealSuggestionsListRoute extends _i27.PageRouteInfo<void> {
  const MealSuggestionsListRoute({List<_i27.PageRouteInfo>? children})
      : super(MealSuggestionsListRoute.name, initialChildren: children);

  static const String name = 'MealSuggestionsListRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i19.MealSuggestionsListScreen();
    },
  );
}

/// generated route for
/// [_i20.OfferFoodAddNewScreen]
class OfferFoodAddNewRoute extends _i27.PageRouteInfo<void> {
  const OfferFoodAddNewRoute({List<_i27.PageRouteInfo>? children})
      : super(OfferFoodAddNewRoute.name, initialChildren: children);

  static const String name = 'OfferFoodAddNewRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i20.OfferFoodAddNewScreen();
    },
  );
}

/// generated route for
/// [_i21.OfferFoodBoxesScreen]
class OfferFoodBoxesRoute extends _i27.PageRouteInfo<OfferFoodBoxesRouteArgs> {
  OfferFoodBoxesRoute({
    _i28.Key? key,
    required Map<_i35.FoodBoxType, int> currentBoxesQuantity,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          OfferFoodBoxesRoute.name,
          args: OfferFoodBoxesRouteArgs(
            key: key,
            currentBoxesQuantity: currentBoxesQuantity,
          ),
          initialChildren: children,
        );

  static const String name = 'OfferFoodBoxesRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OfferFoodBoxesRouteArgs>();
      return _i21.OfferFoodBoxesScreen(
        key: args.key,
        currentBoxesQuantity: args.currentBoxesQuantity,
      );
    },
  );
}

class OfferFoodBoxesRouteArgs {
  const OfferFoodBoxesRouteArgs({this.key, required this.currentBoxesQuantity});

  final _i28.Key? key;

  final Map<_i35.FoodBoxType, int> currentBoxesQuantity;

  @override
  String toString() {
    return 'OfferFoodBoxesRouteArgs{key: $key, currentBoxesQuantity: $currentBoxesQuantity}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OfferFoodBoxesRouteArgs) return false;
    return key == other.key &&
        const _i31.MapEquality().equals(
          currentBoxesQuantity,
          other.currentBoxesQuantity,
        );
  }

  @override
  int get hashCode =>
      key.hashCode ^ const _i31.MapEquality().hash(currentBoxesQuantity);
}

/// generated route for
/// [_i20.OfferFoodEditExistingScreen]
class OfferFoodEditExistingRoute
    extends _i27.PageRouteInfo<OfferFoodEditExistingRouteArgs> {
  OfferFoodEditExistingRoute({
    _i28.Key? key,
    required _i36.FoodInfo foodInfo,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          OfferFoodEditExistingRoute.name,
          args: OfferFoodEditExistingRouteArgs(key: key, foodInfo: foodInfo),
          initialChildren: children,
        );

  static const String name = 'OfferFoodEditExistingRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OfferFoodEditExistingRouteArgs>();
      return _i20.OfferFoodEditExistingScreen(
        key: args.key,
        foodInfo: args.foodInfo,
      );
    },
  );
}

class OfferFoodEditExistingRouteArgs {
  const OfferFoodEditExistingRouteArgs({this.key, required this.foodInfo});

  final _i28.Key? key;

  final _i36.FoodInfo foodInfo;

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
/// [_i20.OfferFoodInitialScreen]
class OfferFoodInitialRoute extends _i27.PageRouteInfo<void> {
  const OfferFoodInitialRoute({List<_i27.PageRouteInfo>? children})
      : super(OfferFoodInitialRoute.name, initialChildren: children);

  static const String name = 'OfferFoodInitialRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i20.OfferFoodInitialScreen();
    },
  );
}

/// generated route for
/// [_i22.OfferFoodOverviewScreen]
class OfferFoodOverviewRoute
    extends _i27.PageRouteInfo<OfferFoodOverviewRouteArgs> {
  OfferFoodOverviewRoute({
    _i28.Key? key,
    required List<_i36.FoodInfo> initialFoodInfos,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          OfferFoodOverviewRoute.name,
          args: OfferFoodOverviewRouteArgs(
            key: key,
            initialFoodInfos: initialFoodInfos,
          ),
          initialChildren: children,
        );

  static const String name = 'OfferFoodOverviewRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OfferFoodOverviewRouteArgs>();
      return _i22.OfferFoodOverviewScreen(
        key: args.key,
        initialFoodInfos: args.initialFoodInfos,
      );
    },
  );
}

class OfferFoodOverviewRouteArgs {
  const OfferFoodOverviewRouteArgs({this.key, required this.initialFoodInfos});

  final _i28.Key? key;

  final List<_i36.FoodInfo> initialFoodInfos;

  @override
  String toString() {
    return 'OfferFoodOverviewRouteArgs{key: $key, initialFoodInfos: $initialFoodInfos}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OfferFoodOverviewRouteArgs) return false;
    return key == other.key &&
        const _i31.ListEquality().equals(
          initialFoodInfos,
          other.initialFoodInfos,
        );
  }

  @override
  int get hashCode =>
      key.hashCode ^ const _i31.ListEquality().hash(initialFoodInfos);
}

/// generated route for
/// [_i23.OrderShippingOfBoxesScreen]
class OrderShippingOfBoxesRoute extends _i27.PageRouteInfo<void> {
  const OrderShippingOfBoxesRoute({List<_i27.PageRouteInfo>? children})
      : super(OrderShippingOfBoxesRoute.name, initialChildren: children);

  static const String name = 'OrderShippingOfBoxesRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i23.OrderShippingOfBoxesScreen();
    },
  );
}

/// generated route for
/// [_i24.ProfileScreen]
class ProfileRoute extends _i27.PageRouteInfo<void> {
  const ProfileRoute({List<_i27.PageRouteInfo>? children})
      : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i24.ProfileScreen();
    },
  );
}

/// generated route for
/// [_i25.ThankYouScreen]
class ThankYouRoute extends _i27.PageRouteInfo<ThankYouRouteArgs> {
  ThankYouRoute({
    _i28.Key? key,
    required bool isSuccess,
    required String message,
    List<_i27.PageRouteInfo>? children,
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

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ThankYouRouteArgs>();
      return _i25.ThankYouScreen(
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

  final _i28.Key? key;

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
/// [_i26.WhatsNewScreen]
class WhatsNewRoute extends _i27.PageRouteInfo<void> {
  const WhatsNewRoute({List<_i27.PageRouteInfo>? children})
      : super(WhatsNewRoute.name, initialChildren: children);

  static const String name = 'WhatsNewRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i26.WhatsNewScreen();
    },
  );
}
