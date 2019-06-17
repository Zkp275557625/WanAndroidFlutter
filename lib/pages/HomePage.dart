import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/http/api.dart';
import 'package:flutter_wanandroid/http/http_util.dart';
import 'package:flutter_wanandroid/widget/BannerWidget.dart';
import 'package:flutter_wanandroid/widget/EndLine.dart';
import 'package:flutter_wanandroid/widget/ArticleItem.dart';

///首页

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  List mListData = List();
  var curPage = 0;
  var listTotalSize = 0;
  List bannerData;
  List<BannerItem> bannerList = [];
  BannerWidget bannerWidget;

  ScrollController controller = ScrollController();

  void getBanner() {
    String bannerUrl = Api.BANNER;

    HttpUtil.get(bannerUrl, (data) {
      if (data != null) {
        setState(() {
          bannerData = data;

          for (int i = 0; i < bannerData.length; i++) {
            BannerItem item = BannerItem.defaultBannerItem(
                bannerData[i]['imagePath'], bannerData[i]['title']);
            bannerList.add(item);
          }

          bannerWidget =
              new BannerWidget(180.0, bannerList, bannerPress: (pos, item) {
            print('第 $pos 点击了');
          });
        });
      }
    });
  }

  void getHomeArticleList() {
    String url = Api.ARTICLE_LIST;
    url += "$curPage/json";

    HttpUtil.get(url, (data) {
      if (data != null) {
        Map<String, dynamic> map = data;
        var listData = map['datas'];
        listTotalSize = map["total"];

        setState(() {
          List list = List();
          if (curPage == 0) {
            mListData.clear();
          }
          curPage++;

          list.addAll(mListData);
          list.addAll(listData);
          if (list.length >= listTotalSize) {
            list.add('COMPLETE');
          }
          mListData = list;
        });
      }
    });
  }

  HomePageState() {
    controller.addListener(() {
      var maxScroll = controller.position.maxScrollExtent;
      var pixels = controller.position.pixels;

      if (maxScroll == pixels && mListData.length < listTotalSize) {
        getHomeArticleList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getBanner();
    getHomeArticleList();
  }

  Widget buildItem(int i) {
    if (i == 0) {
      return Container(
        height: 180.0,
        child: bannerWidget,
      );
    }    i -= 1;

    var itemData = mListData[i];

    if (itemData is String && itemData == 'COMPLETE') {
      return EndLine();
    }

    return ArticleItem(itemData);
  }

  Future<Null> pullToRefresh() async {
    curPage = 0;
    bannerList.clear();
    getBanner();
    getHomeArticleList();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (mListData == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      Widget listView = ListView.builder(
        itemCount: mListData.length + 1,
        itemBuilder: (context, i) => buildItem(i),
        controller: controller,
      );
      return RefreshIndicator(child: listView, onRefresh: pullToRefresh);
    }
  }
}
