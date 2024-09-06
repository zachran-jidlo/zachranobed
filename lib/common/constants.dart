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
  static const outline = Color.fromRGBO(133, 115, 113, 1);
  static const success = Color.fromRGBO(135, 179, 0, 1);
  static const successLight = Color.fromRGBO(231, 240, 204, 1);
  static const onSuccess = Color.fromRGBO(255, 255, 255, 1);
  static const amberTransparent = Color.fromRGBO(255, 182, 0, 0.4);
}

class ZOStrings {
  static const zjUrl = 'https://zachranobed.cz';
  static const zjEmail = 'info@zachranjidlo.cz';
  static const zobWebHomepage = 'https://zachranobed.cz';
  static const appTerms = 'https://zachranobed.cz/wp-content/uploads/2024/07/Podminky-zapojeni-do-projektu-Zachran-obed.pdf';
  static const appPrivacy = 'https://docs.google.com/document/d/1NhEGlrN4TgS49HviLkhcF4zCBU3i8w3ITkVQJhtMz-Q/edit';
  static const sponsors = 'https://zachranobed.cz/';

  static const zoLogoPath = 'assets/zo-logo.svg';
  static const foodImagePath = 'assets/food-image.png';
  static const chefEmptyPath = 'assets/chef-empty.svg';
  static const boxEmptyPath = 'assets/box-empty.svg';
  static const certificationCheckPath = 'assets/certification_check.svg';
  static const genericErrorPath = 'assets/generic-error.svg';
  static const iconFoodBox = 'assets/ic_food_box.svg';
}

class Constants {
  static const lastWeekOfYear = 52;

  // ZOB-234 Use shorter confirmation time for personal delivery
  static const pickupConfirmationTimeDefault = 45;
  static const pickupConfirmationTimePersonal = 20;
}

/// A class that defines layout constants.
class LayoutStyle {
  LayoutStyle._();

  /// The breakpoint for screen layouts. If the web screen width is greater
  /// than this value, the web layout is used. Otherwise, the mobile layout
  /// is used.
  static const webBreakpoint = 800;
}

class WidgetStyle {
  static const inputBorder = OutlineInputBorder(
    borderSide: BorderSide(
      width: 1,
      color: ZOColors.outline,
    ),
  );
  static const errorBorder = OutlineInputBorder(
    borderSide: BorderSide(
      width: 2,
      color: ZOColors.primary,
    ),
  );

  static const padding = 16.0;
  static const paddingSmall = 12.0;
  static const overviewBottomPadding = 64.0;

  static InputDecoration createInputDecoration({
    required String? label,
    required bool isValid,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: isValid ? ZOColors.onPrimaryLight : ZOColors.primary,
      ),
      enabledBorder: WidgetStyle.inputBorder,
      focusedBorder: WidgetStyle.inputBorder,
      disabledBorder: WidgetStyle.inputBorder,
      errorBorder: WidgetStyle.errorBorder,
      focusedErrorBorder: WidgetStyle.errorBorder,
    );
  }
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
