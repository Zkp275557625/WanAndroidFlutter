import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/pages/ArticleDetailPage.dart';

///收藏文章列表Item
// ignore: must_be_immutable
class CollectArticleItem extends StatefulWidget {
  var itemData;

  CollectArticleItem(this.itemData);

  @override
  State<StatefulWidget> createState() {
    return CollectArticleItemState();
  }
}

class CollectArticleItemState extends State<CollectArticleItem> {
  @override
  Widget build(BuildContext context) {
    Row author = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
            child: Row(
          children: <Widget>[
            Text('作者:  '),
            Text(
              widget.itemData['author'],
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
            TextSpan(text: widget.itemData['title']),
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
            print('被点击了');
          },
        ),
        Expanded(
          child: Text(
            widget.itemData['niceDate'],
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14.0))),
      child: InkWell(
        child: column,
        onTap: (){
          itemClick(widget.itemData);
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

}
