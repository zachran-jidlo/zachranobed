import 'package:flutter/material.dart';
import 'package:zachranobed/ui/screens/home.dart';
import 'package:zachranobed/ui/screens/login.dart';

class RouteManager {
  static const String login = '/';
  static const String home = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (context) => const Login(),
        );

      case home:
        return MaterialPageRoute(
          builder: (context) => const Home(),
        );

      default:
        throw const FormatException('Route not found!');
    }
  }
}