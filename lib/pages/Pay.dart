// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_jdshop/widget/ColorButton.dart';
import 'package:flutter_jdshop/widget/Toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PayPage extends StatefulWidget {
  const PayPage({Key? key}) : super(key: key);

  @override
  State<PayPage> createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  final _payList = [
    {
      "url": "https://www.itying.com/themes/itying/images/alipay.png",
      "title": "支付宝",
      "isSelected": true,
    },
    {
      "url": "https://www.itying.com/themes/itying/images/weixinpay.png",
      "title": "微信",
      "isSelected": false,
    }
  ];

  Widget _createPayItemWidget(Map map) {
    return InkWell(
      child: SizedBox(
        height: 60.w,
        child: Column(
          children: [
            Expanded(
                child: Container(
              padding: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 8.w),
              child: Row(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Image.network("${map["url"]}", fit: BoxFit.cover),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Text(
                      "${map["title"]}",
                      style: TextStyle(color: Colors.black, fontSize: 14.sp),
                    ),
                  ),
                  if (map["isSelected"] == true) const Icon(Icons.check),
                ],
              ),
            )),
            const Divider(height: 1)
          ],
        ),
      ),
      onTap: () {
        setState(() {
          for (var tmp in _payList) {
            tmp["isSelected"] = false;
          }
          map["isSelected"] = true;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("去支付"),
        ),
        body: ListView(
          children: [
            for (var map in _payList) _createPayItemWidget(map),
            SizedBox(
              height: 30.w,
            ),
            Container(
                height: 60.w,
                padding: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 8.w),
                child: ColorButton(
                  text: "支付",
                  color: Colors.red,
                  onTap: () {
                    toastMessage("支付成功");
                    Navigator.pop(context);
                  },
                ))
          ],
        ));
  }
}
