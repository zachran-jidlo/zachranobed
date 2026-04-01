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
