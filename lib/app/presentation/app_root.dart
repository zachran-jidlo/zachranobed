import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/common/domain/model/app_terms_status.dart';
import 'package:zachranobed/common/domain/repository/delivery_repository.dart';
import 'package:zachranobed/common/domain/usecase/get_app_terms_status_usecase.dart';
import 'package:zachranobed/common/domain/usecase/get_user_data_usecase.dart';
import 'package:zachranobed/common/domain/utils/platform_utils.dart';
import 'package:zachranobed/common/presentation/notifiers/delivery_notifier.dart';
import 'package:zachranobed/common/presentation/notifiers/user_notifier.dart';
import 'package:zachranobed/common/presentation/router/app_router.dart';
import 'package:zachranobed/common/presentation/router/app_router.gr.dart';
import 'package:zachranobed/common/presentation/utils/lifecycle_watcher.dart';
import 'package:zachranobed/common/presentation/utils/ui_colors.dart';
import 'package:zachranobed/common/presentation/utils/ui_constants.dart';
import 'package:zachranobed/features/forceupdate/domain/usecase/check_if_upgrade_app_should_be_shown_usecase.dart';
import 'package:zachranobed/features/offline/presentation/connectivity_wrapper.dart';
import 'package:zachranobed/l10n/app_localizations.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> with LifecycleWatcher {
  final _appRouter = GetIt.I<AppRouter>();
  final _getUserData = GetIt.I<GetUserDataUseCase>();
  final _checkIfUpgradeAppShouldBeShown = GetIt.I<CheckIfUpgradeAppShouldBeShownUseCase>();
  final _getAppTermsStatus = GetIt.I<GetAppTermsStatusUseCase>();

  @override
  void initState() {
    super.initState();

    _applicationStartCheck();
  }

  @override
  void onResume() {
    _applicationStartCheck();
  }

  void _applicationStartCheck() async {
    final shouldShow = await _checkIfUpgradeAppShouldBeShown.invoke();
    if (shouldShow) {
      _appRouter.replace(const ForceUpdateRoute());
    }

    _checkAppTerms();
  }

  void _checkAppTerms() async {
    final user = await _getUserData.invoke();
    if (user == null) {
      // User is not logged in, do not check app terms
      return;
    }

    final status = await _getAppTermsStatus.invoke(user);
    if (status != AppTermsStatus.accepted) {
      _appRouter.replace(AppTermsRoute(hasNoAcceptedVersion: status == AppTermsStatus.notAccepted));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<UserNotifier>(create: (_) => UserNotifier()),
        ListenableProvider<DeliveryNotifier>(create: (_) {
          return DeliveryNotifier(GetIt.I<DeliveryRepository>());
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
              surface: Colors.white,
              surfaceTint: Colors.white,
              primaryContainer: ZOColors.secondary,
            ),
            textTheme: Typography.material2021().black.copyWith(
              // Display
              displayLarge: const TextStyle(fontSize: 57, height: 64.0 / 57.0, fontWeight: FontWeight.w400),
              displayMedium: const TextStyle(fontSize: 45, height: 52.0 / 45.0, fontWeight: FontWeight.w400),
              displaySmall: const TextStyle(fontSize: 36, height: 44.0 / 36.0, fontWeight: FontWeight.w700),
              // Headline
              headlineLarge: const TextStyle(fontSize: 32, height: 40.0 / 32.0, fontWeight: FontWeight.w700),
              headlineMedium: const TextStyle(fontSize: 28, height: 36.0 / 28.0, fontWeight: FontWeight.w400),
              headlineSmall: const TextStyle(fontSize: 24, height: 32.0 / 24.0, fontWeight: FontWeight.w400),
              // Title
              titleLarge: const TextStyle(fontSize: 22, height: 28.0 / 22.0, fontWeight: FontWeight.w700),
              titleMedium: const TextStyle(fontSize: 16, height: 24.0 / 16.0, fontWeight: FontWeight.w500),
              titleSmall: const TextStyle(fontSize: 14, height: 20.0 / 14.0, fontWeight: FontWeight.w500),
              // Body
              bodyLarge: const TextStyle(fontSize: 16, height: 24.0 / 16.0, fontWeight: FontWeight.w400),
              bodyMedium: const TextStyle(fontSize: 14, height: 20.0 / 14.0, fontWeight: FontWeight.w400),
              bodySmall: const TextStyle(fontSize: 12, height: 16.0 / 12.0, fontWeight: FontWeight.w400),
              // Label
              labelLarge: const TextStyle(fontSize: 14, height: 20.0 / 14.0, fontWeight: FontWeight.w500),
              labelMedium: const TextStyle(fontSize: 12, height: 16.0 / 12.0, fontWeight: FontWeight.w500),
              labelSmall: const TextStyle(fontSize: 11, height: 16.0 / 11.0, fontWeight: FontWeight.w700),
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
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            extensions: [
              UiColors.light,
            ],
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
