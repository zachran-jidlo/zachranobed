import 'package:flutter/material.dart';

/// A simple loading page widget displaying a centered circular progress indicator.
///
/// This component provides a consistent loading state display across the application.
/// It shows a centered [CircularProgressIndicator] without any additional text or elements,
/// making it suitable for full-screen loading states where data is being fetched or
/// processed in the background.
class LoadingPage extends StatelessWidget {
  /// Creates a [LoadingPage] widget.
  const LoadingPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
