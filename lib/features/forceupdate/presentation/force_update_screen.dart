import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/image_assets.dart';
import 'package:zachranobed/common/presentation/utils/store_utils.dart';
import 'package:zachranobed/common/presentation/widget/adaptive_content.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/page/info_page.dart';
import 'package:zachranobed/common/presentation/widget/screen_scaffold.dart';

/// A screen that notifies users when a mandatory app update is required.
///
/// This screen is displayed when the current app version is below the minimum required version
/// configured in the backend. It prevents users from accessing the app until they update to
/// a newer version from the app store.
@RoutePage()
class ForceUpdateScreen extends StatelessWidget {
  /// Creates a [ForceUpdateScreen].
  const ForceUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold.universalBuilder(
      builder: (context) {
        return InfoPage.custom(
          image: ImageAssets.imageForceUpdate,
          title: InfoPageContent.text(context.l10n.forceUpdateScreenTitle),
          description: InfoPageContent.widget(
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: context.l10n.forceUpdateScreenDescriptionStart,
                    style: context.textStyles.bodyLarge,
                  ),
                  TextSpan(
                    text: context.l10n.applicationName,
                    style: context.textStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: context.l10n.forceUpdateScreenDescriptionEnd,
                    style: context.textStyles.bodyLarge,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            UiPrimaryButton(
              size: UiButtonSize.medium(fullWidth: context.watch<AdaptiveLayoutConfig>().isMobile),
              text: context.l10n.forceUpdateAction,
              onPressed: () async {
                StoreUtils().openStore(context);
              },
            ),
          ],
        );
      },
    );
  }
}
