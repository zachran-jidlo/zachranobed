import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';

/// A static badge widget that displays an icon and text within a styled
/// container.
///
/// Note: Colors are set to success-green, extend if needed.
class StaticBadge extends StatelessWidget {
  /// The text to display within the badge.
  final String text;

  /// The icon to display on the left side of the badge.
  final IconData icon;

  /// Creates a [StaticBadge] widget.
  const StaticBadge({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.only(
        left: 4.0,
        top: 2.0,
        right: 8.0,
        bottom: 2.0,
      ),
      decoration: BoxDecoration(
        color: ZOColors.staticBadgeBackground,
        border: Border.all(width: 1, color: ZOColors.staticBadgeBorder),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Icon(icon, color: ZOColors.staticBadgeOnBackground, size: 18.0),
          const SizedBox(width: 8.0),
          Text(
            text,
            style: textTheme.labelSmall
                ?.copyWith(color: ZOColors.staticBadgeOnBackground),
          )
        ],
      ),
    );
  }
}
