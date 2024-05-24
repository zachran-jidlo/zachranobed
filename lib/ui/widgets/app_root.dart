import 'package:flutter/material.dart';
import 'package:flutter/src/services/predictive_back_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/domain/check_if_app_terms_should_be_shown_usecase.dart';
import 'package:zachranobed/common/lifecycle/lifecycle_watcher.dart';
import 'package:zachranobed/features/offeredfood/domain/repository/offered_food_repository.dart';
import 'package:zachranobed/notifiers/delivery_notifier.dart';
import 'package:zachranobed/notifiers/user_notifier.dart';
import 'package:zachranobed/routes/app_router.dart';
import 'package:zachranobed/routes/app_router.gr.dart';

class AppRoot extends StatefulWidget {
  @override
  _AppRootState createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> with LifecycleWatcher {
  final _appRouter = GetIt.I<AppRouter>();
  final _checkIfAppTermsShouldBeShownUseCase =
      GetIt.I<CheckIfAppTermsShouldBeShownUseCase>();

  @override
  void initState() {
    super.initState();

    _checkAppTerms();
  }

  @override
  void onResume() {
    _checkAppTerms();
  }

  void _checkAppTerms() {
    _checkIfAppTermsShouldBeShownUseCase.invoke().then((result) => {
          // If should be shown, replace current route with app terms.
          // Otherwise do nothing - no action from the user is required.
          if (result == true) {_appRouter.replace(AppTermsRoute())}
        });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<UserNotifier>(create: (_) => UserNotifier()),
        ListenableProvider<DeliveryNotifier>(create: (_) {
          return DeliveryNotifier(GetIt.I<OfferedFoodRepository>());
        }),
      ],
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: _appRouter.config(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('cs'),
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: ZOColors.primary,
              onPrimary: ZOColors.onPrimary,
              secondary: ZOColors.primaryLight,
              onSecondary: ZOColors.onPrimaryLight,
              background: Colors.white,
              surfaceTint: Colors.white,
              primaryContainer: ZOColors.secondary,
            ),
            scaffoldBackgroundColor: Colors.white,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            appBarTheme: const AppBarTheme(
              scrolledUnderElevation: 0,
            ),
          ),
        );
      },
    );
  }

  @override
  void handleCancelBackGesture() {
    // TODO: implement handleCancelBackGesture
  }

  @override
  void handleCommitBackGesture() {
    // TODO: implement handleCommitBackGesture
  }

  @override
  bool handleStartBackGesture(PredictiveBackEvent backEvent) {
    // TODO: implement handleStartBackGesture
    throw UnimplementedError();
  }

  @override
  void handleUpdateBackGestureProgress(PredictiveBackEvent backEvent) {
    // TODO: implement handleUpdateBackGestureProgress
  }
}
