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
import 'package:zachranobed/common/presentation/widget/layout/adaptive_content.dart';
import 'package:zachranobed/common/presentation/widget/layout/screen_scaffold.dart';

/// A screen displayed after completing a food delivery flow.
///
/// Shows a thank you message on success or an error message on failure,
/// along with a button to navigate back to the home screen.
///
/// The screen has different layouts optimized for web and mobile:
/// - **Web**: Centered card with dimmed food background image
/// - **Mobile**: Full-width layout with food background image at the top
@RoutePage()
class ThankYouScreen extends StatelessWidget {
  /// Whether the operation completed successfully.
  ///
  /// When `true`, displays the provided [message].
  /// When `false`, displays a localized error message.
  final bool isSuccess;

  /// The message to display when [isSuccess] is `true`.
  ///
  /// This is typically a thank you or confirmation message.
  /// Ignored when [isSuccess] is `false`.
  final String message;

  /// Creates a thank you screen.
  ///
  /// Both [isSuccess] and [message] are required parameters.
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

  /// Builds the web-specific layout with a centered card on a dimmed background.
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

  /// Builds the mobile-specific layout with a top image and scrollable content.
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

  /// Builds the shared content used by both web and mobile layouts.
  ///
  /// Contains the message text and a button to navigate back to home.
  /// The button width adapts based on the current layout (full-width on mobile).
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
            context.navigateTo(HomeRoute());
          },
        ),
      ],
    );
  }
}
