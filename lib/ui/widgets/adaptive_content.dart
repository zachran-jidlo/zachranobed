import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/utils/platform_utils.dart';

/// A widget that displays a different child depending on the platform and
/// screen size.
///
/// If the platform is web and the screen width is greater than
/// [LayoutStyle.webBreakpoint], the [web] child is displayed.
/// Otherwise, the [mobile] child is displayed.
class AdaptiveContent extends StatelessWidget {
  /// The child to display on the web when the screen width is greater than
  /// [LayoutStyle.webBreakpoint].
  final WidgetBuilder web;

  /// The child to display on mobile or when the screen width is less than
  /// [LayoutStyle.webBreakpoint].
  final WidgetBuilder mobile;

  /// Creates a new [AdaptiveContent] widget.
  const AdaptiveContent({
    super.key,
    required this.web,
    required this.mobile,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (RunningPlatform.isWeb() && width > LayoutStyle.webBreakpoint) {
      return web(context);
    } else {
      return mobile(context);
    }
  }
}
