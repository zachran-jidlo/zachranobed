import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/notifiers/delivery_notifier.dart';
import 'package:zachranobed/notifiers/user_notifier.dart';
import 'package:zachranobed/routes.dart';
import 'package:zachranobed/shared/constants.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<UserNotifier>(create: (_) => UserNotifier()),
        ListenableProvider<DeliveryNotifier>(create: (_) => DeliveryNotifier()),
      ],
      builder: (context, child) {
        return MaterialApp(
          initialRoute: RouteManager.wrapper,
          onGenerateRoute: RouteManager.generateRoute,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: ZachranObedColors.primary,
              onPrimary: ZachranObedColors.onPrimary,
              secondary: ZachranObedColors.primaryLight,
              onSecondary: ZachranObedColors.onPrimaryLight,
              background: Colors.white,
            ),
            scaffoldBackgroundColor: Colors.white,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: const AppBarTheme(
              scrolledUnderElevation: 0,
            ),
          ),
        );
      },
    );
  }
}
