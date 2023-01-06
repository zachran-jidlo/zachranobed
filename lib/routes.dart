import 'package:flutter/material.dart';
import 'package:zachranobed/ui/screens/home.dart';
import 'package:zachranobed/ui/screens/login.dart';
import 'package:zachranobed/ui/screens/offer_food_screen.dart';
import 'package:zachranobed/ui/screens/wrapper.dart';

class RouteManager {
  static const String wrapper = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String offerFood = '/offer-food';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case wrapper:
        return MaterialPageRoute(
          builder: (context) => const Wrapper(),
        );

      case login:
        return MaterialPageRoute(
          builder: (context) => const Login(),
        );

      case home:
        return MaterialPageRoute(
          builder: (context) => const Home(),
        );

      case offerFood:
        return MaterialPageRoute(
          builder: (context) => const OfferFoodScreen(),
        );

      default:
        throw const FormatException('Route not found!');
    }
  }
}