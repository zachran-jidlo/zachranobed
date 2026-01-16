import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zachranobed/common/domain/utils/constants.dart';
import 'package:zachranobed/common/presentation/router/app_router.gr.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/helper_service.dart';
import 'package:zachranobed/common/presentation/utils/image_assets.dart';
import 'package:zachranobed/common/presentation/widget/adaptive_content.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/page/info_page.dart';
import 'package:zachranobed/common/presentation/widget/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/ui_checkbox.dart';
import 'package:zachranobed/features/appTerms/domain/set_newest_accepted_app_terms_usecase.dart';

/// A screen that informs the user about application terms and conditions that need to be accepted.
@RoutePage()
class AppTermsScreen extends StatefulWidget {
  /// A flag to determine if the user has no accepted version of the terms and conditions.
  ///
  /// If `true`, the screen will display the initial terms acceptance UI.
  /// If `false`, the screen will display the UI for accepting a new version of the terms.
  final bool hasNoAcceptedVersion;

  /// Creates an [AppTermsScreen].
  const AppTermsScreen({super.key, required this.hasNoAcceptedVersion});

  @override
  State<AppTermsScreen> createState() => _AppTermsScreen();
}

class _AppTermsScreen extends State<AppTermsScreen> {
  final _setNewestAcceptedAppTermsUseCase = GetIt.I<SetNewestAcceptedAppTermsUseCase>();
  var _areTermsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold.universalBuilder(
      builder: (context) {
        return switch (widget.hasNoAcceptedVersion) {
          true => InfoPage(
              image: ImageAssets.imageAppTermsNotAccepted,
              title: context.l10n.appTermsTitle,
              description: context.l10n.appTermsSubtitle,
              paddingBeforeActions: 8.0,
              actions: _buildActions(context),
            ),
          false => InfoPage(
              image: ImageAssets.imageAppTermsNewVersion,
              title: context.l10n.appTermsNewVersionTitle,
              description: context.l10n.appTermsNewVersionSubtitle,
              paddingBeforeActions: 8.0,
              actions: _buildActions(context),
            )
        };
      },
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      _buildCheckbox(),
      const SizedBox(height: 32.0),
      UiPrimaryButton(
        size: UiButtonSize.medium(fullWidth: context.watch<AdaptiveLayoutConfig>().isMobile),
        text: context.l10n.appTermsConfirm,
        onPressed: _setNewestAcceptedAppTerms,
        enabled: _areTermsAccepted,
      ),
    ];
  }

  Widget _buildCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        UiCheckbox(
          isChecked: _areTermsAccepted,
          onChanged: (value) {
            setState(() {
              _areTermsAccepted = value;
            });
          },
        ),
        Flexible(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: context.l10n.appTermsCheckboxLabelPlain,
                  style: context.textStyles.bodySmall,
                ),
                TextSpan(
                  text: context.l10n.appTermsCheckboxLabelUnderlined,
                  style: context.textStyles.bodySmall.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      await _openUrlInBrowser(Constants.urlAppTerms);
                    },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _setNewestAcceptedAppTerms() async {
    final user = HelperService.getCurrentUser(context);
    if (user == null) {
      return;
    }

    await _setNewestAcceptedAppTermsUseCase.invoke(user);
    if (mounted) {
      context.router.replace(const HomeRoute());
    }
  }

  Future<void> _openUrlInBrowser(String siteUrl) async {
    final Uri url = Uri.parse(siteUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
