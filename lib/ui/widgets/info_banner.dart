import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/screen_content.dart';

class InfoBanner extends StatelessWidget {
  final Widget Function(TextAlign) message;
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
    return AdaptiveContent(
      web: _webContent,
      mobile: _mobileContent,
    );
  }

  Widget _webContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: WidgetStyle.padding),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(WidgetStyle.padding),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: message(TextAlign.start),
                ),
              ),
              _button(Axis.horizontal),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mobileContent(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(WidgetStyle.padding),
        child: Column(
          children: [
            message(TextAlign.center),
            _button(Axis.vertical),
          ],
        ),
      ),
    );
  }

  Widget _button(Axis direction) {
    if (button == null) {
      return const SizedBox();
    }

    return Flex(
      direction: direction,
      children: [
        const SizedBox(height: GapSize.xs),
        button!,
      ],
    );
  }
}
