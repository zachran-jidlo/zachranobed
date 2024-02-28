import 'package:flutter/material.dart';

class ZOColors {
  static const primary = Color.fromRGBO(192, 0, 22, 1);
  static const onPrimary = Color.fromRGBO(255, 255, 255, 1);
  static const primaryLight = Color.fromRGBO(248, 223, 229, 1);
  static const onPrimaryLight = Color.fromRGBO(83, 67, 65, 1);
  static const secondary = Color.fromRGBO(255, 218, 214, 1);
  static const onSecondary = Color.fromRGBO(44, 21, 19, 1);
  static const borderColor = Color.fromRGBO(216, 194, 191, 1);
  static const lightBorderColor = Color.fromRGBO(251, 238, 236, 1);
  static const cardBackground = Color.fromRGBO(255, 251, 255, 1);
  static const onCardBackground = Color.fromRGBO(119, 86, 83, 1);
  static const disabledButtonChild = Color.fromRGBO(28, 27, 31, 0.16);
  static const infoSnackBarBackground = Color.fromRGBO(54, 47, 46, 1);
  static const onInfoSnackBarBackground = Color.fromRGBO(255, 251, 238, 1);
  static const success = Color.fromRGBO(135, 179, 0, 1);
  static const successLight = Color.fromRGBO(231, 240, 204, 1);
  static const onSuccess = Color.fromRGBO(255, 255, 255, 1);
}

class ZOStrings {
  static const zjUrl = 'https://zachranobed.cz';
  static const zjEmail = 'info@zachranjidlo.cz';

  static const zoLogoPath = 'assets/zo-logo.svg';
  static const foodImagePath = 'assets/food-image.png';
}

class Constants {
  static const lastWeekOfYear = 52;
  static const pickupConfirmationTime = 35;
}

class WidgetStyle {
  static const inputBorder =
      OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.grey));

  static const padding = 16.0;
}

class GapSize {
  static const xxl = 48.0;
  static const xl = 40.0;
  static const l = 32.0;
  static const m = 24.0;
  static const s = 20.0;
  static const xs = 16.0;
  static const xxs = 14.0;
}

class FontSize {
  static const xxl = 36.0;
  static const xl = 28.0;
  static const l = 24.0;
  static const m = 22.0;
  static const s = 16.0;
  static const xs = 14.0;
  static const xxs = 12.0;
}
