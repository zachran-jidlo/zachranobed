import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/common/presentation/router/app_router.gr.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/image_assets.dart';
import 'package:zachranobed/common/presentation/utils/ui_constants.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/other/adaptive_content.dart';
import 'package:zachranobed/common/presentation/widget/screen_scaffold.dart';

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
      backgroundColor: context.uiColors.surfaceWhite,
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
          ImageAssets.imageFoodBackgroundDimmed,
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
                    const SizedBox(height: 48.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: _screenContent(context),
                    ),
                    const SizedBox(height: 80.0),
                    SvgPicture.asset(
                      ImageAssets.imageLogo,
                      width: 270,
                      height: 46,
                    ),
                    const SizedBox(height: 48.0),
                  ],
                ),
              ),
            ),
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
                ImageAssets.imageFoodBackground,
                fit: BoxFit.fitWidth,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48.0,
                    vertical: 24.0,
                  ),
                  child: _screenContent(context),
                ),
              ),
              SvgPicture.asset(
                ImageAssets.imageLogo,
                width: 158,
                height: 28,
              ),
              const SizedBox(height: 48.0),
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
  Widget _screenContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isSuccess ? message : context.l10n.offerError,
          textAlign: TextAlign.center,
          style: context.textStyles.headlineMedium,
        ),
        const SizedBox(height: 40.0),
        UiPrimaryButton(
          size: UiButtonSize.medium(fullWidth: context.watch<AdaptiveLayoutConfig>().isMobile),
          text: context.l10n.backToOverview,
          onPressed: () {
            context.navigateTo(const HomeRoute());
          },
        ),
      ],
    );
  }
}
