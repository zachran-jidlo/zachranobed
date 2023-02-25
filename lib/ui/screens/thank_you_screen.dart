import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zachranobed/routes.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/close_button.dart';
import 'package:zachranobed/ui/widgets/floating_button.dart';

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final response =
        ModalRoute.of(context)!.settings.arguments as Future<http.Response>;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const <Widget>[ZachranObedCloseButton()],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FutureBuilder<http.Response>(
                      future: response,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return const Text(
                            ZachranObedStrings.confirmation,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          );
                        } else if (snapshot.hasError) {
                          return const Text(
                            ZachranObedStrings.offerError,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          );
                        }

                        return const CircularProgressIndicator();
                      },
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
          onPressed: () => Navigator.of(context)
              .pushReplacementNamed(RouteManager.offerFood),
        ),
      ),
    );
  }
}
