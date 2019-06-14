import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/constant/AppColors.dart';
import 'package:flutter_wanandroid/pages/WelfarePage.dart';

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
            accountEmail: Text('275557625@qq.com'),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.android),
            ),
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
          ),
          ListTile(
            title: Text(
              '测试博客',
              style: TextStyle(fontSize: 16.0),
            ),
            leading: Icon(Icons.layers),
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
