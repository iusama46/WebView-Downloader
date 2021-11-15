import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:devWeb/main.dart';
import 'package:devWeb/model/MainResponse.dart' as model;
import 'package:devWeb/utils/colors.dart';
import 'package:devWeb/utils/common.dart';
import 'package:devWeb/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

Future handleResponse(Response response) async {
  if (!await isNetworkAvailable()) {
    throw errorInternetNotAvailable;
  }

  if (response.statusCode.isSuccessful()) {
    return jsonDecode(response.body);
  } else {
    try {
      var body = jsonDecode(response.body);
      throw body['message'];
    } on Exception catch (e) {
      log(e);
      throw errorSomethingWentWrong;
    }
  }
}


