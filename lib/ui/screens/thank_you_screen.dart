import 'package:flutter/material.dart';
import 'package:zachranobed/constants.dart';
import 'package:zachranobed/routes.dart';
import 'package:zachranobed/ui/widgets/close_button.dart';
import 'package:zachranobed/ui/widgets/floating_button.dart';

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                ZachranObedCloseButton(),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      ZachranObedStrings.confirmation,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: ZachranObedFloatingButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(RouteManager.offerFood);
          },
        ),
      ),
    );
  }
}
