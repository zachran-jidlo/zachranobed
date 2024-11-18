import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/ui/widgets/adaptive_content.dart';
import 'package:zachranobed/ui/widgets/button.dart';

class InfoBanner extends StatelessWidget {
  final Widget Function(BuildContext, TextAlign) message;
  final Color backgroundColor;
  final ZOButton? button;

  const InfoBanner({
    super.key,
    required this.message,
    required this.backgroundColor,
    this.button,
  });

  InfoBanner.text({
    Key? key,
    required String message,
    required Color backgroundColor,
    Color textColor = ZOColors.onPrimaryLight,
    int maxLines = 2,
  }) : this(
          key: key,
          backgroundColor: backgroundColor,
          message: (context, textAlign) {
            final theme = Theme.of(context).textTheme;
            return Text(
              message,
              style: theme.bodyLarge?.copyWith(color: textColor),
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              textAlign: textAlign,
            );
          },
        );

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
                  child: message(context, TextAlign.start),
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
            message(context, TextAlign.center),
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
