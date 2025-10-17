import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/common/domain/model/entity_pair.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/domain/usecase/get_user_data_usecase.dart';
import 'package:zachranobed/common/presentation/notifiers/delivery_notifier.dart';
import 'package:zachranobed/common/presentation/notifiers/user_notifier.dart';

class HelperService {
  /// Returns a [UserData] representing the current user's data if available,
  /// otherwise returns `null`.
  static UserData? getCurrentUser(BuildContext context) =>
      context.read<UserNotifier>().user;

  /// Watches a [UserData] representing the current user's data if available,
  /// otherwise returns `null`.
  static UserData? watchCurrentUser(BuildContext context) =>
      context.watch<UserNotifier>().user;

  /// Returns an [int] indicating the current week number of the year.
  static int get getCurrentWeekNumber {
    final now = DateTime.now();
    final from = DateTime(now.year, 1, 1);
    final to = DateTime(now.year, now.month, now.day);
    return (to.difference(from).inDays / 7).ceil();
  }

  /// Checks if the current user is a canteen and evaluates additional
  /// conditions such as whether the delivery is confirmed or cancelled, and
  /// whether the current time falls within a certain window in which the user
  /// can donate food.
  ///
  /// Returns a [bool] indicating whether the current user is eligible to
  /// donate food.
  static bool canDonate(BuildContext context) {
    final user = watchCurrentUser(context);
    if (user == null) {
      return false;
    }
    return context.watch<DeliveryNotifier>().canDonate(user);
  }

  /// Retrieves user information using the [GetUserDataUseCase] and sets the user data
  /// in the [UserNotifier]. If the user has a `canteen` role, it calculates
  /// the date of today's delivery and uses it to fetch the corresponding
  /// delivery object which is then set in the [DeliveryNotifier]. If no
  /// delivery exists for current user or the user doesn't have the `canteen`
  /// role, it creates a dummy delivery.
  static Future<void> loadUserInfo(BuildContext context) async {
    final getUserData = GetIt.I<GetUserDataUseCase>();
    final userNotifier = context.read<UserNotifier>();
    final deliveryNotifier = context.read<DeliveryNotifier>();

    final user = await getUserData.invoke();

    if (context.mounted) {
      userNotifier.user = user;
      if (user != null) {
        deliveryNotifier.init(user);
      }
    }
  }

  /// Updates the active pair for the current user.
  ///
  /// Retrieves the current user from the context, updates their active pair
  /// with the provided [pair], and updates the [UserNotifier] with the modified
  /// user object.
  static void updateActivePair(BuildContext context, EntityPair pair) {
    final user = getCurrentUser(context);
    if (user == null) {
      return;
    }

    final userNotifier = context.read<UserNotifier>();
    final deliveryNotifier = context.read<DeliveryNotifier>();
    if (context.mounted) {
      final updatedUser = user.copyWith(activePair: pair);
      userNotifier.user = updatedUser;
      deliveryNotifier.init(updatedUser);
    }
  }
}
