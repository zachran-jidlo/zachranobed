import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:zachranobed/features/offline/presentation/offline_screen.dart';

/// A widget that wraps its [child] with connectivity-aware functionality.
///
/// It listens to network connectivity changes and displays an [OfflineScreen] as an overlay when the device is offline.
/// When connectivity is restored, the [OfflineScreen] is removed.
class ConnectivityWrapper extends StatefulWidget {
  /// The primary content to display when the device is online.
  final Widget child;

  /// Creates a [ConnectivityWrapper] widget.
  const ConnectivityWrapper({super.key, required this.child});

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();

    // Listen for connectivity changes
    _subscription = Connectivity().onConnectivityChanged.listen(_checkResult);

    // Check initial connectivity
    Connectivity().checkConnectivity().then(_checkResult);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _checkResult(List<ConnectivityResult> result) {
    final offline = result.contains(ConnectivityResult.none);
    if (offline != _isOffline) {
      setState(() => _isOffline = offline);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: AnimatedCrossFade(
        duration: const Duration(milliseconds: 300),
        firstChild: const OfflineScreen(),
        secondChild: widget.child,
        crossFadeState: _isOffline ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      ),
    );
  }
}
