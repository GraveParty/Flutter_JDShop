// ignore_for_file: file_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jdshop/config/Config.dart';
import 'package:flutter_jdshop/models/OrderModel.dart';
import 'package:flutter_jdshop/models/ProductDetailModel.dart';
import 'package:flutter_jdshop/pages/tabs/cart/CartItem.dart';
import 'package:flutter_jdshop/services/UserService.dart';
import 'package:flutter_jdshop/widget/ColorButton.dart';
import 'package:flutter_jdshop/widget/Toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({Key? key}) : super(key: key);

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  List<OrderModel> _list = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final user = await UserService.getUser();
    if (user == null) {
      toastMessage("请先登录");
      return;
    }

    final sign = Config.sign({
      "uid": user.id,
      "salt": user.salt,
    });
    final api = Config.api("api/orderList");
    final response = await Dio().get(api, queryParameters: {
      "uid": user.id,
      "sign": sign,
    });
    if (response.data["success"] == true) {
      List list = response.data["result"];
      setState(() {
        _list = list.map((e) {
          return OrderModel.fromJson(e);
        }).toList();
      });
    } else {
      toastMessage("${response.data["message"]}");
    }
  }

  Widget _createOrderItemWidget(OrderModel model) {
    final products = model.orderItems.map((e) {
      return ProductDetailModel(
          sId: e.id,
          title: e.productTitle,
          price: e.productPrice,
          pic: e.productImg,
          count: e.productCount);
    }).toList();
    return InkWell(
      child: Container(
        padding: EdgeInsets.fromLTRB(8.w, 8.w, 8.w, 8.w),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 8.w),
                child: Text(
                  "订单编号: ${model.id}",
                  style: TextStyle(color: Colors.black, fontSize: 14.sp),
                ),
              ),
              const Divider(
                height: 1,
              ),
              for (var p in products)
                CartItem(
                  model: p,
                  showSelection: false,
                  isCountEditable: false,
                ),
              Container(
                padding: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 8.w),
                height: 48.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("合计：￥${model.allPrice}元",
                        style: TextStyle(color: Colors.black, fontSize: 14.sp)),
                    ColorButton(text: "申请售后", color: Colors.red),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, '/orderDetail', arguments: {
          "model": model,
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("我的订单"),
      ),
      body: ListView(
        children: [for (final o in _list) _createOrderItemWidget(o)],
      ),
    );
  }
}
