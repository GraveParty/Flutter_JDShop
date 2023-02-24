// ignore_for_file: file_names

class FocusResponse {
  List<FocusItem> result = [];

  FocusResponse({this.result = const []});

  FocusResponse.fromJson(Map<String, dynamic> json) {
    final list = json['result'];
    if (list != null && list is List) {
      result = <FocusItem>[];
      for (var v in list) {
        result.add(FocusItem.fromJson(v));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result.map((v) => v.toJson()).toList();
    return data;
  }
}

class FocusItem {
  String? sId;
  String? title;
  String? status;
  String? pic;
  String? url;

  FocusItem({this.sId, this.title, this.status, this.pic, this.url});

  FocusItem.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    status = json['status'];
    pic = json['pic'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['status'] = status;
    data['pic'] = pic;
    data['url'] = url;
    return data;
  }
}
