// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/Config.dart';
import 'package:dio/dio.dart';
import '../../models/CategoryModel.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with AutomaticKeepAliveClientMixin {
  var _leftResponse = CategoryResponse();
  var _rightResponse = CategoryResponse();
  int _selectedLeftIndex = 0;

  @override
  void initState() {
    super.initState();
    _getLeftData();
  }

  @override
  bool get wantKeepAlive => true;

  void _getLeftData() async {
    final response = await Dio().get(Config.api("api/pcate"));
    setState(() {
      _leftResponse = CategoryResponse.fromJson(response.data);
      _getRightData(_leftResponse.result.first.sId);
    });
  }

  void _getRightData(String? id) async {
    if (id == null) {
      return;
    }
    final response = await Dio().get(Config.api("api/pcate"), queryParameters: {
      "pid": id,
    });
    if (_selectedLeftIndex < _leftResponse.result.length) {
      final leftItem = _leftResponse.result[_selectedLeftIndex];
      if (id != leftItem.sId) {
        return;
      }
      setState(() {
        _rightResponse = CategoryResponse.fromJson(response.data);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final leftListViewWidth = 1.sw / 4;
    final rightListViewWidth = 1.sw - leftListViewWidth;
    final rightItemHSpacing = 8.w;
    final rightItemWidth = (rightListViewWidth - rightItemHSpacing * 4) / 3;
    final rightItemHeight = rightItemWidth + 22.h;

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
            child: Container(
              padding: EdgeInsets.only(left: 16.w),
              height: 28.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(14.w)),
                color: const Color.fromRGBO(233, 233, 233, 0.8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.search),
                  SizedBox(
                    width: 8.w,
                  ),
                  Text(
                    "笔记本",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, "/search");
            }),
        leading: IconButton(
          icon: const Icon(
            Icons.center_focus_weak,
            size: 28,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.message,
              size: 28,
              color: Colors.black,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Row(children: [
        Container(
          padding: EdgeInsets.only(top: 8.h),
          width: leftListViewWidth,
          height: double.infinity,
          child: ListView.builder(
            itemCount: _leftResponse.result.length,
            itemBuilder: (context, index) {
              final item = _leftResponse.result[index];
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 42.h,
                    color: _selectedLeftIndex == index
                        ? const Color.fromRGBO(240, 246, 246, 0.9)
                        : Colors.transparent,
                    child: TextButton(
                      child: Text(
                        item.title ?? "",
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedLeftIndex = index;
                          _getRightData(item.sId);
                        });
                      },
                    ),
                  ),
                  Divider(
                    height: 1.h,
                  )
                ],
              );
            },
          ),
        ),
        Expanded(
            child: Container(
          padding: EdgeInsets.all(8.w),
          color: const Color.fromRGBO(240, 246, 246, 0.9),
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: rightItemHSpacing,
                crossAxisSpacing: 8.h,
                childAspectRatio: rightItemWidth / rightItemHeight,
              ),
              itemCount: _rightResponse.result.length,
              itemBuilder: (context, index) {
                final item = _rightResponse.result[index];
                final picURL = Config.picture(item.pic);
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/productList', arguments: {
                      "cid": item.sId ?? "",
                    });
                  },
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: Image.network(picURL, fit: BoxFit.cover),
                      ),
                      Expanded(
                        child: Text(
                          item.title ?? "",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }),
        ))
      ]),
    );
  }
}
