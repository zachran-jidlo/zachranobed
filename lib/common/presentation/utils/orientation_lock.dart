import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zachranobed/common/domain/utils/platform_utils.dart';
import 'package:zachranobed/common/presentation/utils/ui_constants.dart';

/// Keeps small screens in portrait and lets large screens rotate freely.
///
/// Android 16 and newer ignore a portrait request on displays with a shortest
/// side of [LayoutStyle.largeScreenBreakpoint] or more. The system letterboxes
/// the portrait window instead, which leaves black bars around the app. On
/// those devices we stop asking for portrait so the UI can use the whole
/// display.
class OrientationLock extends StatefulWidget {
  /// The widget below this one in the tree.
  final Widget child;

  /// Creates a new [OrientationLock] widget.
  const OrientationLock({super.key, required this.child});

  @override
  State<OrientationLock> createState() => _OrientationLockState();
}

class _OrientationLockState extends State<OrientationLock> {
  bool? _isLargeScreen;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (RunningPlatform.isWeb()) {
      return;
    }

    // The shortest side stays the same when the device rotates, so the lock
    // cannot flip itself mid-rotation. It still reacts to a foldable opening.
    final isLargeScreen = MediaQuery.sizeOf(context).shortestSide >= LayoutStyle.largeScreenBreakpoint;
    if (isLargeScreen == _isLargeScreen) {
      return;
    }
    _isLargeScreen = isLargeScreen;

    SystemChrome.setPreferredOrientations(
      isLargeScreen
          ? DeviceOrientation.values
          : const [
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
            ],
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
