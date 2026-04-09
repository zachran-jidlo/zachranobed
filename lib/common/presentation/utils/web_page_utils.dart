import 'dart:js_interop';

import 'package:flutter/foundation.dart';

@JS('window.location.assign')
external void _locationAssign(String url);

/// Navigates to the home page, triggering a full reload. No-op on non-web platforms.
void reloadWebPageToHome() {
  if (kIsWeb) _locationAssign('/');
}
