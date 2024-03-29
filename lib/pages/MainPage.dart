import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/constant/AppColors.dart';
import 'package:flutter_wanandroid/widget/MainDrawer.dart';
import 'package:flutter_wanandroid/pages/HomePage.dart';
import 'package:flutter_wanandroid/pages/KnowledgePage.dart';
import 'package:flutter_wanandroid/pages/WeChatPage.dart';
import 'package:flutter_wanandroid/pages/NavigationPage.dart';
import 'package:flutter_wanandroid/pages/ProjectPage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_wanandroid/pages/FriendPage.dart';

/// MainPage：主页面，相当于MainActivity

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> with TickerProviderStateMixin {
  //底部tab索引
  int tabIndex = 0;
  List<BottomNavigationBarItem> bottomNavigationList;
  var appBarTitles = ['首页', '知识体系', '公众号', '导航', '项目'];

  var body;

  initData() {
    body = IndexedStack(
      children: <Widget>[
        HomePage(),
        KnowledgePage(),
        WeChatPage(),
        NavigationPage(),
        ProjectPage()
      ],
      index: tabIndex,
    );
  }

  ///请求获取权限
  void requestPermissions() async {
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);

    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);

    if (permission == PermissionStatus.granted) {
    } else {
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    }
  }

  @override
  void initState() {
    super.initState();
    bottomNavigationList = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          title: Text(appBarTitles[0]),
          backgroundColor: AppColors.colorPrimary),
      BottomNavigationBarItem(
          icon: const Icon(Icons.widgets),
          title: Text(appBarTitles[1]),
          backgroundColor: AppColors.colorPrimary),
      BottomNavigationBarItem(
          icon: const Icon(Icons.accessibility),
          title: Text(appBarTitles[2]),
          backgroundColor: AppColors.colorPrimary),
      BottomNavigationBarItem(
          icon: const Icon(Icons.near_me),
          title: Text(appBarTitles[3]),
          backgroundColor: AppColors.colorPrimary),
      BottomNavigationBarItem(
          icon: const Icon(Icons.subtitles),
          title: Text(appBarTitles[4]),
          backgroundColor: AppColors.colorPrimary),
    ];
  }

  final navigatorKey = GlobalKey<NavigatorState>();

  void toFriendPage() async {
    await Navigator.of(context, rootNavigator: true)
        .push(MaterialPageRoute(builder: (context) {
      return FriendPage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    requestPermissions();
    initData();
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primaryColor: AppColors.colorPrimary,
        accentColor: AppColors.colorAccent,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            appBarTitles[tabIndex],
            style: TextStyle(color: Colors.white),
          ),
          leading: Builder(
            builder: (context) => GestureDetector(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  child: Icon(
                    Icons.dehaze,
                    color: Colors.white,
                  ),
                ),
          ),
          actions: <Widget>[
            //搜索
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                print('搜索');
              },
            ),
            //常用网站
            IconButton(
              icon: Icon(Icons.language),
              onPressed: () {
                toFriendPage();
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('被点击了');
          },
          backgroundColor: AppColors.colorPrimary,
          child: Icon(
            Icons.arrow_upward,
            color: Colors.white,
          ),
        ),
        drawer: MainDrawer(),
        body: body,
        bottomNavigationBar: BottomNavigationBar(
          items: bottomNavigationList
              .map((BottomNavigationBarItem navigationView) => navigationView)
              .toList(),
          currentIndex: tabIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              tabIndex = index;
            });
          },
        ),
      ),
    );
  }
}
