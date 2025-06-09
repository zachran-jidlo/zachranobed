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

  /// Optional app bar to display above the screen content.
  final Widget? appBar;

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
    this.appBar,
    this.centerWebLayout = true,
  });

  /// Creates a new [ScreenScaffold] widget with the same content for web and
  /// mobile. This constructor is useful when you want to display the same
  /// content for both layouts.
  ScreenScaffold.universal({
    Key? key,
    required Widget child,
    Widget? appBar,
  }) : this(key: key, appBar: appBar, web: (context) => child, mobile: (context) => child);

  /// Creates a new [ScreenScaffold] widget with the same content for web and
  /// mobile. This constructor is useful when you want to display the same
  /// content for both layouts.
  const ScreenScaffold.universalBuilder({
    Key? key,
    required WidgetBuilder builder,
    Widget? appBar,
  }) : this(key: key, appBar: appBar, web: builder, mobile: builder);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AdaptiveContent(
          web: (context) {
            final webContent = _buildContent(context, web);
            return centerWebLayout ? _buildCentered(webContent) : webContent;
          },
          mobile: (context) => _buildContent(context, mobile),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetBuilder body) {
    return Column(
      children: [
        if (appBar != null) appBar!,
        Expanded(
          child: body(context),
        ),
      ],
    );
  }

  Widget _buildCentered(Widget child) {
    return Center(
      child: SizedBox(
        width: LayoutStyle.webBreakpoint.toDouble(),
        child: child,
      ),
    );
  }
}
