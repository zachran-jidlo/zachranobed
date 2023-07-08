import 'package:flutter/material.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/button.dart';

class InfoBanner extends StatelessWidget {
  final String infoText;
  final Widget infoValue;
  final String buttonText;
  final IconData buttonIcon;
  final VoidCallback onButtonPressed;

  const InfoBanner({
    super.key,
    required this.infoText,
    required this.infoValue,
    required this.buttonText,
    required this.buttonIcon,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: ZOColors.primaryLight,
      child: Padding(
        padding: const EdgeInsets.all(WidgetStyle.padding),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$infoText ',
                  style: const TextStyle(
                    color: ZOColors.onPrimaryLight,
                    fontSize: FontSize.s,
                  ),
                ),
                infoValue,
              ],
            ),
            const SizedBox(height: GapSize.xs),
            ZOButton(
              text: buttonText,
              icon: buttonIcon,
              fullWidth: false,
              onPressed: onButtonPressed,
            ),
          ],
        ),
      ),
    );
  }
}
