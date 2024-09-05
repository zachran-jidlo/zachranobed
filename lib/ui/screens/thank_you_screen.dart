import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/ui/widgets/button.dart';

@RoutePage()
class ThankYouScreen extends StatelessWidget {
  final bool isSuccess;
  final String message;

  const ThankYouScreen({
    super.key,
    required this.isSuccess,
    required this.message,
  });

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
                          isSuccess
                              ? Text(
                                  message,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: FontSize.xl),
                                )
                              : Text(
                                  context.l10n!.offerError,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: FontSize.xl),
                                ),
                          const SizedBox(height: GapSize.xl),
                          ZOButton(
                            text: context.l10n!.backToOverview,
                            icon: MaterialSymbols.home_outlined,
                            onPressed: () =>
                                context.navigateTo(const HomeRoute()),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: GapSize.xxl),
                    const Spacer(),
                    SvgPicture.asset(
                      ZOStrings.zoLogoPath,
                      width: 158,
                      height: 28,
                    ),
                    const SizedBox(height: GapSize.xxl),
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
