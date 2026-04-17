import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/common/domain/model/app_terms_status.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/domain/repository/delivery_repository.dart';
import 'package:zachranobed/common/domain/usecase/get_app_terms_status_usecase.dart';
import 'package:zachranobed/common/domain/usecase/get_user_data_usecase.dart';
import 'package:zachranobed/common/domain/usecase/notify_user_data_changed_usecase.dart';
import 'package:zachranobed/common/domain/usecase/observe_user_data_usecase.dart';
import 'package:zachranobed/common/domain/usecase/remove_onboarding_for_ui_changes_flag_usecase.dart';
import 'package:zachranobed/common/domain/usecase/should_show_onboarding_for_ui_changes_usecase.dart';
import 'package:zachranobed/common/domain/usecase/update_device_info_usecase.dart';
import 'package:zachranobed/common/domain/utils/platform_utils.dart';
import 'package:zachranobed/common/presentation/notifiers/delivery_notifier.dart';
import 'package:zachranobed/common/presentation/notifiers/user_notifier.dart';
import 'package:zachranobed/common/presentation/router/app_router.dart';
import 'package:zachranobed/common/presentation/router/app_router.gr.dart';
import 'package:zachranobed/common/presentation/utils/lifecycle_watcher.dart';
import 'package:zachranobed/common/presentation/utils/ui_colors.dart';
import 'package:zachranobed/common/presentation/utils/ui_text_styles.dart';
import 'package:zachranobed/features/forceupdate/domain/usecase/check_if_upgrade_app_should_be_shown_usecase.dart';
import 'package:zachranobed/features/forceupdate/presentation/web_soft_update_banner.dart';
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
  final _notifyUserDataChanged = GetIt.I<NotifyUserDataChangedUseCase>();
  final _observeUserData = GetIt.I<ObserveUserDataUseCase>();
  final _checkIfUpgradeAppShouldBeShown = GetIt.I<CheckIfUpgradeAppShouldBeShownUseCase>();
  final _getAppTermsStatus = GetIt.I<GetAppTermsStatusUseCase>();
  final _shouldShowOnboardingForUiChanges = GetIt.I<ShouldShowOnboardingForUiChangesUseCase>();
  final _removeOnboardingForUiChangesFlag = GetIt.I<RemoveOnboardingForUiChangesFlagUseCase>();
  final _updateDeviceInfo = GetIt.I<UpdateDeviceInfoUseCase>();

  // Held as a field so it can be accessed from stream listeners (no context needed).
  final _userNotifier = UserNotifier();
  final _deliveryNotifier = DeliveryNotifier(GetIt.I<DeliveryRepository>());

  StreamSubscription<void>? _userDataSubscription;
  UserData? _previousUserData;
  DateTime? _deviceInfoLastUpdated;

  @override
  void initState() {
    super.initState();

    _userDataSubscription = _observeUserData.invoke().listen((user) {
      final previous = _previousUserData;
      _previousUserData = user;

      if (user != null) {
        _applicationStartCheckForUser(user);
      } else {
        _userNotifier.user = null;
        _deliveryNotifier.reset();
        _deviceInfoLastUpdated = null;
        if (previous != null) {
          _appRouter.replaceAll([const LoginRoute()]);
        }
      }
    });

    _applicationStartCheck();
  }

  @override
  void dispose() {
    _userDataSubscription?.cancel();
    _userNotifier.dispose();
    _deliveryNotifier.dispose();
    super.dispose();
  }

  @override
  void onResume() {
    _applicationStartCheck();
  }

  /// Performs the initial checks after the application starts.
  /// 1. Check if the app should be updated.
  /// 2. Perform for user-related checks, see [_applicationStartCheckForUser].
  void _applicationStartCheck() async {
    final shouldShow = await _checkIfUpgradeAppShouldBeShown.invoke();
    if (shouldShow) {
      _appRouter.replace(const ForceUpdateRoute());
    }

    final user = await _getUserData.invoke();
    if (user != null) {
      _notifyUserDataChanged.invoke(user);
    }
  }

  /// Performs the initial checks after the application starts.
  /// 1. Update the device info (ID, app version, platform) — at most once per 24 hours.
  /// 2. Check if the app terms are accepted.
  /// 3. Check if the onboarding for UI changes should be shown.
  void _applicationStartCheckForUser(UserData user) async {
    final now = DateTime.now();
    final lastUpdated = _deviceInfoLastUpdated;
    if (lastUpdated == null || now.difference(lastUpdated) >= const Duration(hours: 24)) {
      _deviceInfoLastUpdated = now;
      _updateDeviceInfo.invoke(user.entityId);
    }

    final status = await _getAppTermsStatus.invoke(user);
    if (status != AppTermsStatus.accepted) {
      _appRouter.replace(AppTermsRoute(hasNoAcceptedVersion: status == AppTermsStatus.notAccepted));
      return;
    }

    final shouldShowOnboarding = await _shouldShowOnboardingForUiChanges.invoke(user.entityId);
    if (shouldShowOnboarding) {
      await _removeOnboardingForUiChangesFlag.invoke(user.entityId);
      _appRouter.push(const WhatsNewRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<UserNotifier>.value(value: _userNotifier),
        ListenableProvider<DeliveryNotifier>.value(value: _deliveryNotifier),
      ],
      builder: (context, child) {
        return MaterialApp.router(
          // It is not possible to use AppLocalizations here, because it is not
          // available yet. Therefore, the title is hardcoded.
          title: "Zachraň oběd",
          routerConfig: _appRouter.config(
            navigatorObservers: () => [
              FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
            ],
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('cs'),
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: UiColors.light.primary,
              onPrimary: UiColors.light.textPrimaryInverse,
              secondary: UiColors.light.primary,
              onSecondary: UiColors.light.textPrimaryInverse,
              surface: UiColors.light.surfaceWhite,
              surfaceTint: UiColors.light.surfaceWhite,
            ),
            textTheme: UiTextStyles.getTextTheme(),
            scaffoldBackgroundColor: UiColors.light.surfaceWhite,
            visualDensity: VisualDensity.standard,
            highlightColor: UiColors.light.transparent,
            splashColor: UiColors.light.transparent,
            appBarTheme: AppBarTheme(
              // Center title only for iOS platform
              centerTitle: RunningPlatform.isIOS(),
              scrolledUnderElevation: 0,
            ),
            bottomSheetTheme: BottomSheetThemeData(
              showDragHandle: true,
              dragHandleColor: UiColors.light.textSecondary,
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

            return SoftUpdateWebBanner(
              child: ConnectivityWrapper(
                child: child,
              ),
            );
          },
        );
      },
    );
  }
}
