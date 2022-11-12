import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zachranobed/constants.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/checkbox.dart';
import 'package:zachranobed/ui/widgets/clickableText.dart';
import 'package:zachranobed/ui/widgets/textField.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  bool _rememberUser = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SvgPicture.asset(
                    ZachranObedStrings.zjLogoPath,
                    color: ZachranObedColors.primary,
                  ),
                  const SizedBox(height: 20),

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 2)
                    ),
                    child: Image.asset(
                      ZachranObedStrings.placeholderImagePath,

                    ),
                  ),
                  const SizedBox(height: 20),

                  ZachranObedTextField(
                    text: ZachranObedStrings.emailAddress,
                  ),
                  const SizedBox(height: 15),

                  ZachranObedTextField(
                    text: ZachranObedStrings.password,
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),

                  ZachranObedCheckbox(
                    text: ZachranObedStrings.rememberUser,
                    isChecked: _rememberUser,
                    whatIsChecked: (bool value) => setState(() {
                      _rememberUser = value;
                      print(_rememberUser);
                    })
                  ),

                  ZachranObedButton(
                    text: ZachranObedStrings.login.toUpperCase(),
                    onPressed: () {
                      print('Logged in!');
                    },
                  ),
                  const SizedBox(height: 15),

                  ZachranObedClickableText(
                    text: ZachranObedStrings.forgottenPassword,
                    onTap: () {
                      print('Change password');
                    }
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
