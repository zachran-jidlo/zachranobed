import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_card.dart';

/// A card widget for displaying donation status information with optional progress tracking, status messages,
/// and actions.
class UiDonationStatusCard extends StatelessWidget {
  /// The label displayed at the top of the header (smaller, secondary text).
  final String label;

  /// The main title displayed below the label in the header.
  final String title;

  /// Optional widget displayed on the right side of the header.
  ///
  /// Typically used for action buttons like "Change" or "Edit".
  final Widget? headerAction;

  /// Optional progress bar widget.
  ///
  /// Displayed in a gray background section between the header and status.
  /// Use [UiProgressStepper] or similar progress widgets here.
  final Widget? progressBar;

  /// Optional status message widget.
  ///
  /// Displayed in a gray background section. Should contain status text or information.
  final Widget? statusSection;

  /// Optional info widget displayed on the left side of the action section.
  ///
  /// Typically used for displaying countdown timers, time ranges, or other contextual information.
  final Widget? actionInfo;

  /// Optional button widget displayed on the right side of the action section.
  ///
  /// Typically used for primary or secondary action buttons.
  final Widget? actionButton;

  /// Creates a [UiDonationStatusCard] widget.
  const UiDonationStatusCard({
    super.key,
    required this.label,
    required this.title,
    this.headerAction,
    this.progressBar,
    this.statusSection,
    this.actionInfo,
    this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    return UiCard(
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context, headerAction),
          _buildProgressSection(context, progressBar),
          _buildStatusSection(context, statusSection),
          _buildActionSection(context, actionInfo, actionButton),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Widget? action) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        top: 16.0,
        bottom: 16.0,
      ),
      child: Row(
        spacing: 16.0,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4.0,
              children: [
                Text(
                  label,
                  style: context.textStyles.labelMedium.copyWith(
                    color: context.uiColors.textSecondary,
                  ),
                ),
                Text(
                  title,
                  style: context.textStyles.titleMedium.copyWith(
                    color: context.uiColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          if (action != null) action,
        ],
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context, Widget? progress) {
    if (progress == null) {
      return const SizedBox();
    }

    return Container(
      color: context.uiColors.surfaceGray,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: progress,
    );
  }

  Widget _buildStatusSection(BuildContext context, Widget? status) {
    if (status == null) {
      return const SizedBox();
    }

    return Container(
      color: context.uiColors.surfaceGray,
      padding: const EdgeInsets.all(16),
      child: status,
    );
  }

  Widget _buildActionSection(BuildContext context, Widget? info, Widget? button) {
    if (info == null && button == null) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        spacing: 16.0,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (info != null) Expanded(child: info),
          if (button != null) button,
        ],
      ),
    );
  }
}
