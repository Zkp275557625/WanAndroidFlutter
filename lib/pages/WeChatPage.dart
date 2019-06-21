import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/http/HttpUtilDio.dart';
import 'package:flutter_wanandroid/http/api.dart';
import 'package:flutter_wanandroid/pages/ArticleListPage.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter_wanandroid/constant/AppColors.dart';
import 'package:toast/toast.dart';

///微信公众号页面
class WeChatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WeChatPageState();
  }
}

class WeChatPageState extends State<WeChatPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  TabController tabController;
  List<Tab> tabs = List();
  List<dynamic> mListData;

  ///获取微信公众号列表
  getWeChatList() async {
    Map<String, dynamic> response =
        await HttpUtilDio.getInstance().get(Api.WE_CHAT);

    if (response['errorCode'] == 0) {
      mListData = response['data'];
      if (mListData != null) {
        for (var value in mListData) {
          tabs.add(Tab(text: value['name']));
        }
        tabController = TabController(length: mListData.length, vsync: this);
      }
    } else {
      Toast.show(response['errorMsg'], context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
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
  // ignore: must_call_super
  Widget build(BuildContext context) {
    if (mListData == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return new Scaffold(
        body: DefaultTabController(
            length: mListData == null ? 0 : mListData.length,
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
}
