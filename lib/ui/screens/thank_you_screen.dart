import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:zachranobed/routes.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/button.dart';

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final response =
        ModalRoute.of(context)!.settings.arguments as Future<http.Response>;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Image.asset(
              width: 415,
              ZachranObedStrings.foodImagePath,
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(height: 80),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FutureBuilder<http.Response>(
                      future: response,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return const Text(
                            ZachranObedStrings.confirmation,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return const Text(
                            ZachranObedStrings.offerError,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                            ),
                          );
                        }

                        return const CircularProgressIndicator();
                      },
                    ),
                    const SizedBox(height: 50.0),
                    ZachranObedButton(
                      text: 'Zpět na přehled',
                      icon: MaterialSymbols.home_outlined,
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 20.0),
                    ZachranObedButton(
                      text: 'Nová nabídka',
                      icon: MaterialSymbols.add,
                      isSecondary: true,
                      onPressed: () => Navigator.of(context)
                          .pushReplacementNamed(RouteManager.offerFood),
                    ),
                    const Spacer(),
                    SvgPicture.asset(
                      ZachranObedStrings.zjLogoPath,
                      color: ZachranObedColors.primary,
                    ),
                    const SizedBox(height: 40.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
