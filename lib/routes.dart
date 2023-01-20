import 'package:flutter/material.dart';
import 'package:zachranobed/ui/screens/donated_food_detail.dart';
import 'package:zachranobed/ui/screens/thank_you_screen.dart';
import 'package:zachranobed/ui/screens/home.dart';
import 'package:zachranobed/ui/screens/login.dart';
import 'package:zachranobed/ui/screens/offer_food_screen.dart';
import 'package:zachranobed/ui/screens/wrapper.dart';

class RouteManager {
  static const String wrapper = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String offerFood = '/offer-food';
  static const String thankYou = '/thank-you';
  static const String donatedFoodDetail = '/donated-food-detail';

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

      case thankYou:
        return MaterialPageRoute(
          builder: (context) => const ThankYouScreen(),
        );

      case donatedFoodDetail:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const DonatedFoodDetail(),
        );

      default:
        throw const FormatException('Route not found!');
    }
  }
}