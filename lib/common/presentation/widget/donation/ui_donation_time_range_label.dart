import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';

/// A widget that displays a time range with superscripted minutes and a descriptive label.
class UiDonationTimeRangeLabel extends StatelessWidget {
  /// The start time of the range.
  final TimeOfDay startTime;

  /// The end time of the range.
  final TimeOfDay endTime;

  /// The label text displayed below the time range.
  final String label;

  /// Optional text style for the time display.
  ///
  /// If not provided, defaults to [context.textStyles.headlineLarge] with primary text color.
  final TextStyle? timeStyle;

  /// Creates a [UiDonationTimeRangeLabel] widget.
  const UiDonationTimeRangeLabel({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.label,
    this.timeStyle,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTimeStyle = timeStyle ??
        context.textStyles.headlineHeavy.copyWith(
          color: context.uiColors.textPrimary,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text.rich(
            style: effectiveTimeStyle,
            TextSpan(
              children: [
                TextSpan(text: _formatHour(startTime.hour)),
                _buildSuperscriptMinutes(effectiveTimeStyle, startTime.minute),
                const TextSpan(text: ' - '),
                TextSpan(text: _formatHour(endTime.hour)),
                _buildSuperscriptMinutes(effectiveTimeStyle, endTime.minute),
              ],
            ),
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

  String _formatHour(int hour) {
    return hour.toString();
  }

  String _formatMinute(int minute) {
    return minute.toString().padLeft(2, '0');
  }

  WidgetSpan _buildSuperscriptMinutes(TextStyle baseStyle, int minute) {
    return WidgetSpan(
      alignment: PlaceholderAlignment.top,
      child: Transform.translate(
        offset: const Offset(0, 2),
        child: Text(
          _formatMinute(minute),
          style: baseStyle.copyWith(
            fontSize: (baseStyle.fontSize ?? 0.0) / 2.0,
          ),
        ),
      ),
    );
  }
}
