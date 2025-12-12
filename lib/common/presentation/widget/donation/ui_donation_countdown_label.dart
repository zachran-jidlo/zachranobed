import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';

/// A widget that displays a countdown timer with a descriptive label.
class UiDonationCountdownLabel extends StatelessWidget {
  /// The remaining duration to display.
  final Duration duration;

  /// The label text displayed below the countdown.
  final String label;

  /// Creates a [UiDonationCountdownLabel] widget.
  const UiDonationCountdownLabel({
    super.key,
    required this.duration,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTimeStyle = context.textStyles.headlineHeavy.copyWith(
      color: context.uiColors.textPrimary,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            _formatDuration(duration),
            style: effectiveTimeStyle,
          ),
        ),
        Text(
          label,
          style: context.textStyles.labelSmall.copyWith(
            color: context.uiColors.textSecondary,
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    final hoursStr = hours.toString().padLeft(2, '0');
    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = seconds.toString().padLeft(2, '0');

    return '$hoursStr:$minutesStr:$secondsStr';
  }
}
