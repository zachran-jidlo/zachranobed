import 'package:flutter/widgets.dart';
import 'package:zachranobed/common/constants.dart';

/// A customizable card widget designed to display summary information with an optional tap action.
///
/// The card can be tapped to trigger an action defined by the [onPressed] callback. If [onPressed] is null, the card
/// will not respond to taps.
class BoxSummaryCard extends StatelessWidget {
  /// The content to be displayed within the card.
  final Widget child;

  /// An optional callback function that is executed when the card is tapped.
  final VoidCallback? onPressed;

  /// Creates a [BoxSummaryCard] widget.
  const BoxSummaryCard({
    super.key,
    required this.child,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: ZOColors.lightBorderColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 1, color: ZOColors.borderColor),
          boxShadow: const [
            BoxShadow(
              color: Color(0x4C000000),
              blurRadius: 2,
              offset: Offset(0, 1),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 6,
              offset: Offset(0, 4),
              spreadRadius: 2,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );
  }
}
