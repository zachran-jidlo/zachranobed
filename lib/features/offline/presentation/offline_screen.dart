import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/screen_scaffold.dart';

/// A screen displayed when the application detects that there is no internet connectivity.
///
/// Note: This screen is available only for mobile platforms.
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
                  ZOStrings.offlineErrorPath,
                ),
                const SizedBox(height: GapSize.xl),
                Text(
                  context.l10n!.offlineScreenTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: GapSize.xs),
                Text(
                  context.l10n!.offlineScreenDescription,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: GapSize.xl),
                ZOButton(
                  text: context.l10n!.offlineScreenCloseApp,
                  minimumSize: ZOButtonSize.medium(),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
