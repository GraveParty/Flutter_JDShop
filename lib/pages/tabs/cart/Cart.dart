// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_jdshop/provider/UserProvider.dart';
import 'package:flutter_jdshop/widget/Toast.dart';
import 'package:provider/provider.dart';
import 'CartItem.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../provider/CartProvider.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  var _isEditing = false;
  late UserProvider _userProvider;
  late CartProvider _cartProvider;

  void _checkout() {
    if (!_userProvider.isLogin) {
      toastMessage("请先登录");
      Navigator.pushNamed(context, '/login');
      return;
    }
    if (_cartProvider.list.isEmpty) {
      toastMessage("暂无商品");
      return;
    }
    Navigator.pushNamed(context, '/checkout');
  }

  @override
  Widget build(BuildContext context) {
    _cartProvider = Provider.of<CartProvider>(context);
    _userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("购物车"),
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  _isEditing = !_isEditing;
                });
              },
              child: Text(_isEditing ? "取消" : "编辑",
                  style: TextStyle(color: Colors.black, fontSize: 12.sp)))
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView(
            children:
                _cartProvider.list.map((e) => CartItem(model: e)).toList(),
          )),
          Container(
            decoration: const BoxDecoration(
                border:
                    Border(top: BorderSide(width: 1, color: Colors.black12))),
            height: 45.h,
            child: Stack(children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Row(
                    children: [
                      Checkbox(
                          value: _cartProvider.isSelectedAll,
                          activeColor: Colors.red,
                          onChanged: (value) {
                            _cartProvider.updateAll(isSelected: value ?? true);
                          }),
                      Text("全选",
                          style:
                              TextStyle(color: Colors.black, fontSize: 12.sp)),
                      if (!_isEditing)
                        Row(
                          children: [
                            SizedBox(width: 16.w),
                            Text("总计: ",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12.sp)),
                            Text("￥${_cartProvider.totalPrices}",
                                style: TextStyle(
                                    color: Colors.red, fontSize: 14.sp))
                          ],
                        )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.only(right: 16.w),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red)),
                    onPressed: () {
                      if (_isEditing) {
                        _cartProvider.deleteSelectedProducts();
                      } else {
                        _checkout();
                      }
                    },
                    child: Text(
                      _isEditing ? "删除" : "结算",
                      style: TextStyle(color: Colors.white, fontSize: 12.sp),
                    ),
                  ),
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}
