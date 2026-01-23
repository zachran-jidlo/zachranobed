import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:zachranobed/common/presentation/widget/donation/ui_donation_countdown_label.dart';

/// A widget that displays a ticking countdown timer until a specified deadline.
///
/// When the countdown reaches zero, it triggers the [onTimeOut] callback and
/// stops updating.
class TickingDonationCountdownLabel extends StatefulWidget {
  /// The target datetime to count down to.
  final DateTime deadline;

  /// The label text displayed below the countdown.
  final String label;

  /// Callback triggered when the countdown reaches zero.
  final VoidCallback onTimeout;

  /// Creates a [TickingDonationCountdownLabel] widget.
  const TickingDonationCountdownLabel({
    super.key,
    required this.deadline,
    required this.label,
    required this.onTimeout,
  });

  @override
  State<TickingDonationCountdownLabel> createState() => _TickingDonationCountdownLabelState();
}

class _TickingDonationCountdownLabelState extends State<TickingDonationCountdownLabel> {
  Timer? _timer;
  Duration _remainingDuration = Duration.zero;
  bool _hasTriggeredTimeOut = false;

  @override
  void initState() {
    super.initState();
    _calculateRemainingDuration();
    _startTimer();
  }

  @override
  void didUpdateWidget(TickingDonationCountdownLabel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.deadline != widget.deadline) {
      _hasTriggeredTimeOut = false;
      _calculateRemainingDuration();
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _calculateRemainingDuration() {
    final now = DateTime.now();
    final difference = widget.deadline.difference(now);
    _remainingDuration = difference.isNegative ? Duration.zero : difference;
  }

  void _startTimer() {
    _timer?.cancel();

    if (_remainingDuration == Duration.zero) {
      _triggerTimeout();
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _calculateRemainingDuration();

      if (_remainingDuration == Duration.zero) {
        _timer?.cancel();
        _triggerTimeout();
      }

      if (mounted) {
        setState(() {});
      }
    });
  }

  void _triggerTimeout() {
    if (_hasTriggeredTimeOut) return;
    _hasTriggeredTimeOut = true;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onTimeout.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return UiDonationCountdownLabel(
      duration: _remainingDuration,
      label: widget.label,
    );
  }
}
