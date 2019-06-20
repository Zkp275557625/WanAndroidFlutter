import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/http/HttpUtilDio.dart';
import 'package:flutter_wanandroid/http/api.dart';
import 'package:flutter_wanandroid/widget/EndLine.dart';
import 'package:flutter_wanandroid/widget/CollectArticleItem.dart';
import 'package:toast/toast.dart';
import 'package:dio/dio.dart';

///收藏列表
class CollectListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CollectListPageState();
  }
}

class CollectListPageState extends State<CollectListPage> {
  CancelToken mCancelToken;

  var currentPage = 0;
  List mListData = List();
  var listTotalSize = 0;
  ScrollController controller = ScrollController();

  void getCollectList() async {
    var url = Api.COLLECT_LIST + "$currentPage/json";

    Map<String, dynamic> response =
        await HttpUtilDio.getInstance().get(url, token: mCancelToken);

    if (response['errorCode'] == 0) {
      //获取收藏列表成功
      var data = response['data'];
      if (data != null) {
        var listData = data['datas'];
        print(listData.toString());
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

  CollectListPageState() {
    mCancelToken = new CancelToken();

    controller.addListener(() {
      var maxScroll = controller.position.maxScrollExtent;
      var pixels = controller.position.pixels;

      if (maxScroll == pixels && mListData.length < listTotalSize) {
        getCollectList();
      }
    });
  }

  Future<Null> pullToRefresh() async {
    currentPage = 0;
    mListData.clear();
    getCollectList();
    return null;
  }

  @override
  void initState() {
    super.initState();
    getCollectList();
  }

  Widget buildItem(int i) {
    var itemData = mListData[i];

    if (itemData is String && itemData == 'COMPLETE') {
      return EndLine();
    }

    return CollectArticleItem(itemData);
  }

  @override
  Widget build(BuildContext context) {
    if (mListData == null) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text('收藏列表'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      Widget listView = ListView.builder(
        itemCount: mListData.length,
        itemBuilder: (context, i) => buildItem(i),
        controller: controller,
      );
      return new Scaffold(
        appBar: new AppBar(
          title: new Text('收藏列表'),
        ),
        body: RefreshIndicator(child: listView, onRefresh: pullToRefresh),
      );
    }
  }
}
