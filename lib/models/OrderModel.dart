// ignore_for_file: file_names

class OrderModel {
  String? id;
  String? uid;
  String? name;
  String? phone;
  String? address;
  String? allPrice;
  int payStatus = 0;
  int orderStatus = 0;
  List<OrderItemModel> orderItems = [];

  OrderModel.fromJson(Map map) {
    id = "${map["_id"]}";
    uid = "${map["uid"]}";
    name = "${map["name"]}";
    phone = "${map["phone"]}";
    address = "${map["address"]}";
    allPrice = "${map["all_price"]}";
    payStatus = map["pay_status"] ?? 0;
    orderStatus = map["order_status"] ?? 0;
    List items = map["order_item"];
    if (items is List) {
      orderItems = items.map((e) {
        return OrderItemModel.fromJson(e);
      }).toList();
    }
  }
}

class OrderItemModel {
  String? id;
  String? orderID;
  String? productTitle;
  String? productID;
  int productPrice = 0;
  String? productImg;
  int productCount = 0;
  String? selectedAttr;
  int addTime = 0;

  OrderItemModel.fromJson(Map map) {
    id = "${map["_id"]}";
    orderID = "${map["order_id"]}";
    productTitle = "${map["product_title"]}";
    productID = "${map["product_id"]}";
    productPrice = map["product_price"] ?? 0;
    productImg = "${map["product_img"]}";
    productCount = map["product_count"] ?? 0;
    selectedAttr = "${map["selected_attr"]}";
    addTime = map["add_time"] ?? 0;
  }
}
