// ignore_for_file: file_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jdshop/config/Config.dart';
import 'package:flutter_jdshop/event/EventBus.dart';
import 'package:flutter_jdshop/models/AddressModel.dart';
import 'package:flutter_jdshop/services/UserService.dart';
import 'package:flutter_jdshop/widget/Toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressListPage extends StatefulWidget {
  const AddressListPage({Key? key}) : super(key: key);

  @override
  State<AddressListPage> createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  List<AddressModel> _list = [];
  @override
  void initState() {
    super.initState();
    eventBus.on<AddressListRefreshEvent>().listen((event) {
      _loadData();
    });
    _loadData();
  }

  Future<void> _loadData() async {
    final user = await UserService.getUser();
    if (user == null) {
      toastMessage("请先登录");
      return;
    }

    final api = Config.api("api/addressList");
    final sign = Config.sign({"uid": user.id, "salt": user.salt});
    final response = await Dio().get(api, queryParameters: {
      "uid": user.id,
      "sign": sign,
    });

    List resList = response.data["result"] ?? [];
    setState(() {
      _list = resList.map((e) {
        return AddressModel.fromJson(e);
      }).toList();
    });
  }

  Future<void> _changeDefaultAddress(AddressModel model) async {
    final user = await UserService.getUser();
    if (user == null) {
      toastMessage("请先登录");
      return;
    }

    final sign = Config.sign({
      "uid": user.id,
      "id": model.id,
      "salt": user.salt,
    });
    final api = Config.api("api/changeDefaultAddress");
    final response = await Dio().post(api, data: {
      "uid": user.id,
      "id": model.id,
      "sign": sign,
    });
    final success = response.data["success"];
    if (success == true) {
      eventBus.fire(AddressChangeDefaultEvent());
      Navigator.pop(context);
    } else {
      toastMessage("${response.data["message"]}");
    }
  }

  Future<void> _deleteAddress(AddressModel model) async {
    final user = await UserService.getUser();
    if (user == null) {
      toastMessage("请先登录");
      return;
    }

    final sign = Config.sign({
      "uid": user.id,
      "id": model.id,
      "salt": user.salt,
    });
    final api = Config.api("api/deleteAddress");
    final response = await Dio().post(api, data: {
      "uid": user.id,
      "id": model.id,
      "sign": sign,
    });
    final success = response.data["success"];
    if (success == true) {
      await _loadData();
    } else {
      toastMessage("${response.data["message"]}");
    }
  }

  Widget _createAddressItemWidget(AddressModel model) {
    return Column(
      children: [
        Container(
          padding:
              EdgeInsets.only(left: 16.w, right: 16.w, top: 8.w, bottom: 8.w),
          child: Row(
            children: [
              if (model.defaultAddress == 1)
                const Icon(Icons.check, color: Colors.red),
              if (model.defaultAddress == 1) SizedBox(width: 16.w),
              Expanded(
                  child: InkWell(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${model.name} ${model.phone}",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 14.sp)),
                          Text("${model.address}",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 12.sp)),
                        ],
                      ),
                      onTap: () {
                        _changeDefaultAddress(model);
                      },
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("确认删除该地址吗？"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "取消",
                                        style: TextStyle(color: Colors.black),
                                      )),
                                  TextButton(
                                      onPressed: () async {
                                        await _deleteAddress(model);
                                        Navigator.pop(context);
                                      },
                                      child: const Text("确认",
                                          style: TextStyle(color: Colors.red))),
                                ],
                              );
                            });
                      })),
              SizedBox(width: 16.w),
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/addressEdit', arguments: {
                      "model": model,
                    });
                  },
                  icon: const Icon(Icons.edit, color: Colors.blue)),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("收货地址"),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView(
                  children: _list.map((e) {
            return _createAddressItemWidget(e);
          }).toList())),
          InkWell(
            child: Container(
              height: 48.h,
              width: double.infinity,
              color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add, color: Colors.white),
                  Text("新增收货地址",
                      style: TextStyle(color: Colors.white, fontSize: 14.sp))
                ],
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/addressEdit');
            },
          )
        ],
      ),
    );
  }
}
