import 'package:flutter/material.dart';
import 'package:devWeb/main.dart';
import 'package:devWeb/utils/AppWidget.dart';
import 'package:devWeb/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import 'HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen2';

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setStatusBarColor(appStore.primaryColors,
        statusBarBrightness: Brightness.light);
    await Future.delayed(Duration(seconds: 2));

    HomeScreen().launch(context, isNewTask: true);

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: cachedImage(getStringAsync(APPLOGO),
            fit: BoxFit.contain, height: 150, width: 150)
            .cornerRadiusWithClipRRect(10)
            .center(),
      ),
    );
  }
}
