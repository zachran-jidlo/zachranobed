import 'package:flutter/material.dart';
import 'package:zachranobed/ui/screens/donated_food_detail_screen.dart';
import 'package:zachranobed/ui/screens/home_screen.dart';
import 'package:zachranobed/ui/screens/login_screen.dart';
import 'package:zachranobed/ui/screens/menu_screen.dart';
import 'package:zachranobed/ui/screens/offer_food_screen.dart';
import 'package:zachranobed/ui/screens/thank_you_screen.dart';
import 'package:zachranobed/ui/screens/wrapper_screen.dart';

class RouteManager {
  static const String wrapper = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String offerFood = '/offer-food';
  static const String menu = '/menu';
  static const String thankYou = '/thank-you';
  static const String donatedFoodDetail = '/donated-food-detail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case wrapper:
        return MaterialPageRoute(
          builder: (context) => const WrapperScreen(),
        );

      case login:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );

      case home:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );

      case menu:
        return MaterialPageRoute(
          builder: (context) => const MenuScreen(),
        );

      case offerFood:
        return MaterialPageRoute(
          builder: (context) => const OfferFoodScreen(),
        );

      case thankYou:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const ThankYouScreen(),
        );

      case donatedFoodDetail:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const DonatedFoodDetailScreen(),
        );

      default:
        throw const FormatException('Route not found!');
    }
  }
}
