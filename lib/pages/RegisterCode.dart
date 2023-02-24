// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_jdshop/config/Config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widget/ColorButton.dart';
import '../widget/JDTextField.dart';
import 'package:dio/dio.dart';
import '../widget/Toast.dart';

class RegisterCodePage extends StatefulWidget {
  final Map? arguments;
  const RegisterCodePage({Key? key, this.arguments}) : super(key: key);

  @override
  State<RegisterCodePage> createState() => _RegisterCodePageState();
}

class _RegisterCodePageState extends State<RegisterCodePage> {
  String _phoneNumber = "";
  int _seconds = 0;
  String _code = "";

  @override
  void initState() {
    super.initState();
    _phoneNumber = "${widget.arguments?["phoneNumber"]}";
    _sendCode();
  }

  void _sendCode({bool sendCode = false}) async {
    if (sendCode) {
      final api = Config.api("api/sendCode");
      final response = await Dio().post(api, data: {"tel": _phoneNumber});
      if (response.data is Map) {
        final success = response.data["success"] as bool;
        if (success) {
          toastMessage("发送验证码成功");
        } else {
          toastMessage("${response.data["message"]}，但是无所谓");
        }
      } else {
        toastMessage("请求接口失败");
      }
    }

    setState(() {
      _seconds = 10;
    });
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds -= 1;
      });
      if (_seconds == 0) {
        timer.cancel();
      }
    });
  }

  void _checkCode() async {
    if (_code.isEmpty) {
      toastMessage("请输入验证码");
      return;
    }
    RegExp r = RegExp(r"^\d{4}$");
    if (r.hasMatch(_code)) {
      final api = Config.api("api/validateCode");
      final response = await Dio()
          .post(api, queryParameters: {"tel": _phoneNumber, "code": _code});
      if (response.data is Map) {
        final success = response.data["success"];
        if (success) {
          Navigator.pushNamed(context, '/registerPassword', arguments: {
            "code": response.data["code"],
            "phoneNumber": _phoneNumber
          });
        } else {
          Navigator.pushNamed(context, '/registerPassword',
              arguments: {"code": "0000", "phoneNumber": _phoneNumber});
          toastMessage("${response.data["message"]}，但是偏要跳转");
        }
      } else {
        toastMessage("请求接口失败");
      }
    } else {
      toastMessage("验证码格式不正确");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("手机快速注册"),
        ),
        body: Container(
            padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("请输入$_phoneNumber收到的验证码",
                    style: TextStyle(color: Colors.black, fontSize: 14.sp)),
                SizedBox(
                  width: double.infinity,
                  height: 44.h,
                  child: Row(
                    children: [
                      Expanded(
                          child: JDTextField(
                        placeholder: "请输入验证码",
                        onChanged: (text) {
                          _code = text;
                        },
                      )),
                      SizedBox(
                        height: 32.h,
                        width: 72.w,
                        child: ColorButton(
                            text: _seconds == 0 ? "重新发送" : "$_seconds",
                            color: _seconds == 0 ? Colors.red : Colors.grey,
                            onTap: () {
                              if (_seconds == 0) {
                                _sendCode(sendCode: true);
                              }
                            }),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                SizedBox(
                  height: 44.h,
                  child: ColorButton(
                    text: "下一步",
                    color: Colors.red,
                    onTap: () {
                      _checkCode();
                    },
                  ),
                )
              ],
            )));
  }
}
