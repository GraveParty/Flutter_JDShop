// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_jdshop/config/Config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widget/ColorButton.dart';
import '../widget/JDTextField.dart';
import '../widget/Toast.dart';
import 'package:dio/dio.dart';

class RegisterPhonePage extends StatefulWidget {
  const RegisterPhonePage({Key? key}) : super(key: key);

  @override
  State<RegisterPhonePage> createState() => _RegisterPhonePageState();
}

class _RegisterPhonePageState extends State<RegisterPhonePage> {
  String _phoneNumber = "";

  void _checkPhone() async {
    RegExp r = RegExp(r"^1\d{10}$");
    if (r.hasMatch(_phoneNumber)) {
      final api = Config.api("api/sendCode");
      final response = await Dio().post(api, data: {"tel": _phoneNumber});
      if (response.data is Map) {
        final success = response.data["success"] as bool;
        if (success) {
          Navigator.pushNamed(context, '/registerCode',
              arguments: {"phoneNumber": _phoneNumber});
        } else {
          Navigator.pushNamed(context, '/registerCode',
              arguments: {"phoneNumber": _phoneNumber});
          toastMessage("${response.data["message"]}，但是偏要跳转");
        }
      } else {
        toastMessage("请求接口失败");
      }
    } else {
      toastMessage("手机号码格式不正确");
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
              children: [
                JDTextField(
                  placeholder: "请输入手机号",
                  onChanged: (text) {
                    _phoneNumber = text;
                  },
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
                      _checkPhone();
                    },
                  ),
                )
              ],
            )));
  }
}
