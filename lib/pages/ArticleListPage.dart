import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/http/api.dart';
import 'package:flutter_wanandroid/http/http_util.dart';
import 'package:flutter_wanandroid/widget/ArticleItem.dart';
import 'package:flutter_wanandroid/widget/EndLine.dart';

//文章列表页面
class ArticleListPage extends StatefulWidget {
  final String id;

  ArticleListPage(this.id);

  @override
  State<StatefulWidget> createState() {
    return ArticleListPageState();
  }
}

class ArticleListPageState extends State<ArticleListPage> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  int curPage = 0;
  Map<String, String> map = Map();
  List mListData = List();
  int listTotalSize = 0;
  ScrollController controller = ScrollController();

  ///获取文章列表
  void getArticleList() {
    String url = Api.ARTICLE_LIST;
    url += "$curPage/json";
    map['cid'] = widget.id;
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
    }, params: map);
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
    curPage = 0;
    mListData.clear();
    getArticleList();
    return null;
  }

  Widget buildItem(int i) {
    var itemData = mListData[i];
    if (i == mListData.length - 1 &&
        itemData.toString() == 'COMPLETE') {
      return  EndLine();
    }
    return  ArticleItem(itemData);
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    if (mListData == null) {
      return  Center(
        child:  CircularProgressIndicator(),
      );
    } else {
      Widget listView =  ListView.builder(
        key:  PageStorageKey(widget.id),
        itemCount: mListData.length,
        itemBuilder: (context, i) => buildItem(i),
        controller: controller,
      );
      return  RefreshIndicator(child: listView, onRefresh: pullToRefresh);
    }
  }
}
