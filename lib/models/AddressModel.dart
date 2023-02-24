// ignore_for_file: file_names

class AddressModel {
  String? id;
  String? uid;
  String? name;
  String? phone;
  String? address;
  int defaultAddress = 0;
  int status = 1;
  String? addTime;

  AddressModel.fromJson(Map map) {
    id = "${map["_id"]}";
    uid = "${map["uid"]}";
    name = "${map["name"]}";
    phone = "${map["phone"]}";
    address = "${map["address"]}";
    defaultAddress = map["default_address"] ?? 0;
    status = map["status"] ?? 1;
    addTime = "${map["add_time"]}";
  }
}
