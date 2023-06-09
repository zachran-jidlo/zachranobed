import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/models/user.dart';
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

  static String getDateTimeOfCurrentDelivery(String time) {
    return DateFormat('dd.MM.y HH:mm')
        .parse(
            '${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year} $time')
        .toUtc()
        .toIso8601String();
  }
}
