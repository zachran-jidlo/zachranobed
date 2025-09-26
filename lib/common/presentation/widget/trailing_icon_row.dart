import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';

/// A stateless widget that represents a row with trailing info and icon.
///
/// This row includes a title, optional description, trailing information, and
/// an icon. It is designed to be clickable, triggering a callback function when
/// tapped.
class TrailingIconRow extends StatelessWidget {
  /// The main title text displayed in the row.
  final String title;

  /// The optional description text displayed in the row.
  final String? description;

  /// The text displayed next to the icon at the trailing end.
  final String trailInfo;

  /// The icon displayed at the trailing end.
  final IconData trailingIcon;

  /// The background color of the row.
  final Color? background;

  /// The function to be called when the row is tapped.
  final VoidCallback? onTap;

  const TrailingIconRow({
    super.key,
    required this.title,
    required this.description,
    required this.trailInfo,
    required this.trailingIcon,
    this.background,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: background,
          border: Border.all(
            color: ZOColors.borderColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          title: Text(
            title,
            style: textTheme.bodyLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: _buildSubtitle(context, textTheme, description),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                trailInfo,
                style: textTheme.bodyLarge?.copyWith(
                  color: ZOColors.onPrimaryLight,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: GapSize.xs),
              Icon(trailingIcon, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _buildSubtitle(
    BuildContext context,
    TextTheme textTheme,
    String? description,
  ) {
    if (description == null) return null;
    return Text(
      description,
      style: textTheme.bodySmall?.copyWith(
        color: ZOColors.onPrimaryLight,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
