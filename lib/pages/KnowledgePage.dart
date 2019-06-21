import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/http/HttpUtilDio.dart';
import 'package:flutter_wanandroid/http/api.dart';
import 'package:flutter_wanandroid/pages/ArticlesPage.dart';
import 'package:toast/toast.dart';

///知识体系页面
class KnowledgePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return KnowledgePageState();
  }
}

class KnowledgePageState extends State<KnowledgePage> {
  var mListData;

  getTree() async {
    Map<String, dynamic> response =
        await HttpUtilDio.getInstance().get(Api.TREE);

    if (response['errorCode'] == 0) {
      mListData = response['data'];
    } else {
      Toast.show(response['errorMsg'], context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  Widget buildItem(i) {
    var itemData = mListData[i];

    //分类名字
    Text name = Text(
      itemData['name'],
      softWrap: true,
      style: TextStyle(
          fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.bold),
      textAlign: TextAlign.left,
    );

    List list = itemData['children'];
    String strContent = '';
    for (var value in list) {
      strContent += '${value["name"]}   ';
    }

    //分类内容
    Text content = Text(
      strContent,
      softWrap: true,
      style: TextStyle(color: Colors.black),
      textAlign: TextAlign.left,
    );

    return Card(
      //阴影
      elevation: 8.0,
      //设置圆角半径
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14.0))),
      child: InkWell(
        onTap: () {
          onItemClick(itemData);
        },
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: name,
                    ),
                    content,
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onItemClick(itemData) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ArticlesPage(itemData);
    }));
  }

  @override
  void initState() {
    super.initState();
    getTree();
  }

  @override
  Widget build(BuildContext context) {
    if (mListData == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      Widget listView = ListView.builder(
        itemCount: mListData == null ? 0 : mListData.length,
        itemBuilder: (context, i) => buildItem(i),
      );
      return listView;
    }
  }
}
