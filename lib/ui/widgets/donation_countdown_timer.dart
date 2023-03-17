import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zachranobed/helpers/current_user.dart';
import 'package:zachranobed/shared/constants.dart';

class DonationCountdownTimer extends StatefulWidget {
  const DonationCountdownTimer({Key? key}) : super(key: key);

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
    String timeNow = DateFormat('HH:mm:ss').format(DateTime.now());
    String donateTo = getCurrentUser(context)!.pickUpFrom;

    DateTime startTime = DateFormat('HH:mm:ss').parse(timeNow);
    DateTime endTime = DateFormat('HH:mm').parse(donateTo);

    return endTime.difference(startTime) - const Duration(minutes: 30);
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
    final hours = _remainingTime.inHours.remainder(24);
    final minutes = _remainingTime.inMinutes.remainder(60);

    final canDonate = _countdownTimer?.isActive ?? false;

    return Text(
      canDonate
          ? '${ZachranObedStrings.youCanDonate} $hours h : $minutes min'
          : ZachranObedStrings.youCantDonateAnymore,
      style: const TextStyle(color: Colors.white),
    );
  }
}
