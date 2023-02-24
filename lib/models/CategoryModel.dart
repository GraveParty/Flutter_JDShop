// ignore_for_file: file_names

class CategoryResponse {
  List<CategoryItem> result = [];

  CategoryResponse({result = const []});

  CategoryResponse.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <CategoryItem>[];
      json['result'].forEach((v) {
        result.add(CategoryItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result.map((v) => v.toJson()).toList();
    return data;
  }
}

class CategoryItem {
  String? sId;
  String? title;
  Object? status;
  String? pic;
  String? pid;
  String? sort;

  CategoryItem({sId, title, status, pic, pid, sort});

  CategoryItem.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    status = json['status'];
    pic = json['pic'];
    pid = json['pid'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['status'] = status;
    data['pic'] = pic;
    data['pid'] = pid;
    data['sort'] = sort;
    return data;
  }
}
