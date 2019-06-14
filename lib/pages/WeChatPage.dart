import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/http/http_util.dart';
import 'package:flutter_wanandroid/http/api.dart';
import 'package:flutter_wanandroid/pages/ArticleListPage.dart';

///微信公众号页面
class WeChatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WeChatPageState();
  }
}

class WeChatPageState extends State<WeChatPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  List<Tab> tabs = List();
  List<dynamic> mListData;

  ///获取微信公众号列表
  getWeChatList() {
    HttpUtil.get(Api.WE_CHAT, (data) {
      setState(() {
        mListData = data;
        for (var value in mListData) {
          tabs.add(Tab(text: value['name']));
        }
        tabController = TabController(length: mListData.length, vsync: this);
      });
    });
  }

  @override
  void initState() {
    super.initState();

    getWeChatList();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: DefaultTabController(
          length: mListData.length,
          child: new Scaffold(
            appBar: TabBar(
              tabs: tabs,
              isScrollable: true,
              controller: tabController,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.black,
              indicatorColor: Theme.of(context).primaryColor,
            ),
            body: TabBarView(
              //同步控制器，不设置会是的页面和tab不同步
              controller: tabController,
              children: mListData.map((dynamic itemData) {
                return ArticleListPage(itemData['id'].toString());
              }).toList(),
            ),
          )),
    );
  }
}
