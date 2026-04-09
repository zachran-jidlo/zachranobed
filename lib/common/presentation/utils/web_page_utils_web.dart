import 'dart:js_interop';

@JS('document.baseURI')
external String get _baseUri;

@JS('window.location.assign')
external void _locationAssign(String url);

/// Navigates to the app's base URL, triggering a full reload from the home route.
/// Uses [document.baseURI] so it works at any deploy path.
void reloadWebPageToHome() => _locationAssign(_baseUri);
