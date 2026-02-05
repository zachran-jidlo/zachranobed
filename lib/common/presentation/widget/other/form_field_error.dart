import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';

/// A widget that displays an error message for a form field.
class FormFieldError extends StatelessWidget {
  /// The error message to display.
  final String message;

  /// Creates a [FormFieldError] widget.
  const FormFieldError({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Text(
        message,
        style: context.textStyles.bodySmall.copyWith(
          color: context.uiColors.error,
        ),
      ),
    );
  }
}
