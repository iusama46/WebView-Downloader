import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:devWeb/app_localizations.dart';
import 'package:devWeb/main.dart';
import 'package:devWeb/model/MainResponse.dart';
import 'package:devWeb/utils/constant.dart';
import 'package:devWeb/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

Widget cachedImage(String? url, {double? height, Color? color, double? width, BoxFit? fit, AlignmentGeometry? alignment, bool usePlaceholderIfUrlEmpty = true, double? radius}) {
  if (url.validate().isEmpty) {
    return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
  } else if (url.validate().startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: url!,
      height: height,
      width: width,
      fit: fit,
      color: color,
      alignment: alignment as Alignment? ?? Alignment.center,
      errorWidget: (_, s, d) {
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      },
      // placeholder: (_, s) {
      //   if (!usePlaceholderIfUrlEmpty) return SizedBox();
      //   return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      // },
    );
  } else {
    return Image.asset(url!, height: height, width: width, fit: fit, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? defaultRadius);
  }
}

Widget placeHolderWidget({double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, double? radius}) {
  return Image.asset('assets/ic_logo.png', height: height, width: width, fit: fit ?? BoxFit.cover, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? defaultRadius);
}

Widget setImage(String value) {
  return Image.asset(value, height: 18, width: 18, color: white).paddingAll(16);
}





bool mConfirmationDialog(Function onTap, BuildContext context, AppLocalizations? appLocalization) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: context.scaffoldBackgroundColor,
      title: Text(appLocalization!.translate('lbl_logout')!, style: boldTextStyle()),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            onTap.call();
          },
          child: Text(appLocalization.translate('lbl_no')!, style: secondaryTextStyle(size: 16)),
        ),
        TextButton(
          onPressed: () => exit(0),
          child: Text(appLocalization.translate('lbl_yes')!, style: primaryTextStyle(color: appStore.primaryColors)),
        ),
      ],
    ),
  );
  return true;
}

