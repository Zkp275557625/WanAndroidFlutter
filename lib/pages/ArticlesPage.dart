import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data['name']),
      ),
      body: DefaultTabController(
          length: list.length,
          child: Scaffold(
            appBar: TabBar(
              tabs: tabs,
              isScrollable: true,
              controller: tabController,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.black,
              indicatorColor: Theme.of(context).primaryColor,
            ),
            body: TabBarView(
              controller: tabController,
              children: list.map((dynamic itemData) {
                return ArticleListPage(itemData['id'].toString());
              }).toList(),
            ),
          )),
    );
  }
}
