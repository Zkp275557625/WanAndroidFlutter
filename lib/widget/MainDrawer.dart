import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/constant/AppColors.dart';
import 'package:flutter_wanandroid/pages/WelfarePage.dart';
import 'package:flutter_wanandroid/pages/AboutPage.dart';
import 'package:flutter_wanandroid/pages/ArticleDetailPage.dart';
import 'package:flutter_wanandroid/pages/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_wanandroid/http/HttpUtilDio.dart';
import 'package:flutter_wanandroid/http/api.dart';
import 'package:toast/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_wanandroid/pages/CollectList.dart';

///抽屉菜单
class MainDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainDrawerState();
  }
}

class MainDrawerState extends State<MainDrawer> {
  var userName = "";
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  void getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString("user_name") ?? 'user_name';
    setState(() {});
  }

  void toLogin() async {
    if (userName == "user_name") {
      await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return LoginPage();
      }));
    }
    getUserName();
  }

  void initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  /// async 异步跳转时可以接收子页面返回数据
  Future<void> neverSatisfied() async {
    // showDialog 必须要加，否则不会出现对话框
    return showDialog<void>(
      // context 上下文，路由返回等时使用
      context: context,
      // 设为true则点击对话框外时也会关闭对话框
      barrierDismissible: true,
      builder: (BuildContext context) {
        // 对话框
        return new CupertinoAlertDialog(
          content: new SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "退出登录",
                  style: TextStyle(fontSize: 16),
                ),
                Text("确认退出登录？", style: TextStyle(fontSize: 14))
              ],
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child:
                  Text("确定", style: TextStyle(color: AppColors.colorPrimary)),
              onPressed: () {
                Navigator.of(context).pop();
                logout();
              },
            ),
            CupertinoDialogAction(
              child:
                  Text("取消", style: TextStyle(color: AppColors.colorPrimary)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void logout() async {
    Map<String, dynamic> response =
        await HttpUtilDio.getInstance().get(Api.LOGOUT);
    if (response['errorCode'] == 0) {
      initSharedPreferences();
      prefs.clear();
      getUserName();
      Toast.show('退出登录成功', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      HttpUtilDio.mDio.delete(HttpUtilDio.mCookiePath + "/cookies/");
    }
  }

  void toCollectList() async {
    final result =
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return CollectListPage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: AppColors.colorPrimary),
            accountName: Text(userName),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.android),
            ),
            onDetailsPressed: () {
              //判断用户是否已登录，已登录则不可点击，否则跳转到登录页面
              toLogin();
            },
          ),
          ListTile(
            title: Text(
              '收藏',
              style: TextStyle(fontSize: 16.0),
            ),
            leading: Icon(Icons.favorite_border),
            onTap: () {
              toCollectList();
            },
          ),
          ListTile(
            title: Text(
              '福利',
              style: TextStyle(fontSize: 16.0),
            ),
            leading: Icon(Icons.image),
            onTap: () {
              //跳转到福利页面
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return WelfarePage();
              }));
            },
          ),
          ListTile(
            title: Text(
              '天气',
              style: TextStyle(fontSize: 16.0),
            ),
            leading: Icon(Icons.cloud),
          ),
          ListTile(
            title: Text(
              'TODO',
              style: TextStyle(fontSize: 16.0),
            ),
            leading: Icon(Icons.today),
          ),
          ListTile(
            title: Text(
              '夜间模式',
              style: TextStyle(fontSize: 16.0),
            ),
            leading: Icon(Icons.brightness_2),
          ),
          ListTile(
            title: Text(
              '设置',
              style: TextStyle(fontSize: 16.0),
            ),
            leading: Icon(Icons.settings),
          ),
          ListTile(
            title: Text(
              '关于',
              style: TextStyle(fontSize: 16.0),
            ),
            leading: Icon(Icons.info),
            onTap: () {
              //跳转到关于页面
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return AboutPage();
              }));
            },
          ),
          ListTile(
            title: Text(
              '测试博客',
              style: TextStyle(fontSize: 16.0),
            ),
            leading: Icon(Icons.layers),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ArticleDetailPage(
                  title: '测试博客',
                  url: 'https://www.cnblogs.com/imyalost/category/873684.html',
                );
              }));
            },
          ),
          ListTile(
            title: Text(
              '退出登录',
              style: TextStyle(fontSize: 16.0),
            ),
            leading: Icon(Icons.settings_power),
            onTap: () {
              neverSatisfied();
            },
          ),
        ],
      ),
    );
  }
}
