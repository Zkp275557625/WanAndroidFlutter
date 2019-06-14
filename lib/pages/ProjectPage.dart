import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/http/http_util.dart';
import 'package:flutter_wanandroid/http/api.dart';
import 'package:flutter_wanandroid/pages/ArticleListPage.dart';

///项目页面
class ProjectPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ProjectPageState();
  }

}

class ProjectPageState extends State<ProjectPage> with SingleTickerProviderStateMixin{

  TabController tabController;
  List<Tab> tabs = List();
  List<dynamic> mListData;

  ///获取项目分类
  getProject() async {
    HttpUtil.get(Api.Project, (data) {
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
    getProject();
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