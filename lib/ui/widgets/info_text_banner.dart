import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';

/// A stateless widget that displays a banner with an informational text message.
/// * [message] (required) - The text message to display in the banner.
/// * [textColor] (optional) - The color of the text. Defaults to [ZOColors.onPrimaryLight].
/// * [backgroundColor] (optional) - The background color of the banner. Defaults to [ZOColors.amberTransparent].
class InfoTextBanner extends StatelessWidget {
  final String message;
  final Color textColor;
  final Color backgroundColor;

  const InfoTextBanner({
    super.key,
    required this.message,
    this.textColor = ZOColors.onPrimaryLight,
    this.backgroundColor = ZOColors.amberTransparent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(WidgetStyle.padding),
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: textColor,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
