import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:styled_text/styled_text.dart';
import 'package:zachranobed/common/domain/utils/platform_utils.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/image_assets.dart';
import 'package:zachranobed/common/presentation/utils/store_utils.dart';
import 'package:zachranobed/common/presentation/utils/web_page_utils.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/layout/adaptive_content.dart';
import 'package:zachranobed/common/presentation/widget/layout/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/page/info_page.dart';

/// A screen that notifies users when a mandatory app update is required.
///
/// This screen is displayed when the current app version is below the minimum required version
/// configured in the backend. It prevents users from accessing the app until they update to
/// a newer version from the app store.
///
/// Uses [InfoPage.rich] with rich text formatting to emphasize the application name in bold.
@RoutePage()
class ForceUpdateScreen extends StatelessWidget {
  /// Creates a [ForceUpdateScreen].
  const ForceUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold.universalBuilder(
      builder: (context) {
        return InfoPage.rich(
          image: ImageAssets.imageForceUpdate,
          title: InfoPageContent.text(context.l10n.forceUpdateScreenTitle),
          description: InfoPageContent.widget(
            StyledText(
              text: context.l10n.forceUpdateScreenDescription,
              style: context.textStyles.bodyLarge,
              textAlign: TextAlign.center,
              tags: {
                'b': StyledTextTag(
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              },
            ),
          ),
          actions: [
            UiPrimaryButton(
              size: UiButtonSize.medium(fullWidth: context.watch<AdaptiveLayoutConfig>().isMobile),
              text: RunningPlatform.isWeb() ? context.l10n.forceUpdateWebAction : context.l10n.forceUpdateAction,
              onPressed: () async {
                if (RunningPlatform.isWeb()) {
                  reloadWebPageToHome();
                } else {
                  StoreUtils().openStore(context);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
