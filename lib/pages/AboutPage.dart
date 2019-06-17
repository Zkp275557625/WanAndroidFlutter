import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_wanandroid/pages/ArticleDetailPage.dart';
import 'package:flutter_wanandroid/constant/AppColors.dart';

///关于页面
class AboutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AboutPageState();
  }
}

class AboutPageState extends State<AboutPage> {
  Widget buildItem(int i) {
    var text;
    switch (i) {
      case 0:
        text = '检查更新';
        break;
      case 1:
        text = '关于网站';
        break;
      case 2:
        text = '源码下载';
        break;
      case 3:
        text = '意见反馈';
        break;
      case 4:
        text = '版权声明';
        break;
    }
    return new Card(
        elevation: 4.0,
        //设置圆角半径
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0))),
        child: InkWell(
          child: new Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 15.0, bottom: 15.0),
            child: new Text(text, style: TextStyle(fontSize: 18)),
          ),
          onTap: () {
            var url, title;
            switch (i) {
              case 0:
                break;
              case 1:
                url = 'https://www.wanandroid.com/about';
                title = '关于网站';
                itemClick(url, title);
                break;
              case 2:
                url = 'https://github.com/Zkp275557625/WanAndroidFlutter.git';
                title = '源码下载';
                itemClick(url, title);
                break;
              case 3:
                url =
                    'https://github.com/Zkp275557625/WanAndroidFlutter/issues';
                title = '意见反馈';
                itemClick(url, title);
                break;
              case 4:
                neverSatisfied();

                break;
            }
          },
        ));
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
                  "版权声明",
                  style: TextStyle(fontSize: 16),
                ),
                Text("本APP完全开源，仅供学习、交流使用，严禁用于商业用途，违者后果自负。",
                    style: TextStyle(fontSize: 14))
              ],
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child:
                  Text("确定", style: TextStyle(color: AppColors.colorPrimary)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void itemClick(url, title) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ArticleDetailPage(
        title: title,
        url: url,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Text("关于"),
        ),
        body: new Column(
          children: <Widget>[
            new Container(
              margin: new EdgeInsets.only(top: 80),
              child: new Image.asset('assets/ic_launcher.png',
                  width: 100, height: 100),
            ),
            new Container(
                margin: new EdgeInsets.only(bottom: 50, top: 10),
                child: new Text(
                  '玩安卓 v1.0.0',
                  style: TextStyle(fontSize: 18),
                )),
            new Expanded(
                child: ListView.builder(
              padding:
                  new EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
              itemCount: 5,
              itemBuilder: (context, i) => buildItem(i),
            )),
          ],
        ));
  }
}
