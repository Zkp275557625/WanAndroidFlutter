import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/http/api.dart';
import 'package:flutter_wanandroid/http/HttpUtilDio.dart';
import 'package:toast/toast.dart';

///福利页面
class WelfarePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WelfarePageState();
  }
}

class WelfarePageState extends State<WelfarePage> {

  var currentPage = 1;
  List mListData = List();
  ScrollController scrollController = new ScrollController();

  ///获取福利图片数据
  ///数据来源：干货集中营
  void getWelfareData() async {
    Map<String, dynamic> response =
        await HttpUtilDio.getInstance().get(Api.Welfare + "/$currentPage");

    if (response['errorCode'] == 0) {
      var data = response['data'];
      if (data != null) {
        var listData = data['datas'];

        setState(() {
          List list = List();
          if (currentPage == 0) {
            mListData.clear();
          }
          list.addAll(mListData);
          list.addAll(listData);
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

    scrollController.addListener(() {
      var position = scrollController.position;
      // 小于50px时，触发上拉加载；
      if (position.maxScrollExtent - position.pixels < 50) {
        currentPage++;
        getWelfareData();
      }
    });

    getWelfareData();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<Null> pullToRefresh() async {
    currentPage = 1;
    mListData.clear();
    getWelfareData();
    return null;
  }

  Widget buildItem(int i) {
    return Container(
      height: MediaQuery.of(context).size.height - 120,
      child: new Image.network(mListData[i]['url'], fit: BoxFit.fitHeight),
      margin: EdgeInsets.only(left: 10, bottom: 15, top: 15, right: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("福利"),
      ),
      body: mListData == null
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              child: ListView.builder(
                itemCount: mListData.length,
                controller: scrollController,
                itemBuilder: (context, i) => buildItem(i),
              ),
              onRefresh: pullToRefresh,
            ),
    );
  }
}
