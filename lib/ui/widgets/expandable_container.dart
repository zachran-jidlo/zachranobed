import 'package:flutter/material.dart';
import 'package:zachranobed/ui/widgets/button.dart';

/// A widget that can be expanded or collapsed to show or hide its child.
/// Expanding could be enabled / disabled via [isExpandable] parameter.
class ExpandableContainer extends StatelessWidget {
  /// The default collapsed height of the widget.
  static const _defaultCollapsedHeight = 100.0;

  /// The child widget to display.
  final Widget child;

  /// Whether the widget is expandable. When [isExpandable] is true, the widget
  /// can be expanded or collapsed by tapping the toggle button, displayed
  /// below the child.
  final bool isExpandable;

  /// Whether the widget is currently expanded.
  final bool isExpanded;

  /// The callback that is called when the widget is expanded or collapsed.
  final Function(bool) onExpandedChanged;

  /// The height of the widget when it is collapsed. If [collapsedHeight] is
  /// null, the default collapsed height is [_defaultCollapsedHeight].
  final double? collapsedHeight;

  /// The text displayed on the toggle button to expand the widget.
  final String labelExpand;

  /// The text displayed on the toggle button to collapse the widget.
  final String labelCollapse;

  /// Creates a [ExpandableContainer] widget.
  const ExpandableContainer({
    super.key,
    required this.isExpandable,
    required this.isExpanded,
    required this.onExpandedChanged,
    required this.labelExpand,
    required this.labelCollapse,
    required this.child,
    this.collapsedHeight,
  });

  @override
  Widget build(BuildContext context) {
    if (isExpandable && !isExpanded) {
      return Column(
        children: [
          Stack(
            children: [
              ClipRect(
                child: SizedBox(
                  height: collapsedHeight ?? _defaultCollapsedHeight,
                  child: OverflowBox(
                    alignment: Alignment.topCenter,
                    maxHeight: double.infinity,
                    child: child,
                  ),
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withAlpha(0),
                          Colors.white,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          _toggleExpandButton(),
        ],
      );
    }

    if (isExpandable && isExpanded) {
      return Column(
        children: [
          child,
          _toggleExpandButton(),
        ],
      );
    }

    return child;
  }

  Widget _toggleExpandButton() {
    return ZOButton(
      text: isExpanded ? labelCollapse : labelExpand,
      icon: isExpanded ? Icons.expand_less : Icons.expand_more,
      iconAlignment: IconAlignment.end,
      minimumSize: ZOButtonSize.tiny(),
      type: ZOButtonType.textPrimary,
      onPressed: () => onExpandedChanged(!isExpanded),
    );
  }
}
