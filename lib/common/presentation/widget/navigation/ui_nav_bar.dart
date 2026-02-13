import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/graphics/ui_icon.dart';
import 'package:zachranobed/common/presentation/widget/graphics/ui_indicator.dart';

/// A custom navigation bar built on top of [TabBar].
class UiNavBar extends StatelessWidget {
  /// Controller that manages the active tab index.
  final TabController controller;

  /// The list of navigation items to be displayed.
  final List<Widget> items;

  /// Creates a [UiNavBar] widget.
  const UiNavBar({
    super.key,
    required this.controller,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90.0,
      child: Material(
        color: context.uiColors.surfaceWhite,
        child: TabBar(
          controller: controller,
          splashBorderRadius: BorderRadius.circular(24.0),
          labelPadding: const EdgeInsets.all(4.0),
          labelStyle: context.textStyles.bodySmall,
          labelColor: context.uiColors.primary,
          unselectedLabelColor: context.uiColors.textSecondary,
          indicatorColor: Colors.transparent,
          tabs: items,
        ),
      ),
    );
  }
}

/// A navigation bar item widget representing a single tab in the bottom navigation.
class UiNavBarItem extends StatelessWidget {
  /// The icon displayed in the navigation bar item.
  final UiIconSpec icon;

  /// The text label displayed below the icon.
  final String label;

  /// Whether to show an indicator badge on the icon.
  final bool showIndicator;

  /// Creates a [UiNavBarItem].
  const UiNavBarItem({
    super.key,
    required this.icon,
    required this.label,
    this.showIndicator = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      icon: UiIndicator(
        isVisible: showIndicator,
        child: UiIcon(spec: icon),
      ),
      iconMargin: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
