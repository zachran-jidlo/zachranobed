import 'package:flutter/material.dart';

class ZOColors {
  static const primary = Color.fromRGBO(192, 0, 22, 1);
  static const onPrimary = Color.fromRGBO(255, 255, 255, 1);
  static const primaryLight = Color.fromRGBO(248, 223, 229, 1);
  static const onPrimaryLight = Color.fromRGBO(83, 67, 65, 1);
  static const secondary = Color.fromRGBO(255, 218, 214, 1);
  static const infoSnackBarBackground = Color.fromRGBO(54, 47, 46, 1);
  static const outline = Color.fromRGBO(133, 115, 113, 1);
}

/// A class that defines layout constants.
class LayoutStyle {
  LayoutStyle._();

  /// The breakpoint for screen layouts. If the web screen width is greater
  /// than this value, the web layout is used. Otherwise, the mobile layout
  /// is used.
  static const webBreakpoint = 740;

  /// The fixed width of the navigation drawer in wide web layout.
  static const navigationDrawerSize = 244;
}
