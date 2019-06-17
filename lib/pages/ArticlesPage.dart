import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/constant/AppColors.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter_wanandroid/pages/ArticleListPage.dart';

///文章列表页面
class ArticlesPage extends StatefulWidget {
  final data;

  ArticlesPage(this.data);

  @override
  State<StatefulWidget> createState() {
    return ArticlesPageState();
  }
}

class ArticlesPageState extends State<ArticlesPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  List<Tab> tabs = List();
  List<dynamic> list;

  @override
  void initState() {
    super.initState();
    list = widget.data['children'];
    for (var value in list) {
      tabs.add(Tab(text: value['name']));
    }
    tabController = TabController(length: list.length, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.data['name']),
      ),
      body: DefaultTabController(
          length: list.length,
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
              children: list.map((dynamic itemData) {
                return ArticleListPage(itemData['id'].toString());
              }).toList(),
            ),
          )),
    );
  }
}
