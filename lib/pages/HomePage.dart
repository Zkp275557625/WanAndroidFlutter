import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/http/api.dart';
import 'package:flutter_wanandroid/http/HttpUtilDio.dart';
import 'package:flutter_wanandroid/widget/BannerWidget.dart';
import 'package:flutter_wanandroid/widget/EndLine.dart';
import 'package:flutter_wanandroid/widget/ArticleItem.dart';
import 'package:toast/toast.dart';

///首页

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  List mListData = List();
  var currentPage = 0;
  var listTotalSize = 0;
  List bannerData;
  List<BannerItem> bannerList = [];
  BannerWidget bannerWidget;

  ScrollController controller = ScrollController();

  void getBanner() async {
    Map<String, dynamic> response =
        await HttpUtilDio.getInstance().get(Api.BANNER);

    if (response['errorCode'] == 0) {
      bannerData = response['data'];
      if (bannerData != null) {
        for (int i = 0; i < bannerData.length; i++) {
          BannerItem item = BannerItem.defaultBannerItem(
              bannerData[i]['imagePath'], bannerData[i]['title']);
          bannerList.add(item);
        }
        bannerWidget =
            new BannerWidget(180.0, bannerList, bannerPress: (pos, item) {
          print('第 $pos 点击了');
        });
      }
    } else {
      Toast.show(response['errorMsg'], context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  void getHomeArticleList() async {
    String url = Api.ARTICLE_LIST + "$currentPage/json";

    Map<String, dynamic> response = await HttpUtilDio.getInstance().get(url);

    if (response['errorCode'] == 0) {
      var data = response['data'];
      if (data != null) {
        var listData = data['datas'];

        listTotalSize = data["total"];
        setState(() {
          List list = List();
          if (currentPage == 0) {
            mListData.clear();
          }
          currentPage++;
          list.addAll(mListData);
          list.addAll(listData);
          if (list.length >= listTotalSize) {
            list.add('COMPLETE');
          }
          mListData = list;
        });
      }
    } else {
      Toast.show(response['errorMsg'], context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
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
    }
    i -= 1;

    var itemData = mListData[i];

    if (itemData is String && itemData == 'COMPLETE') {
      return EndLine();
    }

    return ArticleItem(itemData);
  }

  Future<Null> pullToRefresh() async {
    currentPage = 0;
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
