import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';

/// A welcome tile widget displaying a greeting with the entity name.
///
/// Features a circular avatar icon, a welcome title, and the entity name.
/// Supports tap interaction with ripple effect.
class UiWelcomeTile extends StatelessWidget {
  /// The name of the entity (canteen or charity).
  final String entityName;

  /// The press callback.
  final VoidCallback onPressed;

  /// Creates a [UiWelcomeTile] widget.
  const UiWelcomeTile({
    super.key,
    required this.entityName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.uiColors.transparent,
      borderRadius: BorderRadius.circular(16.0),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        splashColor: context.uiColors.textPrimary.withValues(alpha: 0.1),
        highlightColor: context.uiColors.textPrimary.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 16.0,
            children: [
              _buildAvatar(context),
              Expanded(
                child: _buildContent(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: context.uiColors.surfaceGrayDark,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person,
        size: 24,
        color: context.uiColors.textPrimary,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.l10n.overviewWelcomeTitle,
          style: context.textStyles.headlineSmall,
        ),
        Text(
          entityName,
          style: context.textStyles.titleSmall.copyWith(
            color: context.uiColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
