import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/graphics/ui_icon.dart';
import 'package:zachranobed/common/presentation/widget/graphics/ui_indicator.dart';

/// A navigation drawer item widget with support for selected and hover states.
///
/// This widget displays a clickable row with an icon, text label,
/// and optional indicator badge. It provides visual feedback for default,
/// hover, and selected states following the design system patterns.
class UiNavigationDrawerItem extends StatefulWidget {
  /// The text label to display.
  final String label;

  /// Icon specification to display before the label.
  final UiIconSpec icon;

  /// Whether this item is currently selected. Defaults to false.
  final bool selected;

  /// Callback function triggered when the item is tapped.
  final VoidCallback onPressed;

  /// Whether to show an indicator badge on the icon.
  final bool showIndicator;

  /// Creates a [UiNavigationDrawerItem] widget.
  const UiNavigationDrawerItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.selected = false,
    this.showIndicator = false,
  });

  @override
  State<UiNavigationDrawerItem> createState() => _UiNavigationDrawerItemState();
}

class _UiNavigationDrawerItemState extends State<UiNavigationDrawerItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final style = TextButton.styleFrom(
      backgroundColor: _resolveBackgroundColor(context),
      foregroundColor: _resolveContentColor(context),
      minimumSize: const Size(0, 56.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      shape: const StadiumBorder(),
      textStyle: context.textStyles.titleMedium,
      elevation: 0.0,
    );

    return TextButton.icon(
      style: style,
      onPressed: widget.onPressed,
      onHover: (isHovering) {
        setState(() => _isHovering = isHovering);
      },
      icon: _buildIcon(),
      label: _buildLabel(),
    );
  }

  Widget _buildIcon() {
    return UiIndicator(
      isVisible: widget.showIndicator,
      child: UiIcon(
        spec: widget.icon,
        size: 24.0,
        color: _resolveContentColor(context),
      ),
    );
  }

  Widget _buildLabel() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        widget.label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Color _resolveBackgroundColor(BuildContext context) {
    if (_isHovering) {
      return context.uiColors.primary.withValues(alpha: 0.1);
    }
    return context.uiColors.transparent;
  }

  Color _resolveContentColor(BuildContext context) {
    if (widget.selected) {
      return context.uiColors.primary;
    }
    return context.uiColors.textSecondary;
  }
}
