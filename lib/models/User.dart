// ignore_for_file: file_names

class User {
  String? id;
  String? username;
  String? tel;
  String? salt;

  User.fromJson(Map map) {
    id = "${map["_id"]}";
    username = "${map["username"]}";
    tel = "${map["tel"]}";
    salt = "${map["salt"]}";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['username'] = username;
    data['tel'] = tel;
    data['salt'] = salt;
    return data;
  }
}
