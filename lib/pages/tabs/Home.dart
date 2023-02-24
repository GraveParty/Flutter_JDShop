// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import '../../config/Config.dart';
import '../../models/FocusModel.dart';
import '../../models/Production.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  var _focusResponse = FocusResponse();
  var _hotProductionResponse = ProductionResponse();
  var _bestProductionResponse = ProductionResponse();

  @override
  initState() {
    super.initState();
    _getFocusData();
    _getHotProductionData();
    _getBestProductionData();
  }

  @override
  bool get wantKeepAlive => true;

  //轮播图数据
  void _getFocusData() async {
    final response = await Dio().get(Config.api("api/focus"));
    setState(() {
      _focusResponse = FocusResponse.fromJson(response.data);
    });
  }

  //猜你喜欢数据
  void _getHotProductionData() async {
    final response = await Dio().get(Config.api("api/plist"), queryParameters: {
      "is_hot": "1",
    });
    setState(() {
      _hotProductionResponse = ProductionResponse.fromJson(response.data);
    });
  }

  //热门推荐数据
  void _getBestProductionData() async {
    final response = await Dio().get(Config.api("api/plist"), queryParameters: {
      "is_best": "1",
    });
    setState(() {
      _bestProductionResponse = ProductionResponse.fromJson(response.data);
    });
  }

  Widget _swipeWidget() {
    return AspectRatio(
      aspectRatio: 2,
      child: Swiper(
          itemBuilder: (context, index) {
            final url = Config.picture(_focusResponse.result[index].pic);
            return Image.network(url, fit: BoxFit.fill);
          },
          itemCount: _focusResponse.result.length,
          autoplay: true,
          pagination: const SwiperPagination()),
    );
  }

  Widget _titleWidget(String title) {
    return Container(
      margin: EdgeInsets.only(left: 16.w),
      padding: EdgeInsets.only(left: 10.w),
      decoration: BoxDecoration(
          border: Border(left: BorderSide(width: 8.w, color: Colors.red))),
      child: Text(
        title,
        style: TextStyle(fontSize: 16.sp),
      ),
    );
  }

  Widget _hotProductListWidget() {
    return SizedBox(
      width: double.infinity,
      height: 90.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = _hotProductionResponse.result[index];
          final picURL = Config.picture(item.sPic);
          return Container(
              margin:
                  EdgeInsets.only(right: 16.w, left: index == 0 ? 16.w : 0.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60.h,
                    width: 60.w,
                    child: Image.network(
                      picURL,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  SizedBox(
                    height: 22.h,
                    child: Text(
                      "￥${item.price}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                ],
              ));
        },
        itemCount: _hotProductionResponse.result.length,
      ),
    );
  }

  Widget _recProductItemWidget() {
    final itemWidth = (1.sw - 26.w) / 2;

    return Container(
      margin: EdgeInsets.all(8.w),
      child: Wrap(
        spacing: 10.w,
        runSpacing: 10.h,
        children: _bestProductionResponse.result.map((e) {
          final picURL = Config.picture(e.pic);
          return InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/productDetail',
                    arguments: {"id": e.sId});
              },
              child: Container(
                  width: itemWidth,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12, width: 1)),
                  padding: EdgeInsets.all(8.w),
                  child: Column(
                    children: [
                      Image.network(picURL, fit: BoxFit.cover),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(
                        e.title ?? "",
                        style: const TextStyle(
                          color: Colors.black54,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("￥${e.price}",
                                style: TextStyle(
                                    color: Colors.red, fontSize: 16.sp)),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text("￥${e.oldPrice}",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12.sp,
                                    decoration: TextDecoration.lineThrough)),
                          )
                        ],
                      )
                    ],
                  )));
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      body: ListView(
        children: [
          _swipeWidget(),
          SizedBox(height: 10.h),
          _titleWidget("猜你喜欢"),
          SizedBox(height: 10.h),
          _hotProductListWidget(),
          SizedBox(height: 10.h),
          _titleWidget("热门推荐"),
          _recProductItemWidget(),
        ],
      ),
    );
  }
}
