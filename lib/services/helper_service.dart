import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/models/delivery.dart';
import 'package:zachranobed/models/user_data.dart';
import 'package:zachranobed/notifiers/delivery_notifier.dart';
import 'package:zachranobed/notifiers/user_notifier.dart';
import 'package:zachranobed/services/auth_service.dart';
import 'package:zachranobed/services/delivery_service.dart';

class HelperService {
  static UserData? getCurrentUser(BuildContext context) =>
      context.read<UserNotifier>().user;

  static int get getCurrentWeekNumber {
    final now = DateTime.now();
    final from = DateTime(now.year, 1, 1);
    final to = DateTime(now.year, now.month, now.day);
    return (to.difference(from).inDays / 7).ceil();
  }

  static String getScopeOfTheWeek(int weekNumber, int year) {
    final firstDayOfYear = DateTime(year);
    final daysOffset = 1 - firstDayOfYear.weekday;
    final firstMonday = firstDayOfYear.add(Duration(days: daysOffset));
    final weekStart = firstMonday.add(Duration(days: weekNumber * 7));
    final weekEnd = weekStart.add(const Duration(days: 6));
    final formatter = DateFormat('d. MMMM', 'cs');

    return '${formatter.format(weekStart)} - ${formatter.format(weekEnd)} $year';
  }

  static DateTime getDateTimeOfCurrentDelivery(String time) {
    return DateFormat('dd.MM.yyyy HH:mm').parse(
        '${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year} $time');
  }

  static bool canDonate(BuildContext context) {
    final user = getCurrentUser(context);
    final deliveryConfirmed =
        context.read<DeliveryNotifier>().deliveryConfirmed(context);
    final deliveryCancelled =
        context.read<DeliveryNotifier>().deliveryCancelled(context);
    final whileCanStillDonate = DateFormat('dd.MM.y HH:mm')
        .parse(
            '${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year} ${user!.pickUpFrom}')
        .subtract(const Duration(minutes: 35));

    if ((!deliveryConfirmed && DateTime.now().isAfter(whileCanStillDonate)) ||
        deliveryCancelled) {
      return false;
    }
    return true;
  }

  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  static Future<void> loadUserInfo(BuildContext context) async {
    final authService = GetIt.I<AuthService>();
    final deliveryService = GetIt.I<DeliveryService>();

    final user = await authService.getUserData();
    if (context.mounted) {
      final userNotifier = Provider.of<UserNotifier>(context, listen: false);
      userNotifier.user = user;

      final date = HelperService.getDateTimeOfCurrentDelivery(user!.pickUpFrom);

      final deliveryNotifier =
          Provider.of<DeliveryNotifier>(context, listen: false);
      deliveryNotifier.delivery = await deliveryService.getDelivery(
            date,
            user.establishmentName,
          ) ??
          // Dummy delivery in case, the real delivery doesn't exist
          Delivery(
            id: '123',
            donor: userNotifier.user!.establishmentName,
            state: context.l10n!.deliveryCancelledState,
          );
    }
  }
}
