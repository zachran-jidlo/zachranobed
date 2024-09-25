import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/domain/check_if_app_terms_should_be_shown_usecase.dart';
import 'package:zachranobed/common/helper_service.dart';
import 'package:zachranobed/common/logger/zo_logger.dart';
import 'package:zachranobed/common/utils/field_validation_utils.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/login/domain/check_if_devtools_are_enabled_usecase.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/services/auth_service.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/clickable_text.dart';
import 'package:zachranobed/ui/widgets/password_text_field.dart';
import 'package:zachranobed/ui/widgets/screen_content.dart';
import 'package:zachranobed/ui/widgets/snackbar/temporary_snackbar.dart';
import 'package:zachranobed/ui/widgets/text_field.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = GetIt.I<AuthService>();
  final _checkIfDevtoolsAreEnabledUseCase =
      GetIt.I<CheckIfDevtoolsAreEnabledUseCase>();
  final _checkIfAppTermsShouldBeShownUseCase =
      GetIt.I<CheckIfAppTermsShouldBeShownUseCase>();

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
    return Scaffold(
      body: SafeArea(
        child: AdaptiveContent(
          web: (context) {
            return Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onLongPress: showDebugScreenIfPossible,
                    // TODO (Alex) Use another image with better quality
                    child: Image.asset(
                      ZOStrings.foodImagePath,
                      fit: BoxFit.cover,
                      height: double.infinity,
                      opacity: const AlwaysStoppedAnimation(.2),
                    ),
                  ),
                ),
                Material(
                  elevation: 8,
                  child: SizedBox(
                    width: LayoutStyle.loginFormWidth.toDouble(),
                    child: Center(
                      child: _loginScreenContent(
                        showImageInForm: false,
                        padding: const EdgeInsets.all(72.0),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          mobile: (context) {
            return _loginScreenContent(
              showImageInForm: true,
            );
          },
        ),
      ),
    );
  }

  /// Builds the content of the login screen.
  ///
  /// The [showImageInForm] flag determines whether to show the image
  /// in the form.
  /// The [padding] parameter specifies the padding to add around the content.
  Widget _loginScreenContent({
    required bool showImageInForm,
    EdgeInsetsGeometry? padding,
  }) {
    return SingleChildScrollView(
      padding: padding,
      child: Column(
        children: <Widget>[
          const SizedBox(height: GapSize.xl),
          SvgPicture.asset(ZOStrings.zoLogoPath, width: 270, height: 46),
          _formImageContent(showImageInForm),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: WidgetStyle.padding,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  ZOTextField(
                    label: context.l10n!.emailAddress,
                    inputType: TextInputType.emailAddress,
                    disableAutocorrect: true,
                    controller: _emailController,
                    onValidation: FieldValidationUtils.getEmailValidator(
                      context,
                    ),
                  ),
                  const SizedBox(height: GapSize.m),
                  ZOPasswordTextField(
                    text: context.l10n!.password,
                    controller: _passwordController,
                    onValidation: FieldValidationUtils.getPasswordValidator(
                      context,
                    ),
                  ),
                  const SizedBox(height: GapSize.l),
                  ZOButton(
                    text: context.l10n!.signIn,
                    icon: MaterialSymbols.login,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _logIn();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: GapSize.m),
          ZOClickableText(
            clickableText: context.l10n!.forgotPassword,
            color: ZOColors.onPrimaryLight,
            underline: false,
            onTap: () {
              context.router.push(const ForgotPasswordRoute());
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  /// Builds the image content for the form.
  ///
  /// The [showImageInForm] parameter determines whether to show the image
  /// in the form. If set to false returns only necessary padding.
  Widget _formImageContent(bool showImageInForm) {
    if (showImageInForm) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: GapSize.l),
        child: GestureDetector(
          onLongPress: showDebugScreenIfPossible,
          child: Image.asset(
            width: double.infinity,
            ZOStrings.foodImagePath,
            fit: BoxFit.fitWidth,
          ),
        ),
      );
    }

    return const SizedBox(height: GapSize.xxl);
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

        ZOLogger.logMessage(
            "Přihlášen uživatel: ${HelperService.getCurrentUser(_formKey.currentContext!)?.debugInfo}");

        _continueToLoggedInContext();
      }
    } else {
      if (mounted) {
        context.router.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          ZOTemporarySnackBar(
            backgroundColor: Colors.red,
            message: context.l10n!.wrongCredentialsError,
          ),
        );
      }
    }
  }

  Future<void> _continueToLoggedInContext() async {
    final result = await _checkIfAppTermsShouldBeShownUseCase.invoke();

    if (!mounted) {
      return;
    }

    if (result == true) {
      context.router.replace(const AppTermsRoute());
    } else {
      context.router.replace(const HomeRoute());
    }
  }
}
