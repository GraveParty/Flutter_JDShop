// ignore_for_file: file_names
import '../models/ProductDetailModel.dart';
import 'Storage.dart';
import 'dart:convert';

class CartService {
  static const key = "cartService";

  static Future<List<ProductDetailModel>> getProductList() async {
    List<ProductDetailModel> cartList = [];
    try {
      String? stringList = await Storage.getString(key);
      if (stringList != null) {
        final list = json.decode(stringList);
        if (list is List) {
          cartList = list.map((e) {
            return ProductDetailModel.fromJson(e);
          }).toList();
        }
      }
      // ignore: empty_catches
    } catch (e) {}
    return cartList;
  }

  static Future<void> addProduct(ProductDetailModel model) async {
    final cartList = await getProductList();
    var exist = false;
    for (final element in cartList) {
      if (element.sId == model.sId &&
          element.selectedTagsStr == model.selectedTagsStr) {
        element.count += 1;
        exist = true;
        break;
      }
    }
    if (!exist) {
      cartList.add(model);
    }
    await Storage.setString(
        key, json.encode(cartList.map((e) => e.toJson()).toList()));
  }

  static Future<void> updateProducts(List<ProductDetailModel> list) async {
    final cartList = await getProductList();
    outerloop:
    for (final newProduct in list) {
      for (int i = 0; i < cartList.length; i++) {
        final existProduct = cartList[i];
        if (newProduct.sId == existProduct.sId &&
            newProduct.selectedTagsStr == existProduct.selectedTagsStr) {
          cartList[i] = newProduct;
          continue outerloop;
        }
      }
      cartList.add(newProduct);
    }
    await Storage.setString(
        key, json.encode(cartList.map((e) => e.toJson()).toList()));
  }

  static Future<void> updateAll({required bool isSelected}) async {
    final cartList = await getProductList();
    for (final product in cartList) {
      product.isSelected = isSelected;
    }
    await Storage.setString(
        key, json.encode(cartList.map((e) => e.toJson()).toList()));
  }

  static Future<void> deleteProducts(List<ProductDetailModel> list) async {
    final cartList = await getProductList();
    outerloop:
    for (final newProduct in list) {
      for (int i = 0; i < cartList.length; i++) {
        final existProduct = cartList[i];
        if (newProduct.sId == existProduct.sId &&
            newProduct.selectedTagsStr == existProduct.selectedTagsStr) {
          cartList.removeAt(i);
          continue outerloop;
        }
      }
    }
    await Storage.setString(
        key, json.encode(cartList.map((e) => e.toJson()).toList()));
  }
}
