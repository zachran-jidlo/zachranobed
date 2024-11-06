import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';

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
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: GapSize.xs),
      child: Text(
        message,
        style: textTheme.bodySmall?.copyWith(color: ZOColors.primary),
      ),
    );
  }
}
