import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/models/user.dart';
import 'package:zachranobed/notifiers/user_notifier.dart';

User? getCurrentUser(BuildContext context) {
  return context.read<UserNotifier>().user;
}
