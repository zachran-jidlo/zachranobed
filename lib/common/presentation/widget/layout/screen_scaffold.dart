import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/ui_constants.dart';
import 'package:zachranobed/common/presentation/widget/layout/adaptive_content.dart';

/// A scaffold widget that provides a basic structure for screens.
///
/// This widget uses [AdaptiveContent] to display different content on web and
/// mobile. On web, the content can be optionally centered using the
/// [centerWebLayout] property.
class ScreenScaffold extends StatelessWidget {
  /// Whether to automatically center the web layout.
  final bool centerWebLayout;

  /// If true the [body] and the scaffold's floating widgets should size
  /// themselves to avoid the onscreen keyboard whose height is defined by the
  /// ambient [MediaQuery]'s [MediaQueryData.viewInsets] `bottom` property.
  ///
  /// For example, if there is an onscreen keyboard displayed above the
  /// scaffold, the body can be resized to avoid overlapping the keyboard, which
  /// prevents widgets inside the body from being obscured by the keyboard.
  ///
  /// Defaults to true.
  final bool resizeToAvoidBottomInset;

  /// Optional app bar to display above the screen content.
  final Widget? appBar;

  /// The background color of the scaffold.
  final Color? backgroundColor;

  /// The color for system navigation bar.
  final Color? systemNavigationBarColor;

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
    this.resizeToAvoidBottomInset = true,
    this.appBar,
    this.backgroundColor,
    this.systemNavigationBarColor,
  });

  /// Creates a new [ScreenScaffold] widget with the same content for web and
  /// mobile. This constructor is useful when you want to display the same
  /// content for both layouts.
  ScreenScaffold.universal({
    Key? key,
    required Widget child,
    Widget? appBar,
  }) : this(
          key: key,
          appBar: appBar,
          web: (context) => child,
          mobile: (context) => child,
        );

  /// Creates a new [ScreenScaffold] widget with the same content for web and
  /// mobile. This constructor is useful when you want to display the same
  /// content for both layouts.
  const ScreenScaffold.universalBuilder({
    Key? key,
    required WidgetBuilder builder,
    Widget? appBar,
  }) : this(
          key: key,
          appBar: appBar,
          web: builder,
          mobile: builder,
        );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: backgroundColor ?? context.uiColors.surfaceGray,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          body: SafeArea(
            child: AdaptiveContent(
              web: (context) {
                final webContent = _buildContent(context, web);
                return centerWebLayout ? _buildCentered(webContent) : webContent;
              },
              mobile: (context) => _buildContent(context, mobile),
            ),
          ),
        ),

        // Paint the system navigation bar
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).padding.bottom,
            color: systemNavigationBarColor,
          ),
        ),
      ],
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
