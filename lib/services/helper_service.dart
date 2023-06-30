import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zachranobed/models/user.dart';
import 'package:zachranobed/notifiers/delivery_notifier.dart';
import 'package:zachranobed/notifiers/user_notifier.dart';

class HelperService {
  static User? getCurrentUser(BuildContext context) =>
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

  static String getDateTimeOfCurrentDelivery(String time) {
    return DateFormat('dd.MM.y HH:mm')
        .parse(
            '${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year} $time')
        .toUtc()
        .toIso8601String();
  }

  static bool canDonate(BuildContext context) {
    final user = getCurrentUser(context);
    final deliveryConfirmed =
        context.watch<DeliveryNotifier>().deliveryConfirmed();
    final deliveryCancelled =
        context.watch<DeliveryNotifier>().deliveryCancelled();
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
}
