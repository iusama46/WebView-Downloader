import 'package:flutter/material.dart';
import 'package:devWeb/app_localizations.dart';
import 'package:nb_utils/nb_utils.dart';

class ErrorScreen extends StatefulWidget {
  static String tag = '/ErrorScreen';

  @override
  ErrorScreenState createState() => ErrorScreenState();
}

class ErrorScreenState extends State<ErrorScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.scaffoldBackgroundColor,
        body: Text(appLocalization.translate('lbl_try_again')!, style: boldTextStyle(size: 20)).center(),
      ),
    );
  }
}
