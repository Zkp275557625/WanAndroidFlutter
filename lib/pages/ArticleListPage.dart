import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/http/api.dart';
import 'package:flutter_wanandroid/http/HttpUtilDio.dart';
import 'package:flutter_wanandroid/widget/ArticleItem.dart';
import 'package:flutter_wanandroid/widget/EndLine.dart';
import 'package:toast/toast.dart';

//文章列表页面
class ArticleListPage extends StatefulWidget {
  final String id;

  ArticleListPage(this.id);

  @override
  State<StatefulWidget> createState() {
    return ArticleListPageState();
  }
}

class ArticleListPageState extends State<ArticleListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int currentPage = 0;
  Map<String, String> map = Map();
  List mListData = List();
  int listTotalSize = 0;
  ScrollController controller = ScrollController();

  ///获取文章列表
  void getArticleList() async {
    String url = Api.ARTICLE_LIST + "$currentPage/json";
    map['cid'] = widget.id;

    Map<String, dynamic> response =
        await HttpUtilDio.getInstance().get(url, queryParams: map);
    if (response['errorCode'] == 0) {
      var data = response['data'];
      if(data != null){
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

  @override
  void initState() {
    super.initState();
    getArticleList();

    controller.addListener(() {
      var maxScroll = controller.position.maxScrollExtent;
      var pixels = controller.position.pixels;

      if (maxScroll == pixels && mListData.length < listTotalSize) {
        getArticleList();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<Null> pullToRefresh() async {
    currentPage = 0;
    mListData.clear();
    getArticleList();
    return null;
  }

  Widget buildItem(int i) {
    var itemData = mListData[i];
    if (i == mListData.length - 1 && itemData.toString() == 'COMPLETE') {
      return EndLine();
    }
    return ArticleItem(itemData);
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    if (mListData == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      Widget listView = ListView.builder(
        key: PageStorageKey(widget.id),
        itemCount: mListData.length,
        itemBuilder: (context, i) => buildItem(i),
        controller: controller,
      );
      return RefreshIndicator(child: listView, onRefresh: pullToRefresh);
    }
  }
}
