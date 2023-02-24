// ignore_for_file: file_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jdshop/config/Config.dart';
import 'package:flutter_jdshop/event/EventBus.dart';
import 'package:flutter_jdshop/models/AddressModel.dart';
import 'package:flutter_jdshop/services/UserService.dart';
import 'package:flutter_jdshop/widget/ColorButton.dart';
import 'package:flutter_jdshop/widget/JDTextField.dart';
import 'package:flutter_jdshop/widget/Toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:city_pickers/city_pickers.dart';

class AddressEditPage extends StatefulWidget {
  Map? arguments;
  AddressEditPage({Key? key, this.arguments}) : super(key: key);

  @override
  State<AddressEditPage> createState() => _AddressEditPageState();
}

class _AddressEditPageState extends State<AddressEditPage> {
  AddressModel? model;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  Result? _areaResult;
  String get _areaText {
    if (_areaResult == null) {
      return "省/市/区";
    }
    final list = [
      _areaResult!.provinceName,
      _areaResult!.cityName,
      _areaResult!.areaName
    ];
    list.removeWhere((element) => element == null);
    return list.join("/");
  }

  @override
  void initState() {
    super.initState();
    model = widget.arguments?["model"];
    _nameController.text = model?.name ?? "";
    _phoneController.text = model?.phone ?? "";
    _addressController.text = model?.address ?? "";
  }

  void _addAddress() async {
    final _name = _nameController.text;
    final _phone = _phoneController.text;
    final _address = _addressController.text;
    if (_name.isEmpty ||
        _phone.isEmpty ||
        _address.isEmpty ||
        _areaText.isEmpty) {
      toastMessage("请填写完整信息");
      return;
    }

    final user = await UserService.getUser();
    if (user == null) {
      toastMessage("请先登录");
      return;
    }

    final sign = Config.sign({
      "uid": user.id,
      "name": _name,
      "phone": _phone,
      "address": _address,
      "salt": user.salt,
    });
    final api = Config.api("api/addAddress");
    final response = await Dio().post(api, data: {
      "uid": user.id,
      "name": _name,
      "phone": _phone,
      "address": _address,
      "sign": sign,
    });
    final success = response.data["success"];
    if (success == true) {
      eventBus.fire(AddressListRefreshEvent());
      Navigator.pop(context);
    } else {
      toastMessage("${response.data["message"]}");
    }
  }

  void _editAddress() async {
    final _name = _nameController.text;
    final _phone = _phoneController.text;
    final _address = _addressController.text;
    if (_name.isEmpty ||
        _phone.isEmpty ||
        _address.isEmpty ||
        _areaText.isEmpty) {
      toastMessage("请填写完整信息");
      return;
    }

    final user = await UserService.getUser();
    if (user == null) {
      toastMessage("请先登录");
      return;
    }

    final sign = Config.sign({
      "uid": user.id,
      "id": model?.id,
      "name": _name,
      "phone": _phone,
      "address": _address,
      "salt": user.salt,
    });
    final api = Config.api("api/editAddress");
    final response = await Dio().post(api, data: {
      "uid": user.id,
      "id": model?.id,
      "name": _name,
      "phone": _phone,
      "address": _address,
      "sign": sign,
    });
    final success = response.data["success"];
    if (success == true) {
      eventBus.fire(AddressListRefreshEvent());
      Navigator.pop(context);
    } else {
      toastMessage("${response.data["message"]}");
    }
  }

  Widget _createAreaWidget() {
    return InkWell(
      child: Container(
        height: 44.w,
        padding: EdgeInsets.only(left: 16.w, right: 16.w),
        decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.black12, width: 1))),
        child: Row(
          children: [
            const Icon(Icons.add_location),
            Text(
              _areaText,
              style: TextStyle(
                  color: _areaResult == null ? Colors.grey : Colors.black,
                  fontSize: 14.sp),
            ),
          ],
        ),
      ),
      onTap: () async {
        Result? result = await CityPickers.showCityPicker(
          context: context,
        );
        if (result != null) {
          setState(() {
            _areaResult = result;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${model == null ? "增加" : "编辑"}收货地址")),
      body: ListView(
        children: [
          JDTextField(
            controller: _nameController,
            placeholder: "收件人姓名",
            padding: EdgeInsets.only(left: 16.w),
          ),
          JDTextField(
            controller: _phoneController,
            placeholder: "收件人电话号码",
            padding: EdgeInsets.only(left: 16.w),
          ),
          _createAreaWidget(),
          JDTextField(
            controller: _addressController,
            placeholder: "详细地址",
            padding: EdgeInsets.only(left: 16.w),
            maxLines: 3,
            height: 66.h,
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 16.w),
              height: 76.w,
              child: ColorButton(
                  text: model == null ? "增加" : "完成", color: Colors.red),
            ),
            onTap: () {
              if (model == null) {
                _addAddress();
              } else {
                _editAddress();
              }
            },
          )
        ],
      ),
    );
  }
}
