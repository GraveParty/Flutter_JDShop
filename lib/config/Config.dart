// ignore_for_file: file_names

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_jdshop/provider/UserProvider.dart';
import 'package:provider/provider.dart';

class Config {
  static const String domain = "https://jdmall.itying.com/";
  static String api(String str) {
    return domain + str;
  }

  static String picture(String? str) {
    if (str == null) {
      return "https://www.itying.com/images/flutter/p1.jpg";
    }
    if (str.startsWith("http")) {
      return str.replaceAll("\\", "/");
    }
    var picURL = Config.domain + str;
    picURL = picURL.replaceAll("\\", "/");
    return picURL;
  }

  static String sign(Map params) {
    final keys = params.keys.toList();
    keys.sort();
    final kv = keys.map((e) {
      return "$e${params[e]}";
    }).toList();
    final kvStr = kv.join();
    return md5.convert(utf8.encode(kvStr)).toString();
  }
}
