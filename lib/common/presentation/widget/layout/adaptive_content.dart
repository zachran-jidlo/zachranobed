import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/common/domain/utils/platform_utils.dart';
import 'package:zachranobed/common/presentation/utils/ui_constants.dart';

/// The type of layout being used in the adaptive content.
enum AdaptiveLayoutType {
  /// Mobile layout for smaller screens.
  mobile,

  /// Web layout for larger screens.
  web,
}

/// Configuration for the adaptive layout, providing information about
/// which layout is currently being used.
class AdaptiveLayoutConfig {
  /// The type of layout currently being displayed.
  final AdaptiveLayoutType layoutType;

  /// Creates a new [AdaptiveLayoutConfig].
  const AdaptiveLayoutConfig({required this.layoutType});

  /// Returns true if the current layout is mobile.
  bool get isMobile => layoutType == AdaptiveLayoutType.mobile;

  /// Returns true if the current layout is web.
  bool get isWeb => layoutType == AdaptiveLayoutType.web;
}

/// A widget that displays a different child depending on the platform and
/// screen size.
///
/// If the platform is web and the screen width is greater than
/// [LayoutStyle.webBreakpoint], the [web] child is displayed.
/// Otherwise, the [mobile] child is displayed.
///
/// Provides [AdaptiveLayoutConfig] to the widget tree to allow descendants
/// to determine which layout is currently active.
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
    final isWebLayout = RunningPlatform.isWeb() && width > LayoutStyle.webBreakpoint;

    final layoutConfig = AdaptiveLayoutConfig(
      layoutType: isWebLayout ? AdaptiveLayoutType.web : AdaptiveLayoutType.mobile,
    );

    return Provider<AdaptiveLayoutConfig>.value(
      value: layoutConfig,
      builder: (context, _) => isWebLayout ? web(context) : mobile(context),
    );
  }
}
