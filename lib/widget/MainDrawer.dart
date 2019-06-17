import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/constant/AppColors.dart';
import 'package:flutter_wanandroid/pages/WelfarePage.dart';
import 'package:flutter_wanandroid/pages/AboutPage.dart';
import 'package:flutter_wanandroid/pages/ArticleDetailPage.dart';
import 'package:flutter_wanandroid/pages/LoginPage.dart';

///抽屉菜单
class MainDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainDrawerState();
  }
}

class MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: AppColors.colorPrimary),
            accountName: Text('userName'),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.android),
            ),
            onDetailsPressed: (){
              //判断用户是否已登录，已登录则不可点击，否则跳转到登录页面
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return LoginPage();
              }));
            },
          ),
          ListTile(
            title: Text(
              '收藏',
              style: TextStyle(fontSize: 16.0),
            ),
            leading: Icon(Icons.favorite_border),
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
            onTap: (){
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
          ),
        ],
      ),
    );
  }
}
