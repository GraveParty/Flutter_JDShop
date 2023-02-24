// ignore_for_file: file_names

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jdshop/config/Config.dart';
import 'package:flutter_jdshop/event/EventBus.dart';
import 'package:flutter_jdshop/models/AddressModel.dart';
import 'package:flutter_jdshop/models/ProductDetailModel.dart';
import 'package:flutter_jdshop/pages/tabs/cart/CartItem.dart';
import 'package:flutter_jdshop/provider/CartProvider.dart';
import 'package:flutter_jdshop/services/UserService.dart';
import 'package:flutter_jdshop/widget/ColorButton.dart';
import 'package:flutter_jdshop/widget/Toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late CartProvider _cartProvider;
  AddressModel? _address;

  @override
  initState() {
    super.initState();
    eventBus.on<AddressListRefreshEvent>().listen((event) {
      _loadDefaultAddress();
    });
    eventBus.on<AddressChangeDefaultEvent>().listen((event) {
      _loadDefaultAddress();
    });
    _loadDefaultAddress();
  }

  Future<void> _loadDefaultAddress() async {
    final user = await UserService.getUser();
    if (user == null) {
      toastMessage("请先登录");
      return;
    }
    final sign = Config.sign({"uid": user.id, "salt": user.salt});
    final api = Config.api("api/oneAddressList");
    final response = await Dio().get(api, queryParameters: {
      "uid": user.id,
      "sign": sign,
    });
    List? res = response.data["result"];
    if (res != null && res.isNotEmpty) {
      setState(() {
        _address = AddressModel.fromJson(res.first);
      });
    }
  }

  Future<void> _checkout() async {
    final user = await UserService.getUser();
    if (user == null) {
      toastMessage("请先登录");
      return;
    }
    if (_address == null) {
      toastMessage("请选择收货地址");
      return;
    }
    if (_cartProvider.list.isEmpty) {
      toastMessage("暂无商品");
      return;
    }

    final sign = Config.sign({
      "uid": user.id,
      "salt": user.salt,
      "address": _address?.address,
      "phone": _address?.phone,
      "name": _address?.name,
      "all_price": _cartProvider.totalPrices.toStringAsFixed(1),
      "products": json.encode(_cartProvider.list),
    });
    final api = Config.api("api/doOrder");
    final response = await Dio().post(api, data: {
      "uid": user.id,
      "sign": sign,
      "address": _address?.address,
      "phone": _address?.phone,
      "name": _address?.name,
      "all_price": _cartProvider.totalPrices.toStringAsFixed(1),
      "products": json.encode(_cartProvider.list),
    });
    //{"success":true,"message":"成功","result":{"order_id":"63f72b6ffd032b08ec4def3c","all_price":"1376.0"}}
    if (response.data["success"] == true) {
      await _cartProvider.deleteSelectedProducts();
      Navigator.pushReplacementNamed(context, '/pay');
    } else {
      toastMessage("${response.data["message"]}");
    }
  }

  Widget _createLocationWidget() {
    return InkWell(
      child: Container(
        padding:
            EdgeInsets.only(left: 16.w, right: 16.w, top: 16.w, bottom: 16.w),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black12))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _address == null
                        ? [
                            Text("请选择收货地址",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14.sp)),
                          ]
                        : [
                            Text("${_address!.name} ${_address!.phone}",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14.sp)),
                            SizedBox(
                              height: 8.w,
                            ),
                            Text(
                              "${_address!.address}",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 13.sp),
                            )
                          ])),
            SizedBox(width: 16.w),
            const Icon(Icons.arrow_forward_ios)
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, '/addressList');
      },
    );
  }

  Widget _createInfoItemWidget(String text) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding:
            EdgeInsets.only(left: 16.w, right: 16.w, top: 8.w, bottom: 8.w),
        child: Text(
          text,
          style: TextStyle(color: Colors.black, fontSize: 13.sp),
        ),
      ),
      const Divider(height: 1)
    ]);
  }

  @override
  Widget build(BuildContext context) {
    _cartProvider = Provider.of<CartProvider>(context);
    List<ProductDetailModel> list = [];
    for (final item in _cartProvider.list) {
      if (item.isSelected) {
        list.add(item);
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("结算"),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView(
            children: [
              _createLocationWidget(),
              for (final item in list)
                CartItem(
                  model: item,
                  showSelection: false,
                  isCountEditable: false,
                ),
              _createInfoItemWidget("商品总金额：￥${_cartProvider.totalPrices}"),
              _createInfoItemWidget("立减：￥0"),
              _createInfoItemWidget("运费：￥0"),
            ],
          )),
          Container(
            padding: EdgeInsets.only(left: 24.w, right: 24.w),
            decoration: const BoxDecoration(
                border:
                    Border(top: BorderSide(width: 1, color: Colors.black12))),
            height: 45.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("总价: ￥${_cartProvider.totalPrices}",
                    style: TextStyle(color: Colors.red, fontSize: 12.sp)),
                SizedBox(
                  height: 32.w,
                  child: ColorButton(
                    text: "立即下单",
                    color: Colors.red,
                    onTap: () {
                      _checkout();
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
