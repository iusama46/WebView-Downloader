import 'package:flutter/material.dart';
import 'package:devWeb/model/MainResponse.dart';
import 'package:devWeb/utils/constant.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:devWeb/main.dart';
import 'package:devWeb/utils/colors.dart';
part 'AppStore.g.dart';

class AppStore = AppStoreBase with _$AppStore;

abstract class AppStoreBase with Store {

  @observable
  bool? isDarkModeOn = false;

  @observable
  Color primaryColors = primaryColor1;

  @observable
  String? loaderValues='RotatingPlane';

  @observable
  String? url;

  @observable
  int currentIndex=0;

  @observable
  String? selectedLanguageCode;

  @observable
  bool isLoading = false;

  @observable
  List<TabsResponse> mTabList = ObservableList<TabsResponse>();

  @observable
  List<FloatingButton> mFABList = ObservableList<FloatingButton>();

  @observable
  List<Walkthrough> mOnBoardList = ObservableList<Walkthrough>();

  @observable
  List<MenuStyle> mBottomNavigationList = ObservableList<MenuStyle>();
  
  @action
  void setLoading(bool val) {
    isLoading = val;
  }

  @action
  Future<void> toggleDarkMode({bool? value}) async {
    isDarkModeOn = value ?? !isDarkModeOn!;
  }

  @observable
  String? deepLinkURL;

  @action
  void setDeepLinkURL(String val) {
    deepLinkURL = val;
  }
  
  @action
  void addToTabList(TabsResponse val) {
    mTabList.add(val);
  }

  @action
  void addToOnBoardList(Walkthrough val) {
    mOnBoardList.add(val);
  }
  
  @action
  void addToFabList(FloatingButton val) {
    mFABList.add(val);
  }

  @action
  void addToBottomNavigationLis(MenuStyle val) {
    mBottomNavigationList.add(val);
  }

  @action
  Future<void> setDarkMode({bool? aIsDarkMode}) async {
    isDarkModeOn = aIsDarkMode;

    if (isDarkModeOn!) {
      textPrimaryColorGlobal = Colors.white;
      textSecondaryColorGlobal = Colors.white70;
    } else {
      textPrimaryColorGlobal = textColorPrimary;
      textSecondaryColorGlobal =  textColorSecondary;
    }
    await setBool(isDarkModeOnPref, isDarkModeOn!);
    setStatusBarColor(appStore.primaryColors);
  }

  @action
  void setPrimaryColor(Color value) {
    primaryColors = value;
  }

  @action
  void setLoader(String? value) {
    loaderValues = value;
  }

  @action
  void setURL(String value) {
    url = value;
  }

  @action
  void setIndex(int value) {
    currentIndex = value;
  }

  @action
  Future<void> setLanguage(String? aSelectedLanguageCode) async {
    selectedLanguageCode = aSelectedLanguageCode;
    setValue(APP_LANGUAGE, aSelectedLanguageCode);
  }

}
