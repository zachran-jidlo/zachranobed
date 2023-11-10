import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/helper_service.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/models/canteen.dart';
import 'package:zachranobed/notifiers/delivery_notifier.dart';

class DonationCountdownTimer extends StatefulWidget {
  const DonationCountdownTimer({super.key});

  @override
  State<DonationCountdownTimer> createState() => _DonationCountdownTimerState();
}

class _DonationCountdownTimerState extends State<DonationCountdownTimer> {
  Timer? _countdownTimer;
  Duration _remainingTime = const Duration(seconds: 0);

  @override
  void initState() {
    super.initState();
    _remainingTime = _getRemainingTimeForDonation();
    if (_remainingTime.inSeconds > 0) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    if (_countdownTimer != null) {
      _countdownTimer!.cancel();
    }
    super.dispose();
  }

  Duration _getRemainingTimeForDonation() {
    final user = HelperService.getCurrentUser(context) as Canteen;
    String timeNow = DateFormat('HH:mm:ss').format(DateTime.now());
    String donateWithin = user.pickUpFrom!;

    DateTime startTime = DateFormat('HH:mm:ss').parse(timeNow);
    DateTime endTime = DateFormat('HH:mm').parse(donateWithin);

    return endTime.difference(startTime) - const Duration(minutes: 35);
  }

  void _startTimer() {
    _countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => _setCountDown());
  }

  void _setCountDown() {
    const reduceSecondsBy = 1;
    if (mounted) {
      setState(() {
        final seconds = _remainingTime.inSeconds - reduceSecondsBy;
        if (seconds < 0) {
          _countdownTimer!.cancel();
        } else {
          _remainingTime = Duration(seconds: seconds);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hours =
        _remainingTime.inHours.remainder(24).toString().padLeft(2, '0');
    final minutes =
        _remainingTime.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
        _remainingTime.inSeconds.remainder(60).toString().padLeft(2, '0');

    final canDonate = _countdownTimer?.isActive ?? false;

    if (!canDonate) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        context
            .read<DeliveryNotifier>()
            .updateDeliveryState(context.l10n!.deliveryCancelledState);
      });
    }

    return Text(
      '$hours:$minutes:$seconds',
      style: const TextStyle(
        color: ZOColors.onPrimaryLight,
        fontSize: FontSize.s,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
