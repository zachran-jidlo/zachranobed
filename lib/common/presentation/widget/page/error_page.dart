import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/image_assets.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/page/info_page.dart';

/// A specialized error page widget for displaying generic error states with retry functionality.
///
/// This widget provides a consistent error display across the application using the [InfoPage] component.
class ErrorPage extends StatelessWidget {
  /// Optional callback invoked when the retry button is pressed.
  ///
  /// If null, the retry button will not be displayed.
  final VoidCallback? onRetryPressed;

  /// Creates a [ErrorPage] widget.
  const ErrorPage({
    super.key,
    this.onRetryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InfoPage(
      image: ImageAssets.imageErrorGeneric,
      title: context.l10n.commonGenericErrorTitle,
      description: context.l10n.commonGenericErrorDescription,
      actions: [
        if (onRetryPressed != null)
          UiPrimaryButton(
            size: UiButtonSize.medium(),
            text: context.l10n.commonGenericErrorRetryAction,
            onPressed: () => onRetryPressed?.call(),
          )
      ],
    );
  }
}
