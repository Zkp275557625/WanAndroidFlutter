import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:flutter_wanandroid/http/HttpUtilDio.dart';
import 'package:flutter_wanandroid/http/api.dart';
import 'package:flutter_wanandroid/pages/ArticleDetailPage.dart';

///常用网站页面
class FriendPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FriendPageState();
  }
}

class FriendPageState extends State<FriendPage> {

  List<dynamic> mListData;

  void getFriend() async {
    Map<String, dynamic> response =
    await HttpUtilDio.getInstance().get(Api.Project);

    if (response['errorCode'] == 0) {
      mListData = response['data'];
    } else {
      Toast.show(response['errorMsg'], context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  @override
  void initState() {
    super.initState();
    getFriend();
  }

  @override
  Widget build(BuildContext context) {
    if (mListData == null) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text('常用网站'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }else{
      return new Scaffold(
        appBar: new AppBar(
          title: new Text('常用网站'),
        ),
        body: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemCount: mListData.length,
            itemBuilder: (context,i) => buildItem(i)),
      );
    }
  }

  Widget buildItem(int i){
    return InkWell(
      onTap: () {
        itemClick(i);
      },
      child: Container(
        alignment: Alignment.center,
        padding:
        EdgeInsets.only(top: 15, bottom: 15),
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.black12,
            border: Border(
              bottom: Divider.createBorderSide(
                  context,
                  color: Colors.white,
                  width: 1),
            )),
        child: Text(
          mListData[i]['name'],
          style: TextStyle(fontSize: 14.0),
        ),
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
