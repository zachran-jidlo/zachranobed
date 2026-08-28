/// A class that defines layout constants.
class LayoutStyle {
  LayoutStyle._();

  /// The breakpoint for screen layouts. If the web screen width is greater
  /// than this value, the web layout is used. Otherwise, the mobile layout
  /// is used.
  static const webBreakpoint = 740;

  /// Devices with a shortest side of this value or more are treated as large
  /// screens. Android 16 and newer ignore an app's portrait request on them.
  static const largeScreenBreakpoint = 600;

  /// The fixed width of the navigation drawer in wide web layout.
  static const navigationDrawerSize = 244;
}
