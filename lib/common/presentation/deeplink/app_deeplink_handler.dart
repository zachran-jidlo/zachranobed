import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:zachranobed/common/presentation/router/app_router.gr.dart';

/// Handles in-app deeplinks using the `zob://` scheme.
///
/// URLs like `zob://contacts` or `zob://notifications` are resolved to
/// the corresponding route and navigated to. Unrecognized paths are ignored.
///
/// To add a new deeplink, register it in [_routes]. Use [_DeeplinkEntry]
/// with `replaceAll: true` for tab-based destinations (e.g. home tabs)
/// that should reset the navigation stack.
///
/// Usage:
/// ```dart
/// if (!AppDeeplinkHandler.handle(context, url)) {
///   launchUrl(Uri.parse(url));
/// }
/// ```
class AppDeeplinkHandler {
  static const _scheme = 'zob://';

  /// Registry of supported deeplink paths.
  static final _routes = <String, _DeeplinkEntry>{
    'contacts': _DeeplinkEntry(() => const ContactsRoute()),
    'profile': _DeeplinkEntry(() => const ProfileRoute()),
    'history': _DeeplinkEntry(
      () => HomeRoute(initialTabIndex: 2),
      replaceAll: true,
    ),
    'notifications': _DeeplinkEntry(
      () => HomeRoute(initialTabIndex: 3),
      replaceAll: true,
    ),
  };

  /// Resolves a deeplink path to a route.
  /// Returns null if the path is not supported.
  static PageRouteInfo? resolve(String path) {
    return _routes[path]?.routeFactory();
  }

  /// Handles a URL — returns true if handled as in-app navigation.
  static bool handle(BuildContext context, String url) {
    if (!url.startsWith(_scheme)) {
      return false;
    }

    final path = url.substring(_scheme.length);
    final entry = _routes[path];
    if (entry == null) {
      return false;
    }

    final route = entry.routeFactory();
    if (entry.replaceAll) {
      context.router.replaceAll([route]);
    } else {
      context.router.push(route);
    }
    return true;
  }
}

class _DeeplinkEntry {
  final PageRouteInfo Function() routeFactory;
  final bool replaceAll;

  const _DeeplinkEntry(this.routeFactory, {this.replaceAll = false});
}
