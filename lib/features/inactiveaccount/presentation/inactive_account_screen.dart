import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/common/domain/usecase/sign_out_usecase.dart';
import 'package:zachranobed/common/presentation/router/app_router.gr.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/image_assets.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/layout/adaptive_content.dart';
import 'package:zachranobed/common/presentation/widget/layout/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/page/info_page.dart';

/// A screen shown when the signed-in account has no usable entity pair.
///
/// The credentials are valid, but every pair of the account is turned off, so
/// there is nothing the user can do until an admin enables one. Signing out is
/// the only way forward, which is why the back gesture is blocked.
@RoutePage()
class InactiveAccountScreen extends StatelessWidget {
  /// The entity of the signed-in account.
  final String entityId;

  /// Creates an [InactiveAccountScreen].
  const InactiveAccountScreen({super.key, required this.entityId});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: ScreenScaffold.universalBuilder(
        builder: (context) {
          return InfoPage(
            image: ImageAssets.imageInactiveAccount,
            title: context.l10n.inactiveAccountTitle,
            description: context.l10n.inactiveAccountDescription,
            actions: [
              UiPrimaryButton(
                size: UiButtonSize.medium(fullWidth: context.watch<AdaptiveLayoutConfig>().isMobile),
                text: context.l10n.signOut,
                onPressed: () => _signOut(context),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Signs the user out and returns to the login screen.
  Future<void> _signOut(BuildContext context) async {
    final router = context.router;

    await GetIt.I<SignOutUseCase>().invoke(entityId);
    await router.replaceAll([const LoginRoute()]);
  }
}
