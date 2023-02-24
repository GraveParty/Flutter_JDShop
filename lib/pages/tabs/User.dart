// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_jdshop/provider/UserProvider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late UserProvider _userProvider;

  Widget _createUserWidget() {
    return Container(
        height: 100.h,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/user_bg.jpg"), fit: BoxFit.fill),
        ),
        child: Container(
          padding: EdgeInsets.only(left: 16.w, right: 16.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.asset("images/user.png",
                    width: 50.w, height: 50.w, fit: BoxFit.fill),
              ),
              SizedBox(
                width: 16.w,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _userProvider.isLogin
                    ? [
                        Text("用户名：${_userProvider.user?.username}",
                            style: TextStyle(
                                color: Colors.white, fontSize: 14.sp)),
                        Text("普通会员",
                            style:
                                TextStyle(color: Colors.white, fontSize: 12.sp))
                      ]
                    : [
                        InkWell(
                          child: Text("登录/注册",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.sp)),
                          onTap: () {
                            Navigator.pushNamed(context, '/login');
                          },
                        )
                      ],
              )
            ],
          ),
        ));
  }

  Widget _createItemWidget(
      {required Icon icon, required String title, void Function()? onTap}) {
    return InkWell(
      child: SizedBox(
        height: 60.h,
        child: Column(
          children: [
            Expanded(
                child: Container(
              padding: EdgeInsets.only(left: 16.w),
              child: Row(
                children: [
                  icon,
                  SizedBox(
                    width: 16.w,
                  ),
                  Text(title,
                      style: TextStyle(color: Colors.black, fontSize: 16.sp))
                ],
              ),
            )),
            const Divider(
              height: 1,
            )
          ],
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("用户中心"),
      ),
      body: ListView(
        children: [
          _createUserWidget(),
          _createItemWidget(
              icon: const Icon(Icons.assignment, color: Colors.red),
              title: "全部订单",
              onTap: () {
                Navigator.pushNamed(context, '/orderList');
              }),
          _createItemWidget(
              icon: const Icon(Icons.credit_card, color: Colors.green),
              title: "待付款"),
          _createItemWidget(
              icon: const Icon(Icons.local_shipping, color: Colors.yellow),
              title: "待收货"),
          Container(
            color: Colors.black12,
            height: 10.h,
          ),
          _createItemWidget(
              icon: Icon(Icons.favorite, color: Colors.green.shade200),
              title: "我的收藏"),
          _createItemWidget(
              icon: const Icon(Icons.people, color: Colors.grey),
              title: "在线客服"),
          if (_userProvider.isLogin)
            _createItemWidget(
                icon: const Icon(Icons.logout, color: Colors.red),
                title: "退出登录",
                onTap: () {
                  _userProvider.logout();
                }),
        ],
      ),
    );
  }
}
