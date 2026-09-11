import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/domain/usecase/check_if_devtools_are_enabled_usecase.dart';
import 'package:zachranobed/common/domain/usecase/notify_user_data_changed_usecase.dart';
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
import 'package:zachranobed/common/presentation/widget/card/ui_card.dart';
import 'package:zachranobed/common/presentation/widget/form/ui_password_text_field.dart';
import 'package:zachranobed/common/presentation/widget/form/ui_text_field.dart';
import 'package:zachranobed/common/presentation/widget/layout/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/overlay/ui_temporary_snackbar.dart';
import 'package:zachranobed/features/login/domain/usecase/sign_in_usecase.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _signIn = GetIt.I<SignInUseCase>();
  final _notifyUserDataChanged = GetIt.I<NotifyUserDataChangedUseCase>();
  final _checkIfDevtoolsAreEnabledUseCase = GetIt.I<CheckIfDevtoolsAreEnabledUseCase>();
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
              semanticsIdentifier: 'login_email_field',
            ),
            const SizedBox(height: 24),
            UiPasswordTextField(
              controller: _passwordController,
              labelText: context.l10n.password,
              onValidation: FieldValidationUtils.getPasswordValidator(context),
              semanticsIdentifier: 'login_password_field',
            ),
            const SizedBox(height: 32),
            UiPrimaryButton(
              text: context.l10n.signIn,
              size: UiButtonSize.medium(),
              semanticsIdentifier: 'login_submit_button',
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

    final success = await _signIn.invoke(
      _emailController.text,
      _passwordController.text,
    );
    if (success) {
      if (mounted) {
        final loaded = await HelperService.loadUserInfo(context);
        if (!loaded) {
          if (mounted) {
            context.router.pop();
            UiTemporarySnackBar.showError(context, message: context.l10n.somethingWentWrongError);
          }
          return;
        }

        final user = HelperService.getCurrentUser(_formKey.currentContext!);
        ZOLogger.logMessage("Přihlášen uživatel: ${user?.debugInfo}");

        _notifyUserDataChanged.invoke(user);

        // An inactive account is redirected by the user data listener. Doing it
        // here as well would leave a duplicate entry in the history.
        if (user != null && !user.isAccountActive) {
          return;
        }

        if (mounted) {
          // Navigate explicitly instead of leaving it to the user data
          // listener, otherwise this call could land after its redirect.
          if (user == null) {
            // Sign-in succeeded, so missing user data means the account has no
            // pair to work with. The listener gets a null user as well, but it
            // cannot tell this apart from a signed-out one.
            context.router.replaceAll([InactiveAccountRoute()]);
          } else {
            context.router.replaceAll([HomeRoute()]);
          }
        }
      }
    } else {
      if (mounted) {
        context.router.pop();
        UiTemporarySnackBar.showError(context, message: context.l10n.wrongCredentialsError);
      }
    }
  }
}
