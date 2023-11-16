import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zachranobed/routes/app_router.gr.dart';

class AuthGuard extends AutoRouteGuard {
  /// Determines whether the user is authenticated during the navigation.
  /// If the current user is authenticated, the navigation proceeds. If not
  /// authenticated, it replaces the current route stack with a new stack
  /// containing the [LoginRoute].
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (FirebaseAuth.instance.currentUser != null) {
      resolver.next(true);
    } else {
      router.replaceAll([const LoginRoute()]);
    }
  }
}
