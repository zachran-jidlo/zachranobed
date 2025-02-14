import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/utils/store_utils.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/screen_scaffold.dart';

@RoutePage()
class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _forceUpdateScreenContent(context: context);
  }

  Widget _forceUpdateScreenContent({
    required BuildContext context,
  }) {
    return ScreenScaffold.universal(
      child: Padding(
        padding: const EdgeInsets.all(GapSize.xs),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              ZOStrings.forceUpdatePath,
              height: 266,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: GapSize.xl),
            Text(
              context.l10n!.forceUpdateScreenTitle,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GapSize.xs),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: context.l10n!.forceUpdateScreenDescriptionStart,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextSpan(
                    text: context.l10n!.applicationName,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: context.l10n!.forceUpdateScreenDescriptionEnd,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GapSize.xl),
            ZOButton(
              text: context.l10n!.forceUpdateAction,
              minimumSize: ZOButtonSize.large(),
              onPressed: () async {
                StoreUtils().openStore(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
