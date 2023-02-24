// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_jdshop/models/User.dart';
import 'package:flutter_jdshop/services/UserService.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  User? get user => _user;

  bool get isLogin {
    return _user != null;
  }

  UserProvider() {
    update();
  }

  Future<void> update() async {
    _user = await UserService.getUser();
    notifyListeners();
  }

  Future<void> login(User user) async {
    await UserService.setUser(user);
    await update();
  }

  Future<void> logout() async {
    await UserService.clearUser();
    await update();
  }
}
