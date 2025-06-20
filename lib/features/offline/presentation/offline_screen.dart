import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/empty_page.dart';
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
          child: Column(
            children: [
              EmptyPage(
                vectorImagePath: ZOStrings.genericErrorPath,
                title: context.l10n!.offlineScreenTitle,
                description: context.l10n!.offlineScreenDescription,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: GapSize.xl),
                child: ZOButton(
                  text: context.l10n!.offlineScreenCloseApp,
                  minimumSize: ZOButtonSize.medium(),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
              ),
              const SizedBox(height: GapSize.xs),
            ],
          ),
        ),
      ),
    );
  }
}
