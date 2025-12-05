import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zachranobed/common/domain/utils/platform_utils.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/image_assets.dart';
import 'package:zachranobed/common/presentation/utils/ui_constants.dart';
import 'package:zachranobed/common/presentation/widget/button.dart';
import 'package:zachranobed/common/presentation/widget/screen_scaffold.dart';

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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(GapSize.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  ImageAssets.imageErrorOffline,
                ),
                const SizedBox(height: GapSize.xl),
                Text(
                  context.l10n.offlineScreenTitle,
                  style: context.textStyles.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: GapSize.xs),
                Text(
                  context.l10n.offlineScreenDescription,
                  style: context.textStyles.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                if (RunningPlatform.isAndroid()) ...[
                  const SizedBox(height: GapSize.xl),
                  ZOButton(
                    text: context.l10n.offlineScreenCloseApp,
                    minimumSize: ZOButtonSize.medium(),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
