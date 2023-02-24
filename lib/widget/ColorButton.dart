// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ColorButton extends StatelessWidget {
  Color? color = Colors.transparent;
  String? text;
  void Function()? onTap;
  ColorButton({Key? key, this.color, this.text, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8.w, right: 8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.w)),
        color: color,
      ),
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Text(
            text ?? "",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
