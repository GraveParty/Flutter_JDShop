// ignore_for_file: file_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jdshop/config/Config.dart';
import 'package:flutter_jdshop/models/User.dart';
import 'package:flutter_jdshop/pages/tabs/Tabs.dart';
import 'package:flutter_jdshop/provider/UserProvider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../widget/ColorButton.dart';
import '../widget/JDTextField.dart';
import '../widget/Toast.dart';

class RegisterPasswordPage extends StatefulWidget {
  final Map? arguments;
  const RegisterPasswordPage({Key? key, this.arguments}) : super(key: key);

  @override
  State<RegisterPasswordPage> createState() => _RegisterPasswordPageState();
}

class _RegisterPasswordPageState extends State<RegisterPasswordPage> {
  late UserProvider _userProvider;
  String _phoneNumber = "";
  String _code = "";
  String _password = "";
  String _confirmingPassword = "";

  @override
  void initState() {
    super.initState();
    _phoneNumber = "${widget.arguments?["phoneNumber"]}";
    _code = "${widget.arguments?["code"]}";
  }

  bool _checkPassword() {
    if (_password.length < 6) {
      toastMessage("密码不能小于6位");
      return false;
    }
    if (_password != _confirmingPassword) {
      toastMessage("两次输入的密码不一致");
      return false;
    }
    return true;
  }

  void _register() async {
    if (!_checkPassword()) {
      return;
    }

    final api = Config.api("api/register");
    final response = await Dio().post(api,
        data: {"tel": _phoneNumber, "code": _code, "password": _password});
    if (response.data is Map) {
      final success = response.data["success"];
      User user;
      if (success) {
        final userInfo = response.data["userinfo"] as List;
        user = User.fromJson(userInfo.first);
      } else {
        toastMessage("${response.data["message"]}，但偏要成功");
        user = User.fromJson({
          "_id": "5d35623c303a591b50cd74a2",
          "username": "注册失败的用户",
          "tel": "15212345678",
          "salt": "758a06618c69880a6cee5314ee42d52f"
        });
      }
      await _userProvider.login(user);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Tabs()),
          (route) => false);
      // Navigator.of(context).popUntil(ModalRoute.withName('/'));
    } else {
      toastMessage("请求接口失败");
    }
  }

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("手机快速注册"),
        ),
        body: Container(
            padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
            child: Column(
              children: [
                JDTextField(
                  placeholder: "请输入密码",
                  onChanged: (text) {
                    _password = text;
                  },
                ),
                JDTextField(
                  placeholder: "请确认密码",
                  onChanged: (text) {
                    _confirmingPassword = text;
                  },
                ),
                SizedBox(
                  height: 16.h,
                ),
                SizedBox(
                  height: 44.h,
                  child: ColorButton(
                    text: "登录",
                    color: Colors.red,
                    onTap: () {
                      _register();
                    },
                  ),
                )
              ],
            )));
  }
}
