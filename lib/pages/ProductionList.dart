// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import '../../config/Config.dart';
import '../models/Production.dart';
import '../widget/Loading.dart';

class ProductionListPage extends StatefulWidget {
  Map? arguments;
  ProductionListPage({Key? key, this.arguments}) : super(key: key);

  @override
  State<ProductionListPage> createState() => _ProductionListPageState();
}

class _ProductionListPageState extends State<ProductionListPage> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  int _page = 1;
  final int _pageSize = 10;
  bool _isLoading = false;
  bool _hasMore = true;
  List<ProductionItem> _list = [];
  final _scrollController = ScrollController();
  final List<ProductionListFilterModel> _filterList = [
    ProductionListFilterModel(title: "综合", paramPrefix: "all"),
    ProductionListFilterModel(
        title: "销量", paramPrefix: "salecount", hasArrow: true),
    ProductionListFilterModel(
        title: "价格", paramPrefix: "price", hasArrow: true),
    ProductionListFilterModel(title: "筛选"),
  ];
  final _textFieldContrller = TextEditingController();

  @override
  initState() {
    super.initState();
    _textFieldContrller.text = (widget.arguments?["search"] as String?) ?? "";
    _scrollController.addListener(() {
      if (_isLoading || !_hasMore) {
        return;
      }
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 20) {
        _loadData(isRefresh: false);
      }
    });
    _loadData();
  }

  void _loadData({bool isRefresh = true}) async {
    setState(() {
      _isLoading = true;
      if (isRefresh && _scrollController.hasClients) {
        _scrollController.position.jumpTo(0);
      }
    });
    if (isRefresh) {
      _page = 1;
    }
    final cid = (widget.arguments?["cid"] as String?) ?? "";
    final search = _textFieldContrller.text;
    final selectedFilter =
        _filterList.firstWhere((element) => element.isSelected, orElse: () {
      setState(() {
        _filterList.first.isSelected = true;
      });
      return _filterList.first;
    });
    final api = Config.api("api/plist");
    var queryParameters = {
      "page": "$_page",
      "sort": selectedFilter.param,
    };
    if (search.isEmpty) {
      queryParameters["cid"] = cid;
    } else {
      queryParameters["search"] = search;
    }
    var response = await Dio().get(api, queryParameters: queryParameters);
    setState(() {
      _isLoading = false;
      final resList = ProductionResponse.fromJson(response.data).result;
      _hasMore = resList.length >= _pageSize;
      if (_hasMore) {
        _page += 1;
      }
      if (isRefresh) {
        _list = [];
      }
      _list.addAll(resList);
    });
  }

  Widget _filterWidget(double filterHeight) {
    return Column(
      children: [
        Row(
          children: _filterList.map((e) {
            return Expanded(
                child: SizedBox(
              height: filterHeight - 1.h,
              child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        e.title,
                        style: TextStyle(
                            color: e.isSelected ? Colors.red : Colors.black),
                      ),
                      if (e.hasArrow)
                        Icon(
                          e.sort > 0
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                          color: e.isSelected ? Colors.red : Colors.black,
                        ),
                    ],
                  ),
                  onTap: () {
                    if (e.paramPrefix == null) {
                      _globalKey.currentState?.openEndDrawer();
                      return;
                    }
                    setState(() {
                      //重复点击切换排序规则
                      if (e.isSelected) {
                        e.changeSort();
                      }
                      for (var element in _filterList) {
                        element.isSelected = false;
                      }
                      e.isSelected = true;
                    });
                    _loadData();
                  }),
            ));
          }).toList(),
        ),
        Divider(height: 1.h)
      ],
    );
  }

  Widget _moreWidget(int index) {
    if (_hasMore && index == _list.length - 1) {
      return const Center(
        child: Text("加载中..."),
      );
    } else {
      return const SizedBox(
        height: 0,
      );
    }
  }

  Widget _listWidget() {
    if (_list.isNotEmpty) {
      return ListView.builder(
          controller: _scrollController,
          itemCount: _list.length,
          itemBuilder: (context, index) {
            final item = _list[index];
            final picURL = Config.picture(item.pic);
            return InkWell(
              child: Container(
                padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h),
                width: double.infinity,
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 80.h,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Image.network(picURL, fit: BoxFit.fill),
                          ),
                        ),
                        Expanded(
                            child: Container(
                          height: 80.h,
                          padding: EdgeInsets.only(left: 8.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title ?? "",
                                maxLines: 2,
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis),
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 16.h,
                                    padding: EdgeInsets.only(
                                        left: 5.w,
                                        right: 5.w,
                                        top: 1.h,
                                        bottom: 2.h),
                                    decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.h))),
                                    child: const Text("4G"),
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Container(
                                    height: 16.h,
                                    padding: EdgeInsets.only(
                                        left: 5.w,
                                        right: 5.w,
                                        top: 1.h,
                                        bottom: 2.h),
                                    decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.h))),
                                    child: const Text("126"),
                                  )
                                ],
                              ),
                              Text("￥${item.price}",
                                  style: const TextStyle(
                                    color: Colors.red,
                                  ))
                            ],
                          ),
                        ))
                      ],
                    ),
                    const Divider(),
                    _moreWidget(index),
                  ],
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/productDetail',
                    arguments: {"id": item.sId});
              },
            );
          });
    } else if (_isLoading) {
      return const Center(
        child: Text("加载中..."),
      );
    } else {
      return const Center(
        child: Text("暂无数据"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filterHeight = 40.h;
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: const BackButton(),
        title: Container(
          height: 28.h,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(233, 233, 233, 0.8),
            borderRadius: BorderRadius.all(Radius.circular(14.w)),
          ),
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.text,
            autofocus: false,
            controller: _textFieldContrller,
            //文字居中：BorderSide.none + EdgeInsets.symmetric(vertical: -10)
            decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: -10, horizontal: 16.w),
                hintText: '输入关键词'),
            onChanged: (value) {
              // _textFieldContrller.text = value; //不需要
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
              onTap: () {
                _loadData();
              })
        ],
      ),
      endDrawer: const Drawer(
          child: Placeholder()), //flutter 2.0 设置了endDrawer时返回按钮会消失，要手动判断leading
      body: Stack(
        children: [
          SizedBox(
            height: filterHeight,
            child: _filterWidget(filterHeight),
          ),
          Container(
            padding: EdgeInsets.only(top: filterHeight),
            child: _listWidget(),
          )
        ],
      ),
    );
  }
}
