import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/models/user.dart';

User getCurrentUser(BuildContext context) {
  return context.read<User>();
}
