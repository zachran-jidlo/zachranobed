import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';

/// A widget that displays a different child depending on the platform and
/// screen size.
///
/// If the platform is web and the screen width is greater than
/// [LayoutStyle.webBreakpoint], the [web] child is displayed.
/// Otherwise, the [mobile] child is displayed.
class ScreenContent extends StatefulWidget {
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
  State<ScreenContent> createState() => _ScreenContentState();
}

/// State for the [ScreenContent] widget.
///
/// Manages [_web] and [_mobile] widgets, building them only when needed and
/// caching them for subsequent use.
class _ScreenContentState extends State<ScreenContent> {
  /// The widget to display on the web when the screen width is greater than
  /// [LayoutStyle.webBreakpoint].
  Widget? _web;

  /// The widget to display on mobile or when the screen width is less than
  /// [LayoutStyle.webBreakpoint].
  Widget? _mobile;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (kIsWeb && constraints.maxWidth > LayoutStyle.webBreakpoint) {
        _web ??= widget.web(context);
        return _web!;
      }
      _mobile ??= widget.mobile(context);
      return _mobile!;
    });
  }
}
