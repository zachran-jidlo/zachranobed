import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/helper_service.dart';
import 'package:zachranobed/common/lifecycle/lifecycle_watcher.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/models/canteen.dart';
import 'package:zachranobed/models/delivery.dart';
import 'package:zachranobed/notifiers/delivery_notifier.dart';

class DonationCountdownTimer extends StatefulWidget {
  final Delivery delivery;
  final TextAlign textAlign;

  const DonationCountdownTimer({
    super.key,
    required this.delivery,
    required this.textAlign,
  });

  @override
  State<DonationCountdownTimer> createState() => _DonationCountdownTimerState();
}

class _DonationCountdownTimerState extends State<DonationCountdownTimer>
    with TickerProviderStateMixin, LifecycleWatcher {
  Ticker? _ticker;
  String _value = "";

  @override
  void initState() {
    super.initState();

    _checkTicker();
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  @override
  void onResume() {
    _checkTicker();
  }

  void _checkTicker() {
    final total = _getRemainingTimeForDonation();
    if (total.inSeconds > 0) {
      _startTicker(total);
    } else {
      _stopTicker();
    }
  }

  void _startTicker(Duration total) {
    _ticker?.dispose();
    _ticker = createTicker((elapsed) => _countdownTick(total, elapsed));
    _ticker?.start();
  }

  void _stopTicker() {
    if (_ticker != null) {
      _ticker?.dispose();

      SchedulerBinding.instance.addPostFrameCallback((_) {
        context.read<DeliveryNotifier>().refreshDelivery();
      });
    }
  }

  void _countdownTick(Duration total, Duration elapsed) {
    final time = total - elapsed;
    final hours = time.inHours.remainder(24).toString().padLeft(2, '0');
    final minutes = time.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = time.inSeconds.remainder(60).toString().padLeft(2, '0');

    final newValue = '$hours:$minutes:$seconds';
    if (newValue != _value) {
      setState(() => _value = newValue);
    }

    if (elapsed > total) {
      _stopTicker();
    }
  }

  Duration _getRemainingTimeForDonation() {
    final user = HelperService.getCurrentUser(context) as Canteen;
    String timeNow = DateFormat('HH:mm:ss').format(DateTime.now());
    String donateWithin = user.pickUpFrom;

    DateTime startTime = DateFormat('HH:mm:ss').parse(timeNow);
    DateTime endTime = DateFormat('HH:mm').parse(donateWithin);

    final confirmationTime = Duration(minutes: widget.delivery.confirmationTime);
    return endTime.difference(startTime) - confirmationTime;
  }

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      textAlign: widget.textAlign,
      TextSpan(
        text: '${context.l10n!.youCanDonate} ',
        style: const TextStyle(
          color: ZOColors.onPrimaryLight,
          fontSize: FontSize.s,
        ),
        children: <InlineSpan>[
          TextSpan(
            text: _value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
