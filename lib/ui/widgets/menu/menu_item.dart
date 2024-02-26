import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';

class MenuItem extends StatelessWidget {
  final IconData? leadingIcon;
  final String text;
  final VoidCallback? onPressed;
  final bool isVisible;

  const MenuItem({
    super.key,
    this.leadingIcon,
    required this.text,
    this.onPressed,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    return isVisible
        ? InkWell(
            onTap: onPressed,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: ZOColors.cardBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: WidgetStyle.padding,
                ),
                child: Row(
                  children: [
                    if (leadingIcon != null) ...[
                      Icon(leadingIcon),
                      const SizedBox(width: GapSize.xs),
                    ],
                    const SizedBox(width: GapSize.xs),
                    Text(text, style: const TextStyle(fontSize: FontSize.s)),
                    const Spacer(),
                    onPressed != null
                        ? const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          )
        : const SizedBox(); // Return an empty SizedBox when not visible
  }
}
