// ignore_for_file: file_names

class ProductDetailResponse {
  ProductDetailModel? result;

  ProductDetailResponse({this.result});

  ProductDetailResponse.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null
        ? ProductDetailModel.fromJson(json['result'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class ProductDetailModel {
  String? sId;
  String? title;
  String? cid;
  Object? price;
  Object? oldPrice;
  Object? isBest;
  Object? isHot;
  Object? isNew;
  String? status;
  String? pic;
  String? content;
  String? cname;
  List<ProductDetailAttr> attr = [];
  String? subTitle;
  Object? salecount;

  //自定义
  int count = 1;
  bool isSelected = true;
  String get selectedTagsStr {
    var tags = [];
    for (final a in attr) {
      for (final t in a.list) {
        if (t.isSelected) {
          tags.add(t.name);
        }
      }
    }
    return tags.isEmpty ? "无" : tags.join("，");
  }

  ProductDetailModel(
      {this.sId,
      this.title,
      this.cid,
      this.price,
      this.oldPrice,
      this.isBest,
      this.isHot,
      this.isNew,
      this.status,
      this.pic,
      this.content,
      this.cname,
      this.attr = const [],
      this.subTitle,
      this.salecount,
      this.count = 1});

  ProductDetailModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    cid = json['cid'];
    price = json['price'];
    oldPrice = json['old_price'];
    isBest = json['is_best'];
    isHot = json['is_hot'];
    isNew = json['is_new'];
    status = json['status'];
    pic = json['pic'];
    content = json['content'];
    cname = json['cname'];
    if (json['attr'] != null) {
      attr = <ProductDetailAttr>[];
      json['attr'].forEach((v) {
        attr.add(ProductDetailAttr.fromJson(v));
      });
    }
    subTitle = json['sub_title'];
    salecount = json['salecount'];

    count = json['count'] ?? 1;
    isSelected = json['isSelected'] ?? true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['cid'] = cid;
    data['price'] = price;
    data['old_price'] = oldPrice;
    data['is_best'] = isBest;
    data['is_hot'] = isHot;
    data['is_new'] = isNew;
    data['status'] = status;
    data['pic'] = pic;
    data['content'] = content;
    data['cname'] = cname;
    data['attr'] = attr.map((v) => v.toJson()).toList();
    data['sub_title'] = subTitle;
    data['salecount'] = salecount;

    data['count'] = count;
    data['isSelected'] = isSelected;
    return data;
  }
}

class ProductDetailAttr {
  late String cate;
  List<ProductDetailTag> list = [];

  ProductDetailAttr({required this.cate, this.list = const []});

  ProductDetailAttr.fromJson(Map<String, dynamic> json) {
    cate = json['cate'] ?? "";
    final jsonList = json['list'];
    if (jsonList is List) {
      for (final element in jsonList) {
        if (element is String) {
          list.add(ProductDetailTag(name: element, isSelected: false));
        } else if (element is Map) {
          list.add(ProductDetailTag.fromJson(element));
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cate'] = cate;
    data['list'] = list.map((e) => e.toJson()).toList();
    return data;
  }

  void selectTag(ProductDetailTag tag) {
    if (!list.contains(tag)) {
      return;
    }
    if (tag.isSelected) {
      tag.isSelected = false;
    } else {
      for (final tmp in list) {
        tmp.isSelected = false;
      }
      tag.isSelected = true;
    }
  }
}

class ProductDetailTag {
  late String name;
  late bool isSelected;

  ProductDetailTag({required this.name, required this.isSelected});
  ProductDetailTag.fromJson(Map<dynamic, dynamic> json) {
    name = json["name"] ?? "";
    isSelected = json["isSelected"] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['isSelected'] = isSelected;
    return data;
  }
}
