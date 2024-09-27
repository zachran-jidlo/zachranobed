import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/ui/widgets/adaptive_content.dart';

/// A scaffold widget that provides a basic structure for screens.
///
/// This widget uses [AdaptiveContent] to display different content on web and
/// mobile. On web, the content can be optionally centered using the
/// [centerWebLayout] property.
class ScreenScaffold extends StatelessWidget {
  /// Whether to automatically center the web layout.
  final bool centerWebLayout;

  /// The child to display on the web when the screen width is greater than
  /// [LayoutStyle.webBreakpoint].
  final WidgetBuilder web;

  /// The child to display on mobile or when the screen width is less than
  /// [LayoutStyle.webBreakpoint].
  final WidgetBuilder mobile;

  /// Creates a new [ScreenScaffold] widget.
  const ScreenScaffold({
    super.key,
    required this.web,
    required this.mobile,
    this.centerWebLayout = true,
  });

  /// Creates a new [ScreenScaffold] widget with the same content for web and
  /// mobile. This constructor is useful when you want to display the same
  /// content for both layouts.
  ScreenScaffold.universal({
    Key? key,
    required Widget child,
  }) : this(key: key, web: (context) => child, mobile: (context) => child);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AdaptiveContent(
          web: centerWebLayout ? _webCentered : web,
          mobile: mobile,
        ),
      ),
    );
  }

  /// Builds the centered web layout. This method centers the web layout within
  /// a [SizedBox] with a width of [LayoutStyle.webBreakpoint].
  Widget _webCentered(BuildContext context) {
    return Center(
      child: SizedBox(
        width: LayoutStyle.webBreakpoint.toDouble(),
        child: web(context),
      ),
    );
  }
}
