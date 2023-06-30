import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zachranobed/models/user.dart';
import 'package:zachranobed/notifiers/delivery_notifier.dart';
import 'package:zachranobed/notifiers/user_notifier.dart';
import 'package:zachranobed/routes.dart';
import 'package:zachranobed/services/api/delivery_api_service.dart';
import 'package:zachranobed/services/api/user_api_service.dart';
import 'package:zachranobed/services/helper_service.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadUserInfo();
    });
    initializeDateFormatting();
  }

  _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userEmail = prefs.getString('userEmail');

    if (userEmail != null) {
      final user = await UserApiService().logIn(email: userEmail);
      if (mounted) {
        final userNotifier = Provider.of<UserNotifier>(context, listen: false);
        userNotifier.user = User.create(
          user!.internalId,
          user.email,
          user.pickUpFrom,
          user.pickUpWithin,
          user.establishmentName,
          user.organization,
          user.recipient,
        );

        final date =
            HelperService.getDateTimeOfCurrentDelivery(user.pickUpFrom);

        final deliveryNotifier =
            Provider.of<DeliveryNotifier>(context, listen: false);
        deliveryNotifier.delivery = await DeliveryApiService().getDelivery(
            filter: 'vyzvednoutOd(eq)$date, darce.id(eq)${user.internalId}');

        if (mounted) {
          Navigator.of(context).pushReplacementNamed(RouteManager.home);
        }
      }
    } else {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(RouteManager.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
