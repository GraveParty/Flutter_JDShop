// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JDTextField extends StatelessWidget {
  String? placeholder;
  void Function(String)? onChanged;
  double? width;
  double? height;
  EdgeInsetsGeometry? padding;
  int? maxLines;
  TextEditingController? controller;
  JDTextField(
      {Key? key,
      this.placeholder,
      this.onChanged,
      this.width,
      this.height,
      this.padding,
      this.maxLines = 1,
      this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12, width: 1))),
      child: TextField(
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.text,
        autofocus: false,
        maxLines: maxLines,
        //文字居中：BorderSide.none + EdgeInsets.symmetric(vertical: -10)
        decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.only(top: 10.w),
            hintText: placeholder,
            hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp)),
        style: TextStyle(color: Colors.black, fontSize: 14.sp),
        onChanged: onChanged,
      ),
    );
  }
}
