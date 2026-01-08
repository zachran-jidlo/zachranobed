import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';

/// A custom app bar widget for application following the design system.
class UiAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The primary text to display in the app bar.
  final String title;

  /// A list of Widgets to display in a row after the [title].
  final List<Widget>? actions;

  /// Whether to imply the leading widget. Defaults to true.
  final bool automaticallyImplyLeading;

  /// Creates a [UiAppBar].
  const UiAppBar({
    super.key,
    required this.title,
    this.automaticallyImplyLeading = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: context.uiColors.transparent,
      titleSpacing: automaticallyImplyLeading && Navigator.canPop(context) ? 4.0 : 16.0,
      actions: actions,
      title: Text(
        title,
        style: context.textStyles.titleLarge,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
