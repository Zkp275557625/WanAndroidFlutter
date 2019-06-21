import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/http/HttpUtilDio.dart';
import 'package:flutter_wanandroid/http/api.dart';
import 'package:flutter_wanandroid/constant/AppColors.dart';
import 'package:flutter_wanandroid/pages/ArticleDetailPage.dart';
import 'package:toast/toast.dart';

///导航页面
class NavigationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NavigationPageState();
  }
}

class NavigationPageState extends State<NavigationPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<dynamic> mListData;
  int indexChecked = 0;

  void getNavigation() async {
    Map<String, dynamic> response =
        await HttpUtilDio.getInstance().get(Api.Navigation);

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
    getNavigation();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    if (mListData == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return new Scaffold(
          body: mListData != null
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
                                  mListData.elementAt(indexChecked) == null
                                      ? 0
                                      : mListData
                                          .elementAt(indexChecked)['articles']
                                          .length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    itemClick(mListData[indexChecked]
                                        ['articles'][index]);
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
