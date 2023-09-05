import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/models/offered_food.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/button.dart';

@RoutePage()
class ThankYouScreen extends StatelessWidget {
  final DocumentReference<OfferedFood>? response;

  const ThankYouScreen({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
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
                          response != null
                              ? Text(
                                  context.l10n!.confirmation,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: FontSize.xl),
                                )
                              : Text(
                                  context.l10n!.offerError,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: FontSize.xl),
                                ),
                          const SizedBox(height: GapSize.l),
                          ZOButton(
                            text: context.l10n!.backToOverview,
                            icon: MaterialSymbols.home_outlined,
                            onPressed: () => Navigator.pop(context),
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
