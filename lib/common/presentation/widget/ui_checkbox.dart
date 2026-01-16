import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';

/// A custom checkbox widget following the app's design system.
///
/// Displays a checkbox with gradient background when checked and bordered box when unchecked.
class UiCheckbox extends StatelessWidget {
  /// Whether the checkbox is checked.
  final bool isChecked;

  /// Called when the checkbox is tapped.
  final ValueChanged<bool> onChanged;

  /// Creates a [UiCheckbox].
  const UiCheckbox({
    super.key,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(!isChecked),
        borderRadius: BorderRadius.circular(24.0),
        splashColor: context.uiColors.textPrimary.withValues(alpha: 0.1),
        highlightColor: context.uiColors.textPrimary.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            width: 18.0,
            height: 18.0,
            decoration: BoxDecoration(
              gradient: isChecked ? context.uiColors.primaryGradient : null,
              border: isChecked ? null : Border.all(color: context.uiColors.textPrimary, width: 2.0),
              borderRadius: BorderRadius.circular(2.0),
            ),
            child: isChecked
                ? Icon(
                    Icons.check,
                    size: 16.0,
                    color: context.uiColors.surfaceWhite,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
