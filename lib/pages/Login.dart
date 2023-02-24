// ignore_for_file: file_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jdshop/config/Config.dart';
import 'package:flutter_jdshop/models/User.dart';
import 'package:flutter_jdshop/provider/UserProvider.dart';
import 'package:flutter_jdshop/widget/Toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../widget/JDTextField.dart';
import '../widget/ColorButton.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _username = "";
  String _password = "";
  late UserProvider _userProvider;

  void _login() async {
    if (_username.isEmpty) {
      toastMessage("请输入用户名/手机号");
      return;
    }
    if (_password.length < 6) {
      toastMessage("请输入密码，密码不少于6位");
      return;
    }

    final api = Config.api("api/doLogin");
    final response = await Dio().post(api, data: {
      "username": _username,
      "password": _password,
    });
    final data = response.data;
    if (data is Map) {
      final success = data["success"];
      if (success == true) {
        toastMessage("登录成功");
        final userinfo = response.data["userinfo"] as List;
        final user = User.fromJson(userinfo.first);
        await _userProvider.login(user);
        Navigator.of(context).popUntil(ModalRoute.withName('/'));
      } else {
        toastMessage("${data["message"]}");
      }
    } else {
      toastMessage("请求登录失败");
    }
  }

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            TextButton(
                onPressed: () {},
                child: Text("客服",
                    style: TextStyle(color: Colors.black, fontSize: 14.sp)))
          ],
        ),
        body: ListView(
          children: [
            Container(
              height: 120.h,
              padding: EdgeInsets.only(top: 16.h),
              child: Center(
                child: Image.asset("images/login.png",
                    width: 88.w, height: 88.w, fit: BoxFit.fill),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16.w, right: 16.w),
              width: double.infinity,
              // height: 72.h,
              child: Column(
                children: [
                  JDTextField(
                    placeholder: "用户名/手机号",
                    onChanged: (value) {
                      _username = value;
                    },
                  ),
                  JDTextField(
                    placeholder: "请输入密码",
                    onChanged: (value) {
                      _password = value;
                    },
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("忘记密码",
                      style: TextStyle(color: Colors.black, fontSize: 14.sp)),
                  InkWell(
                    child: Text("新用户注册",
                        style: TextStyle(color: Colors.black, fontSize: 14.sp)),
                    onTap: () {
                      Navigator.pushNamed(context, '/registerPhone');
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 32.h,
            ),
            Container(
              padding: EdgeInsets.only(left: 32.w, right: 32.w),
              height: 44.h,
              child: ColorButton(
                color: Colors.red,
                text: "登录",
                onTap: () {
                  _login();
                },
              ),
            )
          ],
        ));
  }
}
