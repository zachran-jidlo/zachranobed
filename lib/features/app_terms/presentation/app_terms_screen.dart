import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/features/app_terms/domain/set_newest_accepted_app_terms_usecase.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class AppTermsScreen extends StatefulWidget {
  const AppTermsScreen({Key? key}) : super(key: key);

  @override
  State<AppTermsScreen> createState() => _AppTermsScreen();
}

class _AppTermsScreen extends State<AppTermsScreen> {
  final _setNewestAcceptedAppTermsUseCase = GetIt.I<SetNewestAcceptedAppTermsUseCase>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App terms"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                  children: <Widget>[
                    ZOButton(
                      text: "Potvrdit",
                      icon: MaterialSymbols.check,
                      onPressed: () {
                        if (mounted) {
                          _setNewestAcceptedAppTermsUseCase.setNewestAcceptedAppTerms();
                          context.router.replace(const HomeRoute());
                        }
                      },
                    ),
                  ]
              )
          ),
        ),
      ),
    );
  }
}