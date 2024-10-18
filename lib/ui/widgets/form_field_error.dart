import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';

/// A widget that displays an error message for a form field.
///
/// TODO (Alex) Fix error text style to match Figma
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
      padding: const EdgeInsets.only(
        top: 8.0,
        left: 12.0,
        right: 12.0,
      ),
      child: Text(
        message,
        style: textTheme.bodySmall?.copyWith(color: ZOColors.primary),
      ),
    );
  }
}
