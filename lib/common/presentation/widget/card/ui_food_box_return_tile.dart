import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_card.dart';
import 'package:zachranobed/common/presentation/widget/graphics/ui_gradient_text.dart';
import 'package:zachranobed/common/presentation/widget/progress/ui_progress_bar.dart';

/// A tile widget that displays food box return information.
///
/// This widget shows a card with a title, subtitle, count display, optional action button, and optional
/// progress indicator.
class UiFoodBoxReturnTile extends StatelessWidget {
  /// The main title displayed in the tile.
  final String title;

  /// The subtitle displayed below the title.
  final String subtitle;

  /// The count value to display (e.g., number of boxes).
  final int count;

  /// Optional action widget (typically a button).
  /// Use [UiPrimaryButton] or [UiOutlineButton] for consistent styling.
  final Widget? action;

  /// Optional progress value from 0.0 to 1.0.
  /// If provided, displays a progress bar.
  final double? progress;

  /// Creates a [UiFoodBoxReturnTile] widget.
  const UiFoodBoxReturnTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.count,
    this.action,
    this.progress,
  }) : assert(progress == null || (progress >= 0.0 && progress <= 1.0));

  @override
  Widget build(BuildContext context) {
    return UiCard(
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildProgress(progress),
            Container(
              color: context.uiColors.surfaceWhite,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              alignment: Alignment.centerLeft,
              child: _buildTitle(context),
            ),
            Container(
              color: context.uiColors.surfaceGray,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                spacing: 16.0,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      _buildCount(context),
                      _buildSubtitle(context),
                    ],
                    ),
                  ),
                  if (action != null) Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: action!,
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }


  Widget _buildTitle(BuildContext context) {
    return UiGradientText(
      text: title,
      gradient: context.uiColors.primaryGradient,
      style: context.textStyles.bodyMedium,
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    return Text(
      subtitle,
      style: context.textStyles.labelSmall.copyWith(
        color: context.uiColors.textSecondary,
      ),
    );
  }

  Widget _buildCount(BuildContext context) {
    return FittedBox(
      child: Text.rich(
        style: context.textStyles.headlineHeavy,
        TextSpan(
          children: [
            TextSpan(text: count.toString()),
            TextSpan(text: ' '),
            TextSpan(
              text: context.l10n.commonCountShort,
              style: context.textStyles.headlineLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgress(double? progress) {
    if (progress == null) {
      return const SizedBox();
    }

    return SizedBox(
      height: 4,
      child: UiProgressBar(progress: progress),
    );
  }
}
