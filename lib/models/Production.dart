// ignore_for_file: file_names

class ProductionResponse {
  List<ProductionItem> result = [];

  ProductionResponse({this.result = const []});

  ProductionResponse.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <ProductionItem>[];
      json['result'].forEach((v) {
        result.add(ProductionItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result.map((v) => v.toJson()).toList();
    return data;
  }
}

class ProductionItem {
  String? sId;
  String? title;
  String? cid;
  Object? price;
  Object? oldPrice;
  String? pic;
  String? sPic;

  ProductionItem({sId, title, cid, price, oldPrice, pic, sPic});

  ProductionItem.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    cid = json['cid'];
    price = json['price'];
    oldPrice = json['old_price'];
    pic = json['pic'];
    sPic = json['s_pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['cid'] = cid;
    data['price'] = price;
    data['old_price'] = oldPrice;
    data['pic'] = pic;
    data['s_pic'] = sPic;
    return data;
  }
}

class ProductionListFilterModel {
  final String title;
  final String? paramPrefix;
  var sort = 1;
  var isSelected = false;
  bool hasArrow;

  ProductionListFilterModel(
      {required this.title, this.paramPrefix, this.hasArrow = false});

  String get param {
    if (paramPrefix == null) {
      return "";
    } else {
      return "${paramPrefix}_$sort";
    }
  }

  void changeSort() {
    sort *= -1;
  }
}
