import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/http/http_util.dart';
import 'package:flutter_wanandroid/http/api.dart';
import 'package:flutter_wanandroid/pages/ArticleListPage.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter_wanandroid/constant/AppColors.dart';

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
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: new BubbleTabIndicator(
                indicatorHeight: 35.0,
                indicatorColor: AppColors.colorPrimary,
                tabBarIndicatorSize: TabBarIndicatorSize.tab,
              ),
              tabs: tabs,
              isScrollable: true,
              controller: tabController,
              labelColor: Colors.white,
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
