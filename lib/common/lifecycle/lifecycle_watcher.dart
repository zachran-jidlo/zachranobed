import 'dart:ui';

import 'package:flutter/widgets.dart';

/// A mixin that provides lifecycle watching capabilities to a [StatefulWidget]'s State.
/// It implements [WidgetsBindingObserver] to observe lifecycle changes and provides
/// hooks for these changes. This allows for a clean and organized way to respond to
/// lifecycle events without cluttering the main State class.
mixin LifecycleWatcher<T extends StatefulWidget> on State<T>
    implements WidgetsBindingObserver {
  /// Registers the observer on initState.
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  /// Removes the observer on dispose to prevent memory leaks.
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Responds to lifecycle changes by calling respective methods for each state.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResume();
        break;
      case AppLifecycleState.inactive:
        onInactive();
        break;
      case AppLifecycleState.paused:
        onPause();
        break;
      case AppLifecycleState.detached:
        onDetach();
        break;
      case AppLifecycleState.hidden:
        onHide();
        break;
    }
  }

  /// Called when the app is in an resumed state.
  void onResume() {}

  /// Called when the app is in an inactive state.
  void onInactive() {}

  /// Called when the app is paused.
  void onPause() {}

  /// Called before the app is detached.
  void onDetach() {}

  /// Called when the app is hidden, but not closed.
  void onHide() {}

  /// Default implementation to deny pop route requests.
  @override
  Future<bool> didPopRoute() async => false;

  /// Default implementation to deny push route requests.
  @override
  Future<bool> didPushRoute(String route) async => false;

  /// Default implementation to deny push route information requests.
  @override
  Future<bool> didPushRouteInformation(
          RouteInformation routeInformation) async =>
      false;

  /// Default implementation for app exit requests. Can be overridden to handle exit logic.
  @override
  Future<AppExitResponse> didRequestAppExit() async => AppExitResponse.exit;

  /// Placeholder for locale change handling.
  @override
  void didChangeLocales(List<Locale>? locales) {}

  /// Placeholder for accessibility feature change handling.
  @override
  void didChangeAccessibilityFeatures() {}

  /// Placeholder for metrics change handling, like rotation or resizing.
  @override
  void didChangeMetrics() {}

  /// Placeholder for platform brightness change handling, like theme changes.
  @override
  void didChangePlatformBrightness() {}

  /// Placeholder for text scale factor change handling.
  @override
  void didChangeTextScaleFactor() {}

  /// Placeholder for memory pressure handling, useful for releasing resources.
  @override
  void didHaveMemoryPressure() {}
}
