// ignore_for_file: file_names

import 'package:flutter_jdshop/models/User.dart';

import 'Storage.dart';
import 'dart:convert';

class UserService {
  static const key = "userService";

  static Future<void> setUser(User user) async {
    // final string = user.toJson().toString(); //直接toSting()会导致decode失败
    final string = json.encode(user.toJson());
    await Storage.setString(key, string);
  }

  static Future<User?> getUser() async {
    User? user;
    try {
      String? value = await Storage.getString(key);
      if (value != null) {
        user = User.fromJson(json.decode(value));
      }
      // ignore: empty_catches
    } catch (e) {}
    return user;
  }

  static Future<void> clearUser() async {
    await Storage.remove(key);
  }
}
