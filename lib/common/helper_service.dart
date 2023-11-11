import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/enums/delivery_state.dart';
import 'package:zachranobed/models/canteen.dart';
import 'package:zachranobed/models/delivery.dart';
import 'package:zachranobed/models/user_data.dart';
import 'package:zachranobed/notifiers/delivery_notifier.dart';
import 'package:zachranobed/notifiers/user_notifier.dart';
import 'package:zachranobed/services/auth_service.dart';
import 'package:zachranobed/services/delivery_service.dart';

class HelperService {
  static UserData? getCurrentUser(BuildContext context) =>
      context.read<UserNotifier>().user;

  /// Returns an [int] indicating the current week number of the year.
  static int get getCurrentWeekNumber {
    final now = DateTime.now();
    final from = DateTime(now.year, 1, 1);
    final to = DateTime(now.year, now.month, now.day);
    return (to.difference(from).inDays / 7).ceil();
  }

  /// Returns a [String] representing the date range for a week specified by
  /// [weekNumber] of the provided [year] formatted as
  /// 'start date (d. MMMM) - end date (d. MMMM) year (yyyy)'.
  static String getScopeOfTheWeek(int weekNumber, int year) {
    final firstDayOfYear = DateTime(year);
    final daysOffset = 1 - firstDayOfYear.weekday;
    final firstMonday = firstDayOfYear.add(Duration(days: daysOffset));
    final weekStart = firstMonday.add(Duration(days: weekNumber * 7));
    final weekEnd = weekStart.add(const Duration(days: 6));
    final formatter = DateFormat('d. MMMM', 'cs');

    return '${formatter.format(weekStart)} - ${formatter.format(weekEnd)} $year';
  }

  /// Returns a [DateTime] object representing the parsed date and [time] of
  /// delivery for today.
  static DateTime getDateTimeOfCurrentDelivery(String time) {
    return DateFormat('dd.MM.yyyy HH:mm').parse(
        '${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year} $time');
  }

  /// Checks if the current user is a canteen and evaluates additional
  /// conditions such as whether the delivery is confirmed or cancelled, and
  /// whether the current time falls within a certain window in which the user
  /// can donate food.
  ///
  /// Returns a [bool] indicating whether the current user is eligible to
  /// donate food.
  static bool canDonate(BuildContext context) {
    final user = getCurrentUser(context);

    if (user is Canteen) {
      final deliveryNotifier = context.read<DeliveryNotifier>();
      final deliveryConfirmed = deliveryNotifier.deliveryConfirmed(context);
      final deliveryCancelled = deliveryNotifier.deliveryCancelled(context);

      final currentTime = DateTime.now();
      final pickupTime = DateFormat('dd.MM.y HH:mm').parse(
        '${currentTime.day}.${currentTime.month}.${currentTime.year} ${user.pickUpFrom}',
      );
      final whileCanStillDonate = pickupTime.subtract(
        const Duration(minutes: Constants.pickupConfirmationTime),
      );

      if ((!deliveryConfirmed && currentTime.isAfter(whileCanStillDonate)) ||
          deliveryCancelled) {
        return false;
      }
      return true;
    }
    return false;
  }

  /// Retrieves user information using the [AuthService] and sets the user data
  /// in the [UserNotifier]. If the user has a `canteen` role, it calculates
  /// the date of today's delivery and uses it to fetch the corresponding
  /// delivery object which is then set in the [DeliveryNotifier]. If no
  /// delivery exists for current user or the user doesn't have the `canteen`
  /// role, it creates a dummy delivery.
  static Future<void> loadUserInfo(BuildContext context) async {
    final authService = GetIt.I<AuthService>();
    final deliveryService = GetIt.I<DeliveryService>();
    final userNotifier = context.read<UserNotifier>();
    final deliveryNotifier = context.read<DeliveryNotifier>();

    final user = await authService.getUserData();

    if (context.mounted) {
      userNotifier.user = user;

      if (user is Canteen) {
        final date =
            HelperService.getDateTimeOfCurrentDelivery(user.pickUpFrom!);

        deliveryNotifier.delivery = await deliveryService.getDelivery(
              date,
              user.establishmentId,
            ) ??
            // Dummy delivery in the case, the real doesn't exist
            _createDummyDelivery(context, user.establishmentId);

        return;
      }
      deliveryNotifier.delivery = _createDummyDelivery(
        context,
        user!.establishmentId,
      );
    }
  }

  /// Returns a dummy delivery object.
  static Delivery _createDummyDelivery(BuildContext context, String donor) {
    return Delivery(
      id: '123',
      donorId: donor,
      state: DeliveryStateHelper.toValue(DeliveryState.canceled, context),
    );
  }
}
