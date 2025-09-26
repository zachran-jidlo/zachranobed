import 'package:flutter/material.dart';

/// A custom app bar widget for application.
///
/// The title is displayed differently based on whether a back button is present.
/// If a back button is shown, the title is displayed below the `AppBar`. Otherwise, it's displayed directly in
/// the `AppBar` widget itself.
class ZOAppBar extends StatelessWidget {
  /// The primary text to display in the app bar.
  final String title;

  /// A list of Widgets to display in a row after the [title].
  final List<Widget>? actions;

  /// Whether to imply the leading widget. Defaults to true.
  final bool automaticallyImplyLeading;

  /// Creates a [ZOAppBar].
  const ZOAppBar({
    super.key,
    required this.title,
    this.automaticallyImplyLeading = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final hasBackButton = automaticallyImplyLeading && Navigator.canPop(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBar(
          title: !hasBackButton ? _buildTitle(context) : null,
          automaticallyImplyLeading: false,
          leading: hasBackButton ? const BackButton() : null,
          actions: actions,
        ),
        if (hasBackButton)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0),
            child: _buildTitle(context),
          )
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }
}
