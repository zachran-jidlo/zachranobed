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
/// The credentials are valid, but the account either has no pair at all or
/// every pair of it is turned off, so there is nothing the user can do until an
/// admin sets one up. Signing out is the only way forward, which is why the
/// back gesture is blocked.
@RoutePage()
class InactiveAccountScreen extends StatelessWidget {
  /// The entity of the signed-in account. Null when the account has no pair,
  /// because the entity is not resolved in that case.
  final String? entityId;

  /// Creates an [InactiveAccountScreen].
  const InactiveAccountScreen({super.key, this.entityId});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold.universalBuilder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: InfoPage(
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
          ),
        );
      },
    );
  }

  /// Signs the user out and returns to the login screen.
  Future<void> _signOut(BuildContext context) async {
    final router = context.router;

    await GetIt.I<SignOutUseCase>().invoke(entityId);
    await router.replaceAll([const LoginRoute()]);
  }
}
