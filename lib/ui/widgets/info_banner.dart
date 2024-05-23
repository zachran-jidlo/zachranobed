import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/ui/widgets/button.dart';

class InfoBanner extends StatelessWidget {
  final Widget message;
  final Color backgroundColor;
  final ZOButton? button;

  const InfoBanner({
    super.key,
    required this.message,
    required this.backgroundColor,
    this.button,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(WidgetStyle.padding),
        child: Column(
          children: [
            message,
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
