import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/http/HttpUtilDio.dart';
import 'package:flutter_wanandroid/http/api.dart';
import 'package:flutter_wanandroid/widget/EndLine.dart';
import 'package:toast/toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter_wanandroid/pages/ArticleDetailPage.dart';

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

  int id = 0;

  void dealWithCollect() async {
    Map<String, dynamic> response = await HttpUtilDio.getInstance().post(Api.UN_COLLECT_OUTSIDE + "$id/json");
    if (response['errorCode'] == 0) {
      Toast.show('操作成功', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      setState(() {
        getCollectList();
      });
    }
  }

  void getCollectList() async {
    var url = Api.COLLECT_LIST + "$currentPage/json";

    Map<String, dynamic> response =
        await HttpUtilDio.getInstance().get(url, token: mCancelToken);

    if (response['errorCode'] == 0) {
      //获取收藏列表成功
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

    Row author = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
            child: Row(
          children: <Widget>[
            Text('作者:  '),
            Text(
              itemData['author'],
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ],
        )),
      ],
    );

    Row title = Row(
      children: <Widget>[
        Expanded(
          child: Text.rich(
            TextSpan(text: itemData['title']),
            //自动换行显示
            softWrap: true,
            style: TextStyle(fontSize: 16.0, color: Colors.black),
            textAlign: TextAlign.left,
          ),
        )
      ],
    );

    Row niceDate = Row(
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.favorite,
            color: Colors.red,
          ),
          onPressed: () {
            dealWithCollect();
          },
        ),
        Expanded(
          child: Text(
            itemData['niceDate'],
            softWrap: true,
            style: TextStyle(color: Theme.of(context).primaryColor),
            textAlign: TextAlign.left,
          ),
        )
      ],
    );

    Column column = Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          child: author,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
          child: title,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 5.0),
          child: niceDate,
        ),
      ],
    );

    return Card(
      //阴影
      elevation: 8.0,
      //设置圆角半径
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14.0))),
      child: InkWell(
        child: column,
        onTap: () {
          itemClick(itemData);
        },
      ),
    );
  }

  void itemClick(itemData) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ArticleDetailPage(
        title: itemData['title'],
        url: itemData['link'],
      );
    }));
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
