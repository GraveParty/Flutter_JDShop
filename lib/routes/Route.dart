// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_jdshop/pages/Address/AddressEdit.dart';
import 'package:flutter_jdshop/pages/Address/AddressList.dart';
import 'package:flutter_jdshop/pages/Checkout.dart';
import 'package:flutter_jdshop/pages/OrderDetail.dart';
import 'package:flutter_jdshop/pages/OrderList.dart';
import 'package:flutter_jdshop/pages/Pay.dart';
import '../pages/tabs/Tabs.dart';
import '../pages/Search.dart';
import '../pages/ProductionList.dart';
import '../pages/ProductDetail/ProductDetail.dart';
import '../pages/tabs/cart/Cart.dart';
import '../pages/Login.dart';
import '../pages/RegisterPhone.dart';
import '../pages/RegisterCode.dart';
import '../pages/RegisterPassword.dart';

//配置路由
final routes = {
  '/': (context) => const Tabs(),
  '/search': (context) => const SearchPage(),
  '/cart': (context) => const CartPage(),
  '/productList': (context, [arguments]) =>
      ProductionListPage(arguments: arguments),
  '/productDetail': (context, [arguments]) =>
      ProductDetailPage(arguments: arguments),
  '/login': (context) => const LoginPage(),
  '/registerPhone': (context) => const RegisterPhonePage(),
  '/registerCode': (context, [arguments]) =>
      RegisterCodePage(arguments: arguments),
  '/registerPassword': (context, [arguments]) =>
      RegisterPasswordPage(arguments: arguments),
  '/checkout': (context) => const CheckoutPage(),
  '/addressList': (context) => const AddressListPage(),
  '/addressEdit': (context, [arguments]) =>
      AddressEditPage(arguments: arguments),
  '/pay': (context) => const PayPage(),
  '/orderList': (context) => const OrderListPage(),
  '/orderDetail': (context, [arguments]) => OrderDetailPage(
        arguments: arguments,
      ),
};
//固定写法
Route<dynamic>? onGenerateRoute(RouteSettings settings) {
// 统一处理
  final String? name = settings.name;
  final Function? pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      /*
      这里要加上settings: settings的入参，
      否则其他地方在执行ModalRoute.withName("xxx")的时候，会因为取不到setting.name导致始终是false
      */
      final Route route = MaterialPageRoute(
          builder: (context) => pageContentBuilder(context, settings.arguments),
          settings: settings);
      return route;
    } else {
      final Route route = MaterialPageRoute(
          builder: (context) => pageContentBuilder(context),
          settings: settings);
      return route;
    }
  } else {
    return null;
  }
}
