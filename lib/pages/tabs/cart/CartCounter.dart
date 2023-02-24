// ignore_for_file: file_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../models/ProductDetailModel.dart';

class CartCounter extends StatefulWidget {
  final ProductDetailModel model;
  void Function()? didIncrease;
  void Function()? didDecrease;
  CartCounter(
      {Key? key, required this.model, this.didIncrease, this.didDecrease})
      : super(key: key);

  @override
  State<CartCounter> createState() => _CartCounterState();
}

class _CartCounterState extends State<CartCounter> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16.h,
      child: Row(
        children: [
          InkWell(
            child: Container(
              width: 20.w,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black38),
              ),
              alignment: Alignment.center,
              child: const Text("-"),
            ),
            onTap: () {
              if (widget.model.count > 1) {
                setState(() {
                  widget.model.count -= 1;
                  if (widget.didDecrease != null) {
                    widget.didDecrease!();
                  }
                });
              }
            },
          ),
          Container(
            width: 22.w,
            decoration: const BoxDecoration(
              border: Border(
                  top: BorderSide(width: 1, color: Colors.black38),
                  bottom: BorderSide(width: 1, color: Colors.black38)),
            ),
            alignment: Alignment.center,
            child: Text("${widget.model.count}"),
          ),
          InkWell(
            child: Container(
              width: 20.w,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black38),
              ),
              alignment: Alignment.center,
              child: const Text("+"),
            ),
            onTap: () {
              setState(() {
                widget.model.count += 1;
                if (widget.didIncrease != null) {
                  widget.didIncrease!();
                }
              });
            },
          )
        ],
      ),
    );
  }
}
