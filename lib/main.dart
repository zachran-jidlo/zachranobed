import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/models/user.dart';
import 'package:zachranobed/routes.dart';
import 'package:zachranobed/shared/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => User.empty(),
      builder: (context, child) {
        return MaterialApp(
          initialRoute: RouteManager.wrapper,
          onGenerateRoute: RouteManager.generateRoute,
          theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: ZachranObedColors.primaryLight,
                secondary: ZachranObedColors.primaryLight,
              ),
              visualDensity: VisualDensity.adaptivePlatformDensity),
        );
      },
    );
  }
}
