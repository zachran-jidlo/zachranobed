import 'package:auto_route/auto_route.dart';
import 'package:bloc_effects/bloc_effects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/utils/field_validation_utils.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/login/presentation/screen/bloc/login_bloc.dart';
import 'package:zachranobed/notifiers/delivery_notifier.dart';
import 'package:zachranobed/notifiers/user_notifier.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/clickable_text.dart';
import 'package:zachranobed/ui/widgets/password_text_field.dart';
import 'package:zachranobed/ui/widgets/snackbar/temporary_snackbar.dart';
import 'package:zachranobed/ui/widgets/text_field.dart';

@RoutePage()
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<LoginBloc>(
        param1: context.read<UserNotifier>(),
        param2: context.read<DeliveryNotifier>(),
      ),
      child: const LoginScreenContent(),
    );
  }
}

class LoginScreenContent extends StatefulWidget {
  const LoginScreenContent({super.key});

  @override
  State<LoginScreenContent> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreenContent> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocEffectListener<LoginBloc, LoginEffect>(
      listener: (context, effect) {
        if (!mounted) {
          return;
        }

        if (effect is NavigateToDebugScreen) {
          context.router.push(const DebugRoute());
        } else if (effect is NavigateToAppTermsScreen) {
          context.router.replace(const AppTermsRoute());
        } else if (effect is NavigateToHomeScreen) {
          context.router.replace(const HomeRoute());
        } else if (effect is ShowProgressDialog) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) =>
                const Center(child: CircularProgressIndicator()),
          );
        } else if (effect is HideProgressDialog) {
          context.router.maybePop();
        } else if (effect is ShowErrorSnackBar) {
          ScaffoldMessenger.of(context).showSnackBar(
            ZOTemporarySnackBar(
              backgroundColor: Colors.red,
              message: context.l10n!.wrongCredentialsError,
            ),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: GapSize.xl),
                SvgPicture.asset(ZOStrings.zoLogoPath, width: 270, height: 46),
                const SizedBox(height: GapSize.l),
                GestureDetector(
                  onLongPress: () {
                    context.read<LoginBloc>().add(LoginImageLongPressed());
                  },
                  child: Image.asset(
                    width: 415,
                    ZOStrings.foodImagePath,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                const SizedBox(height: GapSize.l),
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
                          onValidation: FieldValidationUtils.getEmailValidator(
                            context,
                          ),
                          onChanged: (value) {
                            context
                                .read<LoginBloc>()
                                .add(LoginEmailChanged(email: value));
                          },
                        ),
                        const SizedBox(height: GapSize.m),
                        ZOPasswordTextField(
                          text: context.l10n!.password,
                          onValidation:
                              FieldValidationUtils.getPasswordValidator(
                            context,
                          ),
                          onChanged: (value) {
                            context
                                .read<LoginBloc>()
                                .add(LoginPasswordChanged(password: value));
                          },
                        ),
                        const SizedBox(height: GapSize.l),
                        ZOButton(
                          text: context.l10n!.signIn,
                          icon: MaterialSymbols.login,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              context.read<LoginBloc>().add(LoginSubmitted());
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
          ),
        ),
      ),
    );
  }
}
