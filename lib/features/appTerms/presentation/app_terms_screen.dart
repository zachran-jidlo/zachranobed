import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/image_assets.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/appTerms/domain/set_newest_accepted_app_terms_usecase.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/checkbox.dart';
import 'package:zachranobed/ui/widgets/screen_scaffold.dart';

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
    return ScreenScaffold.universal(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(GapSize.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ..._header(),
              const SizedBox(height: GapSize.m),
              ZOCheckbox.rich(
                isChecked: _areTermsAccepted,
                onChanged: (bool? value) {
                  setState(() {
                    _areTermsAccepted = value ?? false;
                  });
                },
                titleWidget: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: context.l10n!.appTermsCheckboxLabelPlain,
                      ),
                      TextSpan(
                        text: context.l10n!.appTermsCheckboxLabelUnderlined,
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            await _openUrlInBrowser(ZOStrings.appTerms);
                          },
                      ),
                    ],
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: GapSize.l),
              ZOButton(
                text: context.l10n!.appTermsConfirm,
                onPressed: _setNewestAcceptedAppTerms,
                enabled: _areTermsAccepted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _header() {
    if (widget.hasNoAcceptedVersion) {
      return [
        SvgPicture.asset(
          ImageAssets.imageAppTermsNotAccepted,
        ),
        const SizedBox(height: GapSize.xl),
        Text(
          context.l10n!.appTermsTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: GapSize.xs),
        Text(
          context.l10n!.appTermsSubtitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ];
    } else {
      return [
        SvgPicture.asset(
          ImageAssets.imageAppTermsNewVersion,
        ),
        const SizedBox(height: GapSize.xl),
        Text(
          context.l10n!.appTermsNewVersionTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: GapSize.xs),
        Text(
          context.l10n!.appTermsNewVersionSubtitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ];
    }
  }

  void _setNewestAcceptedAppTerms() async {
    await _setNewestAcceptedAppTermsUseCase.invoke();
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
