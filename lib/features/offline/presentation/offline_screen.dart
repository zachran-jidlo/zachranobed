import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zachranobed/common/domain/utils/platform_utils.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/image_assets.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/page/info_page.dart';
import 'package:zachranobed/common/presentation/widget/layout/screen_scaffold.dart';

/// A screen displayed when the application detects that there is no internet connectivity.
/// The button to close an application is displayed only on Android, as per iOS guidelines it is discouraged to have
/// such button, and on web it is not possible to close the application.
class OfflineScreen extends StatelessWidget {
  /// Creates a [OfflineScreen] widget.
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold.universal(
      child: Center(
        child: InfoPage(
          image: ImageAssets.imageErrorOffline,
          title: context.l10n.offlineScreenTitle,
          description: context.l10n.offlineScreenDescription,
          actions: RunningPlatform.isAndroid()
              ? [
                  UiPrimaryButton(
                    text: context.l10n.offlineScreenCloseApp,
                    size: UiButtonSize.medium(),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}
