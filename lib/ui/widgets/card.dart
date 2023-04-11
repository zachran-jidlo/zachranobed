import 'package:flutter/material.dart';
import 'package:zachranobed/shared/constants.dart';

double _CARD_SIDE = 154.0;

class ZachranObedCard extends StatelessWidget {
  final String metricsText;
  final String measuredVariableText;
  final String periodText;

  const ZachranObedCard({
    Key? key,
    required this.metricsText,
    required this.measuredVariableText,
    required this.periodText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _CARD_SIDE,
      height: _CARD_SIDE,
      decoration: BoxDecoration(
        color: ZachranObedColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 1,
          color: ZachranObedColors.borderColor,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextWidget(metricsText, 12.0),
            _buildTextWidget(
              measuredVariableText,
              36.0,
              fontWeight: FontWeight.bold,
            ),
            _buildTextWidget(periodText, 12.0),
          ],
        ),
      ),
    );
  }

  Widget _buildTextWidget(
    String text,
    double fontSize, {
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: ZachranObedColors.onCardBackground,
      ),
    );
  }
}
