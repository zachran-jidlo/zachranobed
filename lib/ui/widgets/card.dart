import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';

double _CARD_SIDE = 154.0;

class ZOCard extends StatelessWidget {
  final Future measuredValue;
  final String metricsText;
  final String periodText;

  const ZOCard({
    super.key,
    required this.measuredValue,
    required this.metricsText,
    required this.periodText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _CARD_SIDE,
      height: _CARD_SIDE,
      decoration: BoxDecoration(
        color: ZOColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 1, color: ZOColors.borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(WidgetStyle.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextWidget(metricsText, FontSize.xxs),
            // TODO - z tohodle udělat strem builder
            FutureBuilder(
              future: measuredValue,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final measuredVariable = snapshot.data;
                  return _buildTextWidget(
                    measuredVariable.toString(),
                    FontSize.xxl,
                    fontWeight: FontWeight.bold,
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('${snapshot.error}'));
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
            _buildTextWidget(periodText, FontSize.xxs),
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
        color: ZOColors.onCardBackground,
      ),
    );
  }
}
