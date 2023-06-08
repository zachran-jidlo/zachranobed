import 'package:flutter/material.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/button.dart';

class InfoBanner extends StatelessWidget {
  final String infoText;
  final Widget infoValue;
  final String buttonText;
  final IconData buttonIcon;

  const InfoBanner({
    super.key,
    required this.infoText,
    required this.infoValue,
    required this.buttonText,
    required this.buttonIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: ZachranObedColors.primaryLight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$infoText ',
                  style: const TextStyle(
                    color: ZachranObedColors.onPrimaryLight,
                    fontSize: 16.0,
                  ),
                ),
                infoValue,
              ],
            ),
            const SizedBox(height: 15),
            ZachranObedButton(
              text: buttonText,
              icon: buttonIcon,
              fullWidth: false,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
