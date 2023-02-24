// ignore_for_file: file_names

import 'dart:convert';
import 'Storage.dart';

class SearchService {
  static const key = "searchList";

  static Future<void> setData(String value) async {
    List searchList = [];
    try {
      var string = await Storage.getString(key) ?? "";
      searchList = json.decode(string);
      // ignore: empty_catches
    } catch (e) {}
    if (!searchList.any((element) => element == value)) {
      searchList.add(value);
    }
    await Storage.setString(key, json.encode(searchList));
  }

  static Future<List> getList() async {
    List searchList = [];
    try {
      var string = await Storage.getString(key) ?? "";
      searchList = json.decode(string);
      // ignore: empty_catches
    } catch (e) {}
    return searchList;
  }

  static Future<void> clear() async {
    await Storage.remove(key);
  }

  static Future<void> removeData(String value) async {
    var list = await getList();
    list.remove(value);
    await Storage.setString(key, json.encode(list));
  }
}
