import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/http/http_util.dart';
import 'package:flutter_wanandroid/http/api.dart';
import 'package:flutter_wanandroid/constant/AppColors.dart';
import 'package:flutter_wanandroid/pages/ArticleDetailPage.dart';

///导航页面
class NavigationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NavigationPageState();
  }
}

class NavigationPageState extends State<NavigationPage> {
  List mListData = List();
  int indexChecked = 0;

  void getNavigation() {
    HttpUtil.get(Api.Navigation, (data) {
      setState(() {
        mListData = data;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getNavigation();
  }

  @override
  Widget build(BuildContext context) {
    if (mListData == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return new Scaffold(
          body: mListData.length > 0
              ? Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: ListView.builder(
                        itemCount: mListData.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                indexChecked = index;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(top: 15, bottom: 15),
                              decoration: BoxDecoration(
                                color: indexChecked == index
                                    ? AppColors.colorPrimary
                                    : Colors.white,
                              ),
                              child: Text(
                                mListData[index]['name'],
                                style: TextStyle(
                                    color: indexChecked == index
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 16.0),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                          color: Colors.white,
                          child: ListView.builder(
                              itemCount:
                                  mListData[indexChecked]['articles'].length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    itemClick(mListData[indexChecked]['articles'][index]);
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
                                      mListData[indexChecked]['articles'][index]
                                          ['title'],
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                  ),
                                );
                              })),
                    ),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                ));
    }
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
