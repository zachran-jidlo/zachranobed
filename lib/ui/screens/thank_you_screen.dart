import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zachranobed/models/offered_food.dart';
import 'package:zachranobed/routes.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/button.dart';

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final response = ModalRoute.of(context)!.settings.arguments
        as Future<DocumentReference<OfferedFood>>;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Image.asset(
                      width: 415,
                      ZOStrings.foodImagePath,
                      fit: BoxFit.fitWidth,
                    ),
                    const SizedBox(height: 80.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 45.0),
                      child: Column(
                        children: <Widget>[
                          FutureBuilder<DocumentReference<OfferedFood>>(
                            future: response,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  AppLocalizations.of(context)!.confirmation,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: FontSize.xl),
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                  AppLocalizations.of(context)!.offerError,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: FontSize.xl),
                                );
                              }

                              return const CircularProgressIndicator();
                            },
                          ),
                          const SizedBox(height: GapSize.l),
                          ZOButton(
                            text: AppLocalizations.of(context)!.backToOverview,
                            icon: MaterialSymbols.home_outlined,
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(height: GapSize.xs),
                          ZOButton(
                            text: AppLocalizations.of(context)!.newOffer,
                            icon: MaterialSymbols.add,
                            isSecondary: true,
                            onPressed: () => Navigator.of(context)
                                .pushReplacementNamed(RouteManager.offerFood),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: GapSize.xl),
                    const Spacer(),
                    SvgPicture.asset(
                      ZOStrings.zoLogoPath,
                      width: 158,
                      height: 28,
                    ),
                    const SizedBox(height: GapSize.xl),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
