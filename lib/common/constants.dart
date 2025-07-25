import 'package:flutter/material.dart';

class ZOColors {
  static const primary = Color.fromRGBO(192, 0, 22, 1);
  static const onPrimary = Color.fromRGBO(255, 255, 255, 1);
  static const primaryLight = Color.fromRGBO(248, 223, 229, 1);
  static const onPrimaryLight = Color.fromRGBO(83, 67, 65, 1);
  static const surfaceVariant = Color.fromRGBO(245, 221, 219, 1);
  static const onSurface = Color.fromRGBO(32, 26, 25, 1);
  static const secondary = Color.fromRGBO(255, 218, 214, 1);
  static const onSecondary = Color.fromRGBO(44, 21, 19, 1);
  static const onBackgroundSecondary = Color.fromRGBO(0, 0, 0, 0.5);
  static const borderColor = Color.fromRGBO(216, 194, 191, 1);
  static const lightBorderColor = Color.fromRGBO(251, 238, 236, 1);
  static const cardBackground = Color.fromRGBO(255, 251, 255, 1);
  static const onCardBackground = Color.fromRGBO(119, 86, 83, 1);
  static const disabledButtonChild = Color.fromRGBO(28, 27, 31, 0.16);
  static const disabledButtonBackground = Color.fromRGBO(28, 27, 31, 0.12);
  static const disabledButtonForeground = Color.fromRGBO(32, 26, 25, 0.38);
  static const infoSnackBarBackground = Color.fromRGBO(54, 47, 46, 1);
  static const onInfoSnackBarBackground = Color.fromRGBO(255, 251, 238, 1);
  static const outline = Color.fromRGBO(133, 115, 113, 1);
  static const success = Color.fromRGBO(135, 179, 0, 1);
  static const successLight = Color.fromRGBO(231, 240, 204, 1);
  static const onSuccess = Color.fromRGBO(255, 255, 255, 1);
  static const amberTransparent = Color.fromRGBO(255, 182, 0, 0.4);
  static const assistChipSelectedBackground = Color.fromRGBO(73, 69, 79, 0.12);
  static const staticBadgeBackground = Color.fromRGBO(19, 161, 4, 1);
  static const staticBadgeBorder = Color.fromRGBO(12, 128, 0, 1);
  static const staticBadgeOnBackground = Colors.white;
}

class ZOStrings {
  static const zjUrl = 'https://zachranobed.cz';
  static const zjEmail = 'aplikace.zo@zachranjidlo.cz';
  static const zobWebHomepage = 'https://zachranobed.cz';
  static const appTerms = 'https://zachranobed.cz/wp-content/uploads/2025/07/Podminky_Zachran-jidlo_v.1.1.pdf';
  static const appPrivacy = 'https://docs.google.com/document/d/1NhEGlrN4TgS49HviLkhcF4zCBU3i8w3ITkVQJhtMz-Q/edit';
  static const sponsors = 'https://zachranobed.cz/';

  static const zoLogoPath = 'assets/zo-logo.svg';
  static const foodImagePath = 'assets/food-image.png';
  static const foodImageBackgroundPath = 'assets/food-image-background.png';
  static const chefEmptyPath = 'assets/chef-empty.svg';
  static const boxEmptyPath = 'assets/box-empty.svg';
  static const overviewPath = 'assets/overview.svg';
  static const appTermsNotAcceptedPath = 'assets/app-terms-not-accepted.svg';
  static const appTermsNewVersionPath = 'assets/app-terms-new-version.svg';
  static const genericErrorPath = 'assets/generic-error.svg';
  static const offlineErrorPath = 'assets/offline-error.svg';
  static const iconFoodBox = 'assets/ic_food_box.svg';
  static const iconFoodBoxAlert = 'assets/ic_food_box_alert.svg';
  static const forceUpdatePath = 'assets/human_rotate_phone.svg';
  static const notificationsEmptyPath = 'assets/notifications-empty.svg';
}

class Constants {
  static const lastWeekOfYear = 52;

  /// The offset in minutes for "consume-by" field.
  static const foodConsumeByMinutesOffset = 30;

  // ZOB-305 Food temperature related constants
  static const foodTemperatureMin = 50;
  static const foodTemperatureMax = 100;
  static const foodTemperatureInitial = 68;

  // ZOB-324 Food boxes checkup related constants (in days)
  static const foodBoxesCheckupMaxDelay = 4;
  static const foodBoxesVerifiedThreshold = 3;
}

/// A class that defines layout constants.
class LayoutStyle {
  LayoutStyle._();

  /// The breakpoint for screen layouts. If the web screen width is greater
  /// than this value, the web layout is used. Otherwise, the mobile layout
  /// is used.
  static const webBreakpoint = 740;

  /// The fixed width of login form in wide web layout.
  static const loginFormWidth = 530;

  /// The fixed width of the navigation drawer in wide web layout.
  static const navigationDrawerSize = 244;
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
      errorMaxLines: 2,
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
