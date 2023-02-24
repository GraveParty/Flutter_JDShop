// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_jdshop/provider/CartProvider.dart';
import '../../../config/Config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'CartCounter.dart';
import '../../../models/ProductDetailModel.dart';
import 'package:provider/provider.dart';

class CartItem extends StatefulWidget {
  final ProductDetailModel model;
  final bool showSelection;
  final bool isCountEditable;
  const CartItem(
      {Key? key,
      required this.model,
      this.showSelection = true,
      this.isCountEditable = true})
      : super(key: key);

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return SizedBox(
      height: 80.h,
      child: Column(
        children: [
          Expanded(
              child: Container(
            padding:
                EdgeInsets.only(top: 8.h, left: 8.w, bottom: 8.h, right: 16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.showSelection)
                  Checkbox(
                      value: widget.model.isSelected,
                      activeColor: Colors.red,
                      onChanged: (value) async {
                        widget.model.isSelected = value ?? true;
                        cartProvider.updateProducts([widget.model]);
                      }),
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(Config.picture(widget.model.pic),
                      fit: BoxFit.cover),
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.model.title}",
                        maxLines: 2,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.sp,
                            overflow: TextOverflow.ellipsis),
                      ),
                      Text(widget.model.selectedTagsStr,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12.sp,
                              overflow: TextOverflow.ellipsis)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "￥${widget.model.price}",
                            style:
                                TextStyle(color: Colors.red, fontSize: 12.sp),
                          ),
                          widget.isCountEditable
                              ? CartCounter(
                                  model: widget.model,
                                  didIncrease: () async {
                                    cartProvider.updateProducts([widget.model]);
                                  },
                                  didDecrease: () async {
                                    cartProvider.updateProducts([widget.model]);
                                  })
                              : Text("x${widget.model.count}",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12.sp))
                        ],
                      )
                    ],
                  ),
                ))
              ],
            ),
          )),
          const Divider(height: 1)
        ],
      ),
    );
  }
}
