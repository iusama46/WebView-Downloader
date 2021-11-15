import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:devWeb/main.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

Color hexStringToHexInt(String hex) {
  hex = hex.replaceFirst('#', '');
  hex = hex.length == 6 ? 'ff' + hex : hex;
  int val = int.parse(hex, radix: 16);
  return Color(val);
}

launchURL(String openUrl) async {
  if (await canLaunch(openUrl)) {
    await launch(openUrl);
  } else {
    throw 'Could not launch $openUrl';
  }
}

class CustomTheme extends StatelessWidget {
  final Widget? child;

  CustomTheme({this.child});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: appStore.isDarkModeOn!
          ? ThemeData.dark().copyWith(
              accentColor: appStore.primaryColors,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            )
          : ThemeData.light(),
      child: child!,
    );
  }
}

String? getReferralCodeFromNative() {
  const platform = const MethodChannel('mightyweb/channel');

  if (isMobile) {
    var referralCode = platform.invokeMethod('mightyweb/events');
    return referralCode.toString();
  } else {
    return '';
  }
}


