import 'package:flutter/widgets.dart';

/// Encapsulates configuration and UI components specific to an application flavor.
///
/// This allows different build variants (flavors) to provide unique implementations
/// for specific widgets or behaviors.
class AppFlavorData {
  /// A builder function that creates a quick login button.
  ///
  /// If `null`, the quick login button should not be displayed for this flavor.
  final Widget Function(TextEditingController usernameCtrl, TextEditingController passwordCtrl)? quickLoginButton;

  /// Creates a new instance of [AppFlavorData].
  AppFlavorData({
    this.quickLoginButton,
  });
}
