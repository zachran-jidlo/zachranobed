import 'dart:js_interop';

@JS('window.location.assign')
external void _locationAssign(String url);

/// Navigates to the home page, triggering a full reload.
void reloadWebPageToHome() => _locationAssign('/');
