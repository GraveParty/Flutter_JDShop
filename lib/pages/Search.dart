// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/SearchService.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? _textFieldValue;
  List _searchHistoryList = [];

  @override
  initState() {
    super.initState();
    _getSearchHistory();
  }

  void _getSearchHistory() async {
    var list = await SearchService.getList();
    setState(() {
      _searchHistoryList = list;
    });
  }

  Widget _createTitle(String title) {
    return Container(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 16.sp, color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _createHotItem(String title) {
    return Container(
      margin: EdgeInsets.only(left: 4.w, right: 4.w, top: 4.h, bottom: 4.h),
      padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 4.h, bottom: 4.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4.w)),
          color: const Color.fromRGBO(233, 233, 233, 0.9)),
      child: Text(title),
    );
  }

  Widget _createHistoryItem(String title) {
    return InkWell(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(left: 16.w),
            height: 48,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(title),
                )
              ],
            ),
          ),
          Divider(
            height: 1.h,
          ),
        ],
      ),
      onLongPress: () async {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: const Text("确认删除吗？"),
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
                        await SearchService.removeData(title);
                        _getSearchHistory();
                        Navigator.pop(context);
                      },
                      child: const Text("确认",
                          style: TextStyle(color: Colors.black))),
                ],
              );
            });
      },
    );
  }

  Widget _createBody() {
    return ListView(
      children: [
        _createTitle("热搜"),
        Container(
          padding:
              EdgeInsets.only(left: 12.w, right: 12.w, top: 4.h, bottom: 8.h),
          child: Wrap(
            children: [
              _createHotItem("超级秒杀"),
              _createHotItem("办公电脑"),
              _createHotItem("儿童小汽车"),
              _createHotItem("唇彩唇蜜"),
              _createHotItem("唇彩唇蜜"),
            ],
          ),
        ),
        Container(height: 8.h, color: const Color.fromRGBO(233, 233, 233, 0.9)),
        if (_searchHistoryList.isNotEmpty) _createTitle("历史搜索"),
        Column(
          children:
              _searchHistoryList.map((e) => _createHistoryItem(e)).toList(),
        ),
        if (_searchHistoryList.isNotEmpty)
          Container(
              margin: EdgeInsets.all(16.w),
              padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
              decoration: BoxDecoration(border: Border.all()),
              child: InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.delete),
                    Text("清空历史记录"),
                  ],
                ),
                onTap: () async {
                  await SearchService.clear();
                  _getSearchHistory();
                },
              )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 28.h,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(233, 233, 233, 0.8),
            borderRadius: BorderRadius.all(Radius.circular(14.w)),
          ),
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.text,
            autofocus: true,
            //文字居中：BorderSide.none + EdgeInsets.symmetric(vertical: -10)
            decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: -10, horizontal: 16.w),
                hintText: '输入关键词'),
            onChanged: (value) {
              _textFieldValue = value;
            },
          ),
        ),
        actions: [
          InkWell(
              child: Container(
                padding: EdgeInsets.only(left: 8.w, right: 16.w),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "搜索",
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    )
                  ],
                ),
              ),
              onTap: () async {
                var value = _textFieldValue;
                if (value != null) {
                  await SearchService.setData(value);
                  Navigator.pushReplacementNamed(context, "/productList",
                      arguments: {
                        "search": value,
                      });
                }
              })
        ],
      ),
      body: _createBody(),
    );
  }
}
