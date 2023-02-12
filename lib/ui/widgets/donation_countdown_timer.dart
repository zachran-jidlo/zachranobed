import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zachranobed/constants.dart';
import 'package:zachranobed/helpers/current_user.dart';

class DonationCountdownTimer extends StatefulWidget {
  const DonationCountdownTimer({Key? key}) : super(key: key);

  @override
  State<DonationCountdownTimer> createState() => _DonationCountdownTimerState();
}

class _DonationCountdownTimerState extends State<DonationCountdownTimer> {
  
  Timer? countdownTimer;
  late Duration remainingTime;
  
  @override
  void initState() {
    super.initState();
    remainingTime = getRemainingTimeForDonation();
    startTimer();
  }

  @override
  void dispose() {
    countdownTimer!.cancel();
    super.dispose();
  }

  Duration getRemainingTimeForDonation() {
    String timeNow = DateFormat('HH:mm:ss').format(DateTime.now());
    String donateTo = getCurrentUser(context).pickUpFrom;

    DateTime startTime = DateFormat("HH:mm:ss").parse(timeNow);
    DateTime endTime = DateFormat("HH:mm").parse(donateTo);

    return endTime.difference(startTime) - const Duration(minutes: 30);
  }
  
  void startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }
  
  void setCountDown() {
    const reduceSecondsBy = 1;
    if (mounted){
      setState(() {
        final seconds = remainingTime.inSeconds - reduceSecondsBy;
        if (seconds < 0) {
          countdownTimer!.cancel();
        } else {
          remainingTime = Duration(seconds: seconds);
        }
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final hours = remainingTime.inHours.remainder(24);
    final minutes = remainingTime.inMinutes.remainder(60);
    return Text(
      countdownTimer!.isActive? '${ZachranObedStrings.youCanDonate} $hours h : $minutes min' : ZachranObedStrings.youCantDonateAnymore,
      style: const TextStyle(color: Colors.white),
    );
  }
}
