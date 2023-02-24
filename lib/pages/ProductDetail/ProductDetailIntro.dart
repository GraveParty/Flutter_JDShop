// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_jdshop/config/Config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widget/ColorButton.dart';
import '../../models/ProductDetailModel.dart';
import '../../event/EventBus.dart';
import 'dart:async';
import '../tabs/cart/CartCounter.dart';
import 'package:provider/provider.dart';
import '../../provider/CartProvider.dart';
import '../../widget/Toast.dart';

class ProductDetailIntroPage extends StatefulWidget {
  final ProductDetailModel model;
  const ProductDetailIntroPage({Key? key, required this.model})
      : super(key: key);

  @override
  State<ProductDetailIntroPage> createState() => _ProductDetailIntroPageState();
}

class _ProductDetailIntroPageState extends State<ProductDetailIntroPage>
    with AutomaticKeepAliveClientMixin {
  late StreamSubscription _productTagsStreamSubscription;
  late CartProvider cartProvider;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _productTagsStreamSubscription =
        eventBus.on<ProductTagsEvent>().listen((event) {
      _showActionSheet();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _productTagsStreamSubscription.cancel();
  }

  void _showActionSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(builder: (context, setSheetState) {
            return GestureDetector(
              child: Container(
                height: 300.h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.w),
                        topRight: Radius.circular(4.w))),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(children: [
                        SizedBox(
                          height: 8.h,
                        ),
                        for (ProductDetailAttr attr in widget.model.attr)
                          _createSheetItem(attr, setSheetState),
                        const Divider(),
                        Container(
                          padding: EdgeInsets.only(
                              left: 16.w, right: 16.w, top: 8.h),
                          child: Row(
                            children: [
                              Text("数量:",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(width: 16.w),
                              CartCounter(model: widget.model)
                            ],
                          ),
                        )
                      ]),
                    ),
                    SizedBox(
                        width: 1.sw,
                        height: 70.h,
                        child: Container(
                          padding: EdgeInsets.only(left: 8.w, right: 8.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Container(
                                margin: EdgeInsets.all(8.w),
                                height: 36.h,
                                child: ColorButton(
                                  color: const Color.fromRGBO(253, 1, 0, 0.9),
                                  text: "加入购物车",
                                  onTap: () async {
                                    await cartProvider.addProduct(widget.model);
                                    Navigator.of(context).pop();
                                    toastMessage("加入购物车成功");
                                  },
                                ),
                              )),
                              Expanded(
                                  child: Container(
                                margin: EdgeInsets.all(8.w),
                                height: 36.h,
                                child: ColorButton(
                                  color: const Color.fromRGBO(255, 165, 0, 0.9),
                                  text: "立即购买",
                                ),
                              )),
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            );
          });
        });
  }

  Widget _createSheetItem(
      ProductDetailAttr attr, void Function(void Function()) setSheetState) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 8.w),
          width: 80.w,
          child: Wrap(
            spacing: 8.w,
            children: [
              Chip(
                  label: Text("${attr.cate}:",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold)),
                  backgroundColor: Colors.white),
            ],
          ),
        ),
        Expanded(
            child: Wrap(
          spacing: 8.w,
          children: attr.list.map((tag) {
            final backgroundColor =
                tag.isSelected ? Colors.red : Colors.black12;
            final textColor = tag.isSelected ? Colors.white : Colors.black;
            return InkWell(
              onTap: () {
                attr.selectTag(tag);
                setSheetState(() {});
                setState(() {});
              },
              child: Chip(
                  label: Text(tag.name),
                  labelStyle: TextStyle(color: textColor),
                  backgroundColor: backgroundColor),
            );
          }).toList(),
        ))
      ],
    );
  }

  Widget _selectedTagsWidget() {
    return Column(
      children: [
        InkWell(
            onTap: () {
              _showActionSheet();
            },
            child: Container(
              padding: EdgeInsets.only(left: 16.w, right: 16.w),
              height: 40.h,
              child: Row(
                children: [
                  Text("已选：",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold)),
                  Text(widget.model.selectedTagsStr,
                      style: TextStyle(color: Colors.black, fontSize: 14.sp)),
                ],
              ),
            )),
        const Divider(
          color: Colors.black,
          height: 1,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    cartProvider = Provider.of<CartProvider>(context);
    return ListView(
      children: [
        AspectRatio(
          aspectRatio: 16.0 / 16.0,
          child: Image.network(Config.picture(widget.model.pic),
              fit: BoxFit.cover),
        ),
        Container(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h),
          child: Text(
            widget.model.title ?? "",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20.sp,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h),
          child: Text(
            widget.model.subTitle ?? "",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14.sp,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h),
          child: Row(
            children: [
              Expanded(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    "特价:",
                    style: TextStyle(color: Colors.black, fontSize: 14.sp),
                  ),
                  Text("￥${widget.model.price}",
                      style: TextStyle(color: Colors.red, fontSize: 22.sp)),
                ],
              )),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("原价:",
                      style: TextStyle(color: Colors.black, fontSize: 14.sp)),
                  Text("￥${widget.model.oldPrice}",
                      style: TextStyle(
                          color: Colors.black45,
                          fontSize: 14.sp,
                          decoration: TextDecoration.lineThrough)),
                ],
              ))
            ],
          ),
        ),
        _selectedTagsWidget(),
        Container(
          padding: EdgeInsets.only(left: 16.w, right: 16.w),
          height: 40.h,
          child: Row(
            children: [
              Text("运费：",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold)),
              Text("免运费",
                  style: TextStyle(color: Colors.black, fontSize: 14.sp)),
            ],
          ),
        ),
        const Divider(
          color: Colors.black,
          height: 1,
        ),
      ],
    );
  }
}
