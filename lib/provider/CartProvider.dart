// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../models/ProductDetailModel.dart';
import '../services/CartService.dart';

class CartProvider with ChangeNotifier {
  List<ProductDetailModel> _list = [];
  List<ProductDetailModel> get list => _list;

  bool get isSelectedAll {
    return !list.any((element) => !element.isSelected);
  }

  double get totalPrices {
    double total = 0;
    for (final product in list) {
      if (!product.isSelected) {
        continue;
      }
      var price = product.price ?? 0;
      if (price is num) {
        total += price * product.count;
      } else if (price is String) {
        total += double.parse(price) * product.count;
      }
    }
    return total;
  }

  CartProvider() {
    reload();
  }

  Future<void> reload() async {
    _list = await CartService.getProductList();
    notifyListeners();
  }

  Future<void> addProduct(ProductDetailModel model) async {
    await CartService.addProduct(model);
    await reload();
  }

  Future<void> deleteSelectedProducts() async {
    var tmp = <ProductDetailModel>[];
    for (final product in list) {
      if (product.isSelected) {
        tmp.add(product);
      }
    }
    await deleteProducts(tmp);
  }

  Future<void> deleteProducts(List<ProductDetailModel> list) async {
    await CartService.deleteProducts(list);
    await reload();
  }

  Future<void> updateProducts(List<ProductDetailModel> list) async {
    await CartService.updateProducts(list);
    await reload();
  }

  Future<void> updateAll({required bool isSelected}) async {
    await CartService.updateAll(isSelected: isSelected);
    await reload();
  }
}
