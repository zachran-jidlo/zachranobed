import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/features/app_terms/domain/set_newest_accepted_app_terms_usecase.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:zachranobed/ui/widgets/checkbox.dart';
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(GapSize.xl),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(ZOStrings.certificationCheckPath, width: 205, height: 294),
                  SizedBox(height: GapSize.xl),
                  Text(
                    'Než budete pokračovat,', // FIXME: - Localize
                    style: TextStyle(fontSize: FontSize.m),
                  ),
                  SizedBox(height: GapSize.xs),
                  Text(
                    'tak bychom od vás potřebovali souhlas s podmínkami s účastí na projektu.', // FIXME: - Localize
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: FontSize.s),
                  ),
                  SizedBox(height: GapSize.m),
                  ZOCheckbox.rich(
                      isChecked: _areTermsAccepted,
                      onChanged: (bool? value) {
                        setState(() {
                          _areTermsAccepted = value ?? false;
                        });
                      },
                      titleWidget: RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Souhlasím s ', // FIXME: - Localize
                                    style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                  text: 'podmínkami účasti na projektu.', // FIXME: - Localize
                                  style: TextStyle(
                                      color: Colors.black,
                                      decoration: TextDecoration.underline
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      await _openUrlInBrowser(ZOStrings.appTerms);
                                    },
                                ),
                              ]
                          )
                      )
                  ),
                  SizedBox(height: GapSize.l),
                  ZOButton(
                    text: 'Pokračovat do aplikace', // FIXME: - Localize
                    onPressed: _setNewestAcceptedAppTerms,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _setNewestAcceptedAppTerms() {
    if (mounted && _areTermsAccepted) {
      _setNewestAcceptedAppTermsUseCase.setNewestAcceptedAppTerms();
      context.router.replace(const HomeRoute());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        ZOTemporarySnackBar(
          backgroundColor: Colors.red,
          message: "Pro pokračování do aplikace musíte nejdříve souhlasit s podmínkami účasti na projektu.", // FIXME: - Localize
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
