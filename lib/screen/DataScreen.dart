import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:devWeb/component/NoInternetConnection.dart';
import 'package:devWeb/model/MainResponse.dart';
import 'package:devWeb/screen/SplashScreen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class DataScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  @override
  DataScreenState createState() => DataScreenState();
}

class DataScreenState extends State<DataScreen>
    with AfterLayoutMixin<DataScreen> {
  bool isWasConnectionLoss = false;
  AsyncMemoizer<MainResponse> mainMemoizer = AsyncMemoizer<MainResponse>();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          isWasConnectionLoss = true;
        });
      } else {
        setState(() {
          isWasConnectionLoss = false;
        });
      }
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (isMobile) {
      OneSignal.shared.setNotificationOpenedHandler(
          (OSNotificationOpenedResult notification) async {
        String? urlString =
            await notification.notification.additionalData!["ID"];

        if (urlString.validate().isNotEmpty) {
          toast(urlString);
        }
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      !isWasConnectionLoss
          ? SplashScreen()
          : NoInternetConnection(),
    );
  }
}
