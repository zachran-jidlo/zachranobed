import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/appTerms/domain/set_newest_accepted_app_terms_usecase.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/checkbox.dart';
import 'package:zachranobed/ui/widgets/screen_scaffold.dart';
import 'package:zachranobed/ui/widgets/snackbar/temporary_snackbar.dart';

@RoutePage()
class AppTermsScreen extends StatefulWidget {
  const AppTermsScreen({Key? key}) : super(key: key);

  @override
  State<AppTermsScreen> createState() => _AppTermsScreen();
}

class _AppTermsScreen extends State<AppTermsScreen> {
  final _setNewestAcceptedAppTermsUseCase =
      GetIt.I<SetNewestAcceptedAppTermsUseCase>();
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
              SvgPicture.asset(
                ZOStrings.certificationCheckPath,
                width: 205,
                height: 294,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setNewestAcceptedAppTerms() {
    if (mounted && _areTermsAccepted) {
      _setNewestAcceptedAppTermsUseCase.invoke();
      context.router.replace(const HomeRoute());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        ZOTemporarySnackBar(
          backgroundColor: Colors.red,
          message: context.l10n!.appTermsNotAcceptedError,
        ),
      );
    }
  }

  Future<void> _openUrlInBrowser(String siteUrl) async {
    final Uri url = Uri.parse(siteUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
