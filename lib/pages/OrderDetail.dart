// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_jdshop/models/AddressModel.dart';
import 'package:flutter_jdshop/models/OrderModel.dart';
import 'package:flutter_jdshop/models/ProductDetailModel.dart';
import 'package:flutter_jdshop/pages/tabs/cart/CartItem.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDetailPage extends StatefulWidget {
  Map? arguments;
  OrderDetailPage({Key? key, this.arguments}) : super(key: key);

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  OrderModel? _model;

  @override
  initState() {
    super.initState();
    _model = widget.arguments?["model"];
  }

  Widget _createLocationWidget(AddressModel address) {
    return Container(
      padding:
          EdgeInsets.only(left: 16.w, right: 16.w, top: 16.w, bottom: 16.w),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.add_location),
          SizedBox(
            width: 16.w,
          ),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text("${address.name} ${address.phone}",
                    style: TextStyle(color: Colors.black, fontSize: 14.sp)),
                SizedBox(
                  height: 8.w,
                ),
                Text(
                  "${address.address}",
                  style: TextStyle(color: Colors.black, fontSize: 13.sp),
                )
              ])),
        ],
      ),
    );
  }

  Widget _createInfoItemWidget(String title, String? value,
      {Color valueColor = Colors.black}) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 8.w),
      child: Row(
        children: [
          Text(title,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold)),
          Text(value ?? "",
              style: TextStyle(
                  color: valueColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = _model?.orderItems.map((e) {
          return ProductDetailModel(
              sId: e.id,
              title: e.productTitle,
              price: e.productPrice,
              pic: e.productImg,
              count: e.productCount);
        }).toList() ??
        [];
    return Scaffold(
      appBar: AppBar(
        title: const Text("订单详情"),
      ),
      body: ListView(
        children: [
          _createLocationWidget(AddressModel.fromJson({
            "name": _model?.name,
            "phone": _model?.phone,
            "address": _model?.address,
          })),
          for (var p in products)
            CartItem(
              model: p,
              showSelection: false,
              isCountEditable: false,
            ),
          _createInfoItemWidget("订单编号: ", _model?.id),
          _createInfoItemWidget("下单日期: ", "2023-02-23"),
          _createInfoItemWidget("支付方式: ", "微信支付"),
          _createInfoItemWidget("配送方式: ", "顺丰"),
          _createInfoItemWidget("总金额: ", "￥${_model?.allPrice}元",
              valueColor: Colors.red),
        ],
      ),
    );
  }
}
