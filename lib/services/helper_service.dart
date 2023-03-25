import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/models/user.dart';
import 'package:zachranobed/notifiers/user_notifier.dart';

class HelperService {
  static User? getCurrentUser(BuildContext context) =>
      context.read<UserNotifier>().user;

  static int get getCurrentWeekNumber {
    DateTime now = DateTime.now();
    var from = DateTime(now.year, 1, 1);
    var to = DateTime(now.year, now.month, now.day);
    return (to.difference(from).inDays / 7).ceil();
  }
}
