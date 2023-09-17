import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/ui/widgets/button.dart';

class InfoBanner extends StatelessWidget {
  final String infoText;
  final Widget infoValue;
  final ZOButton? button;

  const InfoBanner({
    super.key,
    required this.infoText,
    required this.infoValue,
    this.button,
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
                Flexible(
                  child: Text(
                    '$infoText ',
                    style: const TextStyle(
                      color: ZOColors.onPrimaryLight,
                      fontSize: FontSize.s,
                    ),
                  ),
                ),
                infoValue,
              ],
            ),
            if (button != null)
              Column(
                children: [
                  const SizedBox(height: GapSize.xs),
                  button!,
                ],
              ),
          ],
        ),
      ),
    );
  }
}
