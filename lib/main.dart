import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:devWeb/AppTheme.dart';
import 'package:devWeb/Store/AppStore.dart';
import 'package:devWeb/app_localizations.dart';
import 'package:devWeb/model/LanguageModel.dart';
import 'package:devWeb/screen/DataScreen.dart';
import 'package:devWeb/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

AppStore appStore = AppStore();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialize();
  await FlutterDownloader.initialize(debug: true);
  appStore.setDarkMode(aIsDarkMode: await getBool(isDarkModeOnPref));
  appStore.setLanguage(getStringAsync(APP_LANGUAGE, defaultValue: 'en'));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (isMobile) {
      MobileAds.instance.initialize();
      await OneSignal.shared.setAppId(getStringAsync(ONESINGLE, defaultValue: mOneSignalID));
      OneSignal.shared.consentGranted(true);
      OneSignal.shared.promptUserForPushNotificationPermission();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    setStatusBarColor(appStore.primaryColors, statusBarBrightness: Brightness.light);
    return Observer(builder: (_) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(child: DataScreen()),
        supportedLocales: Language.languagesLocale(),
        localizationsDelegates: [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
        localeResolutionCallback: (locale, supportedLocales) => locale,
        locale: Locale(getStringAsync(APP_LANGUAGE, defaultValue: 'en')),
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: appStore.isDarkModeOn! ? ThemeMode.dark : ThemeMode.light,
        scrollBehavior: SBehavior(),
      );
    });
  }
}
