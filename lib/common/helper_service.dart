import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/models/user_data.dart';
import 'package:zachranobed/notifiers/delivery_notifier.dart';
import 'package:zachranobed/notifiers/user_notifier.dart';
import 'package:zachranobed/services/auth_service.dart';

class HelperService {
  /// Returns a [UserData] representing the current user's data if available,
  /// otherwise returns `null`.
  static UserData? getCurrentUser(BuildContext context) =>
      context.read<UserNotifier>().user;

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
  static Future<bool> canDonate(BuildContext context) async {
    final user = getCurrentUser(context);
    if (user == null) {
      return false;
    }
    return await context.watch<DeliveryNotifier>().canDonate(user);
  }

  /// Retrieves user information using the [AuthService] and sets the user data
  /// in the [UserNotifier]. If the user has a `canteen` role, it calculates
  /// the date of today's delivery and uses it to fetch the corresponding
  /// delivery object which is then set in the [DeliveryNotifier]. If no
  /// delivery exists for current user or the user doesn't have the `canteen`
  /// role, it creates a dummy delivery.
  static Future<void> loadUserInfo(BuildContext context) async {
    final authService = GetIt.I<AuthService>();
    final userNotifier = context.read<UserNotifier>();
    final deliveryNotifier = context.read<DeliveryNotifier>();

    final user = await authService.getUserData();

    if (context.mounted) {
      userNotifier.user = user;
      if (user != null) {
        deliveryNotifier.init(user);
      }
    }
  }
}
