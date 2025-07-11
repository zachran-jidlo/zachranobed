import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/domain/check_if_app_terms_should_be_shown_usecase.dart';
import 'package:zachranobed/common/lifecycle/lifecycle_watcher.dart';
import 'package:zachranobed/common/utils/platform_utils.dart';
import 'package:zachranobed/features/forceupdate/domain/usecase/check_if_upgrade_app_should_be_shown_usecase.dart';
import 'package:zachranobed/features/offeredfood/domain/repository/offered_food_repository.dart';
import 'package:zachranobed/features/offline/presentation/connectivity_wrapper.dart';
import 'package:zachranobed/l10n/app_localizations.dart';
import 'package:zachranobed/notifiers/delivery_notifier.dart';
import 'package:zachranobed/notifiers/user_notifier.dart';
import 'package:zachranobed/routes/app_router.dart';
import 'package:zachranobed/routes/app_router.gr.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  _AppRootState createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> with LifecycleWatcher {
  final _appRouter = GetIt.I<AppRouter>();
  final _checkIfAppTermsShouldBeShownUseCase = GetIt.I<CheckIfAppTermsShouldBeShownUseCase>();
  final _checkIfUpgradeAppShouldBeShownUseCase = GetIt.I<CheckIfUpgradeAppShouldBeShownUseCase>();

  @override
  void initState() {
    super.initState();

    _applicationStartCheck();
  }

  @override
  void onResume() {
    _applicationStartCheck();
  }

  void _applicationStartCheck() {
    _checkIfUpgradeAppShouldBeShownUseCase.invoke().then((result) {
      if (result == true) {
        _appRouter.replace(const ForceUpdateRoute());
      } else {
        _checkAppTerms();
      }
    });
  }

  void _checkAppTerms() {
    _checkIfAppTermsShouldBeShownUseCase.invoke().then((result) => {
          // If should be shown, replace current route with app terms.
          // Otherwise do nothing - no action from the user is required.
          if (result == true) {_appRouter.replace(const AppTermsRoute())}
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
          // It is not possible to use AppLocalizations here, because it is not
          // available yet. Therefore, the title is hardcoded.
          title: "Zachraň oběd",
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
            visualDensity: VisualDensity.standard,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            appBarTheme: AppBarTheme(
              // Center title only for iOS platform
              centerTitle: RunningPlatform.isIOS(),
              scrolledUnderElevation: 0,
            ),
            bottomSheetTheme: const BottomSheetThemeData(
              showDragHandle: true,
              dragHandleColor: ZOColors.outline,
            ),
            drawerTheme: DrawerThemeData(
              backgroundColor: ZOColors.cardBackground,
              surfaceTintColor: ZOColors.primary,
              shape: const Border(),
              width: LayoutStyle.navigationDrawerSize.toDouble(),
            ),
          ),
          builder: (context, child) {
            if (child == null) {
              return const SizedBox();
            }

            return ConnectivityWrapper(
              child: child,
            );
          },
        );
      },
    );
  }
}
