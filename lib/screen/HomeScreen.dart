import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:devWeb/app_localizations.dart';
import 'package:devWeb/component/BottomNavigationComponent.dart';
import 'package:devWeb/component/FloatingComponent.dart';
import 'package:devWeb/component/NoInternetConnection.dart';

import 'package:devWeb/main.dart';
import 'package:devWeb/utils/AppWidget.dart';
import 'package:devWeb/utils/constant.dart';
import 'package:devWeb/utils/loader.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  static String tag = '/HomeScreen';

  HomeScreen();

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  InAppWebViewController? webViewController;
  ReceivePort _port = ReceivePort();

  PullToRefreshController? pullToRefreshController;

  late var _localPath;

  String? mInitialUrl;

  bool isWasConnectionLoss = false;
  bool _permissionReady = false;
  bool mIsPermissionGrant = false;
  bool mIsLocationPermissionGrant = false;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,

          mediaPlaybackRequiresUserGesture: false,
          allowFileAccessFromFileURLs: true,
          useOnDownloadStart: true,
          cacheEnabled: true,
          javaScriptCanOpenWindowsAutomatically: true,
          javaScriptEnabled: true,
          supportZoom: false,
          incognito: false),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  @override
  void initState() {
    super.initState();
    _bindBackgroundIsolate();

    init();
  }

  Future<bool> checkPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          mIsPermissionGrant = true;
          setState(() {});
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    init();
    super.dispose();
  }

  Future<void> init() async {
    mInitialUrl = 'https://sazgasheating.com/perfex/perfex_crm/admin/authentication';
    //mInitialUrl = 'https://bailcha.com/';
    appStore.setLoading(true);
    if (webViewController != null) {
      await webViewController!
          .loadUrl(urlRequest: URLRequest(url: Uri.parse(mInitialUrl!)));
    } else {
      log("webview error");
    }

    FlutterDownloader.registerCallback(downloadCallback);

    pullToRefreshController = PullToRefreshController(
      options:
          PullToRefreshOptions(color: appStore.primaryColors, enabled: true),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );

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
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      init();
    });
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context);
    Future<bool> _exitApp() async {
      if (await webViewController!.canGoBack()) {
        webViewController!.goBack();
        return false;
      } else {
        return mConfirmationDialog(() {
          Navigator.of(context).pop(false);
        }, context, appLocalization);
      }
    }

    Widget mLoadWeb({String? mURL}) {
      return Scaffold(
        extendBody: true,
        bottomNavigationBar: BottomNavigationComponent(onTap: (index) {
          setState(() {
            appStore.currentIndex = index;
            appStore.setIndex(index);

            if (index == 0) {
              webViewController!.loadUrl(
                  urlRequest: URLRequest(url: Uri.parse(mInitialUrl!)));
            } else if (index == 1) {
              webViewController!.loadUrl(
                  urlRequest:
                      URLRequest(url: Uri.parse(mInitialUrl! + 'shop/')));
            } else if (index == 2) {
              webViewController!.loadUrl(
                  urlRequest:
                      URLRequest(url: Uri.parse(mInitialUrl! + 'wishlist/')));
            } else if (index == 3) {
              webViewController!.loadUrl(
                  urlRequest:
                      URLRequest(url: Uri.parse(mInitialUrl! + 'my-account/')));
            }
          });
        }),
        body: SafeArea(
          child: Stack(
            children: [
              InAppWebView(
                  initialUrlRequest: URLRequest(
                      url:
                          Uri.parse(mURL.isEmptyOrNull ? mInitialUrl! : mURL!)),
                  initialOptions: options,
                  pullToRefreshController: pullToRefreshController,
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onLoadStart: (controller, url) {
                    log("onLoadStart");
                    appStore.setLoading(true);
                  },
                  onLoadStop: (controller, url) async {
                    log("onLoadStop");
                    appStore.setLoading(false);
                    pullToRefreshController!.endRefreshing();
                    setState(() {});
                  },
                  onLoadError: (controller, url, code, message) {
                    log("onLoadError");
                    appStore.setLoading(false);
                    pullToRefreshController!.endRefreshing();
                    setState(() {});
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    var uri = navigationAction.request.url;
                    var url = navigationAction.request.url.toString();
                    log("URL" + url.toString());

                    if (Platform.isAndroid && url.contains("intent")) {
                      if (url.contains("maps")) {
                        var mNewURL = url.replaceAll("intent://", "https://");
                        if (await canLaunch(mNewURL)) {
                          await launch(mNewURL);
                          return NavigationActionPolicy.CANCEL;
                        }
                      } else {
                        String id = url.substring(
                            url.indexOf('id%3D') + 5, url.indexOf('#Intent'));
                        await StoreRedirect.redirect(androidAppId: id);
                        return NavigationActionPolicy.CANCEL;
                      }
                    } else if (url.contains("linkedin.com") ||
                        url.contains("market://") ||
                        url.contains("whatsapp://") ||
                        url.contains("truecaller://") ||

                        url.contains("pinterest.com") ||
                        url.contains("snapchat.com") ||
                        url.contains("instagram.com") ||
                        url.contains("play.google.com") ||
                        url.contains("mailto:") ||
                        url.contains("messenger.com")) {
                      url = Uri.encodeFull(url);
                      try {
                        if (await canLaunch(url)) {
                          launch(url);
                        } else {
                          launch(url);
                        }
                        return NavigationActionPolicy.CANCEL;
                      } catch (e) {
                        launch(url);
                        return NavigationActionPolicy.CANCEL;
                      }
                    } else if (![
                      "http",
                      "https",
                      "chrome",
                      "data",
                      "javascript",
                      "about"
                    ].contains(uri!.scheme)) {
                      if (await canLaunch(url)) {
                        await launch(
                          url,
                        );
                        return NavigationActionPolicy.CANCEL;
                      }
                    }
                    return NavigationActionPolicy.ALLOW;
                  },
                  onDownloadStart: (controller, url) {
                    checkPermission().then((hasGranted) async {
                      _permissionReady = hasGranted;
                      if (_permissionReady == true) {
                        if (Platform.isIOS) {
                          _localPath = await getApplicationDocumentsDirectory();
                        } else {
                          _localPath = "/storage/emulated/0/Download";
                        }
                        log("local Path" + _localPath);

                        final taskId = await FlutterDownloader.enqueue(
                          url: url.toString(),
                          savedDir: _localPath,
                          fileName: 'invoice07e07da608addfb.pdf',
                          showNotification: true,
                          openFileFromNotification: true,
                          requiresStorageNotLow: true,
                        );


                      }
                    });
                  },
                  androidOnGeolocationPermissionsShowPrompt:
                      (InAppWebViewController controller, String origin) async {
                    await Permission.location.request();
                    return Future.value(GeolocationPermissionShowPromptResponse(
                        origin: origin, allow: true, retain: true));
                  },
                  androidOnPermissionRequest:
                      (InAppWebViewController controller, String origin,
                          List<String> resources) async {
                    if (resources.length >= 1) {
                    } else {
                      resources.forEach((element) async {
                        if (element.contains("AUDIO_CAPTURE")) {
                          await Permission.microphone.request();
                        }
                        if (element.contains("VIDEO_CAPTURE")) {
                          await Permission.camera.request();
                        }
                      });
                    }
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  }).visible(isWasConnectionLoss == false),
              NoInternetConnection().visible(isWasConnectionLoss == true),
              Loaders(name: 'FadingCircle').center().visible(appStore.isLoading),
            ],
          ),
        ),
      );
    }

    Widget mBody() {
      return SafeArea(
        child: Observer(
          builder: (_) => Scaffold(
              drawerEdgeDragWidth: 0,
              floatingActionButton: getStringAsync(IS_FLOATING) == "true"
                  ? FloatingComponent()
                  : SizedBox(),

              body: mLoadWeb(mURL: mInitialUrl),
              bottomNavigationBar: SizedBox()),
        ),
      );
    }

    return WillPopScope(
        onWillPop: _exitApp,
        child: DefaultTabController(
          length: appStore.mTabList.length,
          child: mBody(),
        ));
  }
}
