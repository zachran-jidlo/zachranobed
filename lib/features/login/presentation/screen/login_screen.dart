import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/data/service/auth_service.dart';
import 'package:zachranobed/common/domain/model/app_terms_status.dart';
import 'package:zachranobed/common/domain/usecase/check_if_devtools_are_enabled_usecase.dart';
import 'package:zachranobed/common/domain/usecase/get_app_terms_status_usecase.dart';
import 'package:zachranobed/common/domain/utils/zo_logger.dart';
import 'package:zachranobed/common/presentation/model/app_flavor_data.dart';
import 'package:zachranobed/common/presentation/router/app_router.gr.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/field_validation_utils.dart';
import 'package:zachranobed/common/presentation/utils/helper_service.dart';
import 'package:zachranobed/common/presentation/utils/image_assets.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_text_button.dart';
import 'package:zachranobed/common/presentation/widget/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/snackbar/ui_temporary_snackbar.dart';
import 'package:zachranobed/common/presentation/widget/ui_card.dart';
import 'package:zachranobed/common/presentation/widget/ui_password_text_field.dart';
import 'package:zachranobed/common/presentation/widget/ui_text_field.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = GetIt.I<AuthService>();
  final _checkIfDevtoolsAreEnabledUseCase = GetIt.I<CheckIfDevtoolsAreEnabledUseCase>();
  final _getAppTermsStatusUseCase = GetIt.I<GetAppTermsStatusUseCase>();
  final _appFlavorData = GetIt.I<AppFlavorData>();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      centerWebLayout: false,
      resizeToAvoidBottomInset: false,
      backgroundColor: context.uiColors.surfaceWhite,
      web: (context) => _buildWebLayout(),
      mobile: (context) => _buildMobileLayout(),
    );
  }

  /// Builds the mobile layout with logo, background, and centered form card.
  ///
  /// Uses a Stack with:
  /// - Background layer: Logo + food image (fills entire screen)
  /// - Foreground layer: Transparent Scaffold with centered form card
  ///
  /// The Scaffold is necessary for proper keyboard resize behavior
  /// (resizeToAvoidBottomInset: true).
  Widget _buildMobileLayout() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Positioned.fill(
          child: Column(
            children: [
              const SizedBox(height: 40),
              SvgPicture.asset(
                ImageAssets.imageLogo,
                width: 270,
                height: 46,
              ),
              const SizedBox(height: 45),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImageAssets.imageFoodBackgroundSquare),
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: _buildFormCard(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Builds the web layout with full background and centered form card.
  Widget _buildWebLayout() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            ImageAssets.imageFoodBackgroundDimmed,
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.0, 0.0),
                radius: 0.8,
                colors: [
                  Colors.white.withValues(alpha: 1.0),
                  Colors.white.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 358),
            child: _buildFormCard(),
          ),
        ),
      ],
    );
  }

  /// Builds the form card with text fields and buttons.
  Widget _buildFormCard() {
    return UiCard(
      color: context.uiColors.surfaceGray,
      borderRadius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UiTextField(
              controller: _emailController,
              labelText: context.l10n.emailAddress,
              keyboardType: TextInputType.emailAddress,
              disableAutocorrect: true,
              onValidation: FieldValidationUtils.getEmailValidator(context),
            ),
            const SizedBox(height: 24),
            UiPasswordTextField(
              controller: _passwordController,
              labelText: context.l10n.password,
              onValidation: FieldValidationUtils.getPasswordValidator(context),
            ),
            const SizedBox(height: 32),
            UiPrimaryButton(
              text: context.l10n.signIn,
              size: UiButtonSize.medium(),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await _logIn();
                }
              },
            ),
            ...quickLoginWidgets(),
            const SizedBox(height: 24),
            GestureDetector(
              onLongPress: showDebugScreenIfPossible,
              child: UiTextButton(
                text: context.l10n.forgotPassword,
                size: UiButtonSize.medium(),
                onPressed: () {
                  context.router.push(const ForgotPasswordRoute());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> quickLoginWidgets() {
    final widget = _appFlavorData.quickLoginButton?.call(_emailController, _passwordController);
    if (widget == null) {
      return [];
    }

    return [
      const SizedBox(height: 24),
      widget,
    ];
  }

  void showDebugScreenIfPossible() {
    bool areDevtoolsEnabled = _checkIfDevtoolsAreEnabledUseCase.invoke();
    if (areDevtoolsEnabled) context.router.push(const DebugRoute());
  }

  Future<void> _logIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final result = await _authService.signIn(
      _emailController.text,
      _passwordController.text,
    );
    if (result != null) {
      if (mounted) {
        await HelperService.loadUserInfo(context);

        ZOLogger.logMessage("Přihlášen uživatel: ${HelperService.getCurrentUser(_formKey.currentContext!)?.debugInfo}");

        _continueToLoggedInContext();
      }
    } else {
      if (mounted) {
        context.router.pop();
        UiTemporarySnackBar.showError(context, message: context.l10n.wrongCredentialsError);
      }
    }
  }

  Future<void> _continueToLoggedInContext() async {
    final user = HelperService.getCurrentUser(context);
    if (user == null) {
      // Invalid user, should not happen
      return;
    }

    final status = await _getAppTermsStatusUseCase.invoke(user);

    if (!mounted) {
      return;
    }

    if (status != AppTermsStatus.accepted) {
      context.router.replace(AppTermsRoute(hasNoAcceptedVersion: status == AppTermsStatus.notAccepted));
    } else {
      context.router.replace(const HomeRoute());
    }
  }
}
