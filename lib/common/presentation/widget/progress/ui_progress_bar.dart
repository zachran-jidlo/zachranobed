import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';

/// A widget that displays a progress bar.
class UiProgressBar extends StatelessWidget {
  /// The progress of the progress bar, a value from 0.0 to 1.0.
  final double progress;

  /// Creates a [UiProgressBar] widget.
  const UiProgressBar({
    super.key,
    required this.progress,
  }) : assert(progress >= 0.0 && progress <= 1.0);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: 4,
          width: double.infinity,
          child: Align(
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: constraints.maxWidth * progress,
              decoration: BoxDecoration(
                gradient: context.uiColors.primaryGradient,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        );
      },
    );
  }
}
