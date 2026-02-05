import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';

/// A custom wrapper around [AlertDialog] that provides a standardized
/// look and feel for the application's dialogs.
class UiDialog extends StatelessWidget {
  /// The primary text displayed at the top of the dialog.
  final String? title;

  /// The body text displayed in the center of the dialog.
  final String? content;

  /// How the [title] text should be aligned horizontally.
  /// Defaults to [TextAlign.start].
  final TextAlign titleAlign;

  /// An optional widget (typically an [Icon]) displayed above the [title].
  final Widget? icon;

  /// The set of actions displayed at the bottom.
  final List<Widget>? actions;

  /// Creates a [UiDialog].
  const UiDialog({
    super.key,
    required this.title,
    this.content,
    this.titleAlign = TextAlign.start,
    this.icon,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(context, title),
      content: _buildContent(context, content),
      icon: icon,
      actions: actions,
    );
  }

  Widget? _buildTitle(BuildContext context, String? title) {
    if (title == null) return null;

    return Text(
      title,
      textAlign: titleAlign,
      style: context.textStyles.headlineSmall,
    );
  }

  Widget? _buildContent(BuildContext context, String? content) {
    if (content == null) return null;

    return Text(
      content,
      style: context.textStyles.bodyMedium,
    );
  }

  /// Shows a basic loading dialog.
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }
}
