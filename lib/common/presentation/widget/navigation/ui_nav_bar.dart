import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/ui_icon.dart';

/// A model representing a single item in the navigation bar.
class UiNavBarItem {
  /// The icon displayed in the navigation bar item.
  final UiIconSpec icon;

  /// The text label displayed below the icon.
  final String label;

  /// Creates a constant [UiNavBarItem].
  const UiNavBarItem({
    required this.icon,
    required this.label,
  });
}

/// A custom navigation bar built on top of [TabBar].
class UiNavBar extends StatelessWidget {
  /// Controller that manages the active tab index.
  final TabController controller;

  /// The list of navigation items to be displayed.
  final List<UiNavBarItem> items;

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
          tabs: items.map((item) {
            return Tab(
              icon: UiIcon(spec: item.icon),
              iconMargin: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
