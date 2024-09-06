import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';

/// A widget that displays a different child depending on the platform and
/// screen size.
///
/// If the platform is web and the screen width is greater than
/// [LayoutStyle.webBreakpoint], the [web] child is displayed.
/// Otherwise, the [mobile] child is displayed.
class ScreenContent extends StatelessWidget {
  /// The child to display on the web when the screen width is greater than
  /// [LayoutStyle.webBreakpoint].
  final WidgetBuilder web;

  /// The child to display on mobile or when the screen width is less than
  /// [LayoutStyle.webBreakpoint].
  final WidgetBuilder mobile;

  /// Creates a new [ScreenContent] widget.
  const ScreenContent({
    super.key,
    required this.web,
    required this.mobile,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (kIsWeb && constraints.maxWidth > LayoutStyle.webBreakpoint) {
        return Builder(builder: web);
      }
      return Builder(builder: mobile);
    });
  }
}
