import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zachranobed/constants.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/textField.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                SizedBox(height: 35),
                SvgPicture.asset(
                  ZachranObedStrings.zjLogoPath,
                  color: ZachranObedColors.primary,
                ),
                SizedBox(height: 20),

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 2)
                  ),
                  child: Image.asset(
                    ZachranObedStrings.placeholderImagePath,

                  ),
                ),
                SizedBox(height: 20),

                ZachranObedTextField(
                    text: ZachranObedStrings.emailAddress,
                ),
                SizedBox(height: 15),

                ZachranObedTextField(
                    text: ZachranObedStrings.password,
                    obscureText: true,
                ),
                SizedBox(height: 10),

                ZachranObedButton(
                  text: ZachranObedStrings.login.toUpperCase(),
                  onPressed: () {
                    print('Logged in!');
                  },
                ),
                SizedBox(height: 15),

                RichText(
                  text: TextSpan(
                      text: ZachranObedStrings.forgottenPassword,
                      style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                        print('Change password');
                      }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
