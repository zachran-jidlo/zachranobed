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

  /// Optional semantic label for accessibility.
  /// If not provided, defaults to "Checkbox".
  final String? semanticLabel;

  /// Creates a [UiCheckbox].
  const UiCheckbox({
    super.key,
    required this.isChecked,
    required this.onChanged,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? context.l10n.a11yCheckbox,
      checked: isChecked,
      enabled: true,
      child: Material(
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
      ),
    );
  }
}
