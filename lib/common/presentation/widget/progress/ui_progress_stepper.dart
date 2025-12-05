import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/ui_gradient_shader_mask.dart';
import 'package:zachranobed/common/presentation/widget/ui_icon.dart';

/// A widget that displays a progress stepper with icons and connecting bars. This stepper visually represents progress
/// through multiple steps using icons and connecting lines.
class UiProgressStepper extends StatelessWidget {
  /// The list of icon specifications to display for each step.
  final List<UiIconSpec> icons;

  /// The index of the current step.
  final int currentStep;

  /// Whether the current step is active (highlighted with a gradient).
  final bool isCurrentStepActive;

  /// Whether all steps are complete.
  final bool isProgressComplete;

  /// Creates a [UiProgressStepper] widget.
  const UiProgressStepper({
    super.key,
    required this.icons,
    required this.currentStep,
    required this.isCurrentStepActive,
    required this.isProgressComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _buildSteps(context),
    );
  }

  List<Widget> _buildSteps(BuildContext context) {
    final List<Widget> steps = [];
    for (int i = 0; i < icons.length; i++) {
      steps.add(
        _buildStepIcon(
          context,
          index: i,
        ),
      );

      if (i < icons.length - 1) {
        steps.add(
          Expanded(
            child: _buildConnector(
              context,
              index: i,
            ),
          ),
        );
      }
    }
    return steps;
  }

  Widget _buildStepIcon(
    BuildContext context, {
    required int index,
  }) {
    Color? color;
    Gradient? gradient;
    if (isProgressComplete) {
      if (index == icons.length - 1) {
        color = context.uiColors.success;
      } else {
        color = context.uiColors.inactive;
      }
    } else {
      if (index == currentStep && isCurrentStepActive) {
        gradient = context.uiColors.primaryGradient;
      } else if (index < currentStep) {
        color = context.uiColors.primary;
      } else {
        color = context.uiColors.inactive;
      }
    }

    return UiGradientShaderMask(
      color: color,
      gradient: gradient,
      child: UiIcon(
        spec: icons[index],
        color: Colors.black,
        size: 20,
      ),
    );
  }

  Widget _buildConnector(
    BuildContext context, {
    required int index,
  }) {
    Color? color;
    Gradient? gradient;
    if (isProgressComplete) {
      color = context.uiColors.inactive;
    } else {
      if (index == currentStep - 1 && !isCurrentStepActive) {
        gradient = context.uiColors.primaryGradient;
      } else if (index < currentStep) {
        color = context.uiColors.primary;
      } else {
        color = context.uiColors.inactive;
      }
    }

    return UiGradientShaderMask(
      color: color,
      gradient: gradient,
      child: Container(
        height: 4.0,
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(2.0),
        ),
      ),
    );
  }
}
