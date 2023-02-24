import 'package:flutter/material.dart';
import 'package:flutter_jdshop/provider/Counter.dart';
import 'package:flutter_jdshop/provider/UserProvider.dart';
import 'routes/Route.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'provider/CartProvider.dart';

/*
event_bus: 类似Notification，广播其他widget，比如弹出tag选择框
  （一个全局的EventBus()对象来发送通知）
provider: 数据读取、共享，通过notifyListeners()调用build方法刷新页面
  （个人理解：本质上是通过一个全局单例持有一个provider对象达到共享的目的）
*/

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Counter()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: "/",
              onGenerateRoute: onGenerateRoute,
              theme: ThemeData(
                  // primaryColor: Colors.white, //单独设置primaryColor没有作用，需要设置colorScheme
                  colorScheme: const ColorScheme(
                      primary: Colors.white,
                      primaryVariant: Colors.white,
                      secondary: Colors.black,
                      secondaryVariant: Colors.black,
                      surface: Colors.white,
                      background: Colors.white,
                      error: Colors.red,
                      onPrimary: Colors.black,
                      onSecondary: Colors.white,
                      onSurface: Colors.black,
                      onBackground: Colors.black,
                      onError: Colors.white,
                      brightness: Brightness.light),
                  //下面两个可以全局去除水波纹效果（局部InkWell也可以设置这两个）
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent),
            );
          },
        ));
  }
}
