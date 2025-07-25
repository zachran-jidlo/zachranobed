import 'package:flutter/material.dart';
import 'package:zachranobed/common/image_assets.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/empty_page.dart';

/// A widget that displays an error message with an optional retry button.
class ErrorContent extends StatelessWidget {

  /// An optional callback to be invoked when the retry button is pressed.
  final VoidCallback? onRetryPressed;

  const ErrorContent({super.key, required this.onRetryPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EmptyPage(
          vectorImagePath: ImageAssets.imageErrorGeneric,
          title: context.l10n!.commonGenericErrorTitle,
          description: context.l10n!.commonGenericErrorDescription,
        ),
        if (onRetryPressed != null)
          ZOButton(
            text: context.l10n!.commonGenericErrorRetryAction,
            onPressed: () => onRetryPressed?.call(),
          ),
      ],
    );
  }
}
