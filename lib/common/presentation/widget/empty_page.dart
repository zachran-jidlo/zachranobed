import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zachranobed/common/presentation/utils/ui_constants.dart';

class EmptyPage extends StatelessWidget {
  final String vectorImagePath;
  final String title;
  final String? description;

  const EmptyPage({
    super.key,
    required this.vectorImagePath,
    required this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(GapSize.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              vectorImagePath,
              height: 250,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: GapSize.xl),
            Text(
              title,
              style: context.textStyles.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GapSize.xs),
            if (description != null)
              Text(
                description!,
                style: context.textStyles.bodyLarge,
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
