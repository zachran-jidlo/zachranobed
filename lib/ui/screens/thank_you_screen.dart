import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/screen_scaffold.dart';

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
    return ScreenScaffold(
      centerWebLayout: false,
      web: _webLayout,
      mobile: _mobileLayout,
    );
  }

  Widget _webLayout(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          ZOStrings.foodImageBackgroundPath,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Material(
          elevation: 8,
          child: SizedBox(
            width: LayoutStyle.webBreakpoint.toDouble(),
            child: Center(
                child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: GapSize.xxl),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: GapSize.l),
                    child: _screenContent(context, useWideButton: false),
                  ),
                  const SizedBox(height: 80.0),
                  SvgPicture.asset(
                    ZOStrings.zoLogoPath,
                    width: 270,
                    height: 46,
                  ),
                  const SizedBox(height: GapSize.xxl),
                ],
              ),
            )),
          ),
        ),
      ],
    );
  }

  Widget _mobileLayout(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            children: [
              Image.asset(
                width: double.infinity,
                ZOStrings.foodImagePath,
                fit: BoxFit.fitWidth,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: GapSize.xxl,
                    vertical: GapSize.m,
                  ),
                  child: _screenContent(context, useWideButton: true),
                ),
              ),
              SvgPicture.asset(
                ZOStrings.zoLogoPath,
                width: 158,
                height: 28,
              ),
              const SizedBox(height: GapSize.xxl),
            ],
          ),
        )
      ],
    );
  }

  /// Builds the main content of the thank you screen.
  ///
  /// The [useWideButton] parameter determines whether to stretch button to
  /// screen width.
  Widget _screenContent(
    BuildContext context, {
    required bool useWideButton,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isSuccess ? message : context.l10n!.offerError,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: FontSize.xl),
        ),
        const SizedBox(height: GapSize.xl),
        ZOButton(
          text: context.l10n!.backToOverview,
          icon: MaterialSymbols.home_outlined,
          minimumSize: ZOButtonSize.large(fullWidth: useWideButton),
          onPressed: () {
            context.navigateTo(const HomeRoute());
          },
        ),
      ],
    );
  }
}
