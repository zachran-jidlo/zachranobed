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
import 'package:zachranobed/common/presentation/utils/ui_text_styles.dart';
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
            textTheme: UiTextStyles.getTextTheme(),
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
