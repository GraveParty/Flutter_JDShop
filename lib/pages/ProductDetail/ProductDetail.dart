// ignore_for_file: file_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'ProductDetailIntro.dart';
import 'ProductDetailInfo.dart';
import 'ProductDetailComment.dart';
import '../../widget/ColorButton.dart';
import '../../config/Config.dart';
import '../../models/ProductDetailModel.dart';
import '../../widget/Loading.dart';
import '../../event/EventBus.dart';

class ProductDetailPage extends StatefulWidget {
  final Map? arguments;
  const ProductDetailPage({Key? key, this.arguments}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  ProductDetailResponse? _response;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    String? id = widget.arguments?["id"];
    if (id == null) {
      return;
    }

    final api = Config.api("api/pcontent");
    final response = await Dio().get(api, queryParameters: {"id": id});
    setState(() {
      _response = ProductDetailResponse.fromJson(response.data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
              title: const Center(
                child: TabBar(
                  indicatorColor: Colors.red,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    Tab(
                        child: Text(
                      "商品",
                      style: TextStyle(color: Colors.black),
                    )),
                    Tab(
                        child: Text(
                      "详情",
                      style: TextStyle(color: Colors.black),
                    )),
                    Tab(
                        child: Text(
                      "评价",
                      style: TextStyle(color: Colors.black),
                    )),
                  ],
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(
                              1.sw - 216.w, 66.h, 16.w, 0),
                          items: [
                            PopupMenuItem(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [Icon(Icons.home), Text("首页")],
                            )),
                            PopupMenuItem(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [Icon(Icons.home), Text("首页")],
                            ))
                          ]);
                    },
                    icon: const Icon(Icons.more_horiz))
              ]),
          body: Column(
            children: [
              Expanded(
                  child: TabBarView(
                children: _response?.result == null
                    ? const [Loading(), Loading(), Loading()]
                    : [
                        ProductDetailIntroPage(model: _response!.result!),
                        ProductDetailInfoPage(model: _response!.result!),
                        ProductDetailCommentPage(model: _response!.result!)
                      ],
              )),
              SizedBox(
                  width: 1.sw,
                  height: 70.h,
                  child: Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            top: BorderSide(color: Colors.black26, width: 1))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
                          padding: EdgeInsets.only(left: 16.w),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/cart');
                            },
                            child: Column(
                              children: const [
                                Icon(Icons.shopping_cart),
                                Text(
                                  "购物车",
                                  style: TextStyle(color: Colors.black),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            child: Container(
                          margin: EdgeInsets.all(8.w),
                          height: 36.h,
                          child: ColorButton(
                              color: const Color.fromRGBO(253, 1, 0, 0.9),
                              text: "加入购物车",
                              onTap: () {
                                eventBus.fire(ProductTagsEvent());
                              }),
                        )),
                        Expanded(
                            child: Container(
                          margin: EdgeInsets.all(8.w),
                          height: 36.h,
                          child: ColorButton(
                            color: const Color.fromRGBO(255, 165, 0, 0.9),
                            text: "立即购买",
                            onTap: () {
                              eventBus.fire(ProductTagsEvent());
                            },
                          ),
                        )),
                        SizedBox(
                          width: 8.w,
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ));
  }
}
