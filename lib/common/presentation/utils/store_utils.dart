import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreUtils {
  final String androidAppId = "cz.zachranobed";
  final String iosAppId = "6480120296";

  /// Opens the store page for the app. Supports both Android and iOS.
  Future<void> openStore(BuildContext context) async {
    final Uri url = Uri.parse(
      Theme.of(context).platform == TargetPlatform.iOS
          ? "https://apps.apple.com/app/id$iosAppId"
          : "https://play.google.com/store/apps/details?id=$androidAppId",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw "Can't launch $url";
    }
  }
}
