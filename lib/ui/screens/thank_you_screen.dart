import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:zachranobed/routes.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/button.dart';

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final response =
        ModalRoute.of(context)!.settings.arguments as Future<http.Response>;

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
                          FutureBuilder<http.Response>(
                            future: response,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return const Text(
                                  ZOStrings.confirmation,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: FontSize.xl),
                                );
                              } else if (snapshot.hasError) {
                                return const Text(
                                  ZOStrings.offerError,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: FontSize.xl),
                                );
                              }

                              return const CircularProgressIndicator();
                            },
                          ),
                          const SizedBox(height: GapSize.l),
                          ZOButton(
                            text: ZOStrings.backToOverview,
                            icon: MaterialSymbols.home_outlined,
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(height: GapSize.xs),
                          ZOButton(
                            text: ZOStrings.newOffer,
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
