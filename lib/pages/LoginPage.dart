import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/constant/AppColors.dart';
import 'package:flutter_wanandroid/pages/RegisterPage.dart';
import 'package:toast/toast.dart';
import 'package:flutter_wanandroid/http/HttpUtilDio.dart';
import 'package:flutter_wanandroid/http/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

///登录页面
class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  ///监听用户名输入框文字变化
  final TextEditingController userNameController = TextEditingController();

  ///监听密码输入框文字变化
  final TextEditingController passwordController = TextEditingController();

  SharedPreferences prefs;

  CancelToken mCancelToken;

  void initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();

    mCancelToken = new CancelToken();

    initSharedPreferences();

    userNameController.addListener(() {
      print('输入的内容：${userNameController.text}');
    });
    passwordController.addListener(() {
      print('输入的内容：${passwordController.text}');
    });
  }

  ///登录
  void login() async {
    if (userNameController.text.toString().length == 0 ||
        passwordController.text.toString().length == 0) {
      Toast.show('用户名或密码不能为空', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      Map<String, String> params = Map();
      params.putIfAbsent("username", () => userNameController.text.toString());
      params.putIfAbsent("password", () => passwordController.text.toString());

      Map<String, dynamic> response = await HttpUtilDio.getInstance()
          .post(Api.LOGIN, queryParams: params, token: mCancelToken);

      if (response['errorCode'] == 0) {
        Toast.show('登陆成功', context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setString("user_name", response['data']['username']);
        Navigator.pop(context);
      } else {
        Toast.show(response['errorMsg'], context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    }
  }

  void toRegister() async {
    final result =
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return RegisterPage();
    }));
    userNameController.text = result[0];
    passwordController.text = result[1];
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        child: new Scaffold(
          appBar: new AppBar(
            title: new Text('登录'),
          ),
          backgroundColor: Colors.white,

          ///垂直布局 类似android中LinearLayout的vertical
          body: new Column(
            children: <Widget>[
              new Container(
                height: 200,
              ),
              new Expanded(
                child: new Container(
                    child: new Container(
                        margin: EdgeInsets.only(left: 20, top: 15, right: 20),
                        child: new Column(
                          children: <Widget>[
                            new TextField(
                              controller: userNameController,
                              maxLines: 1,
                              obscureText: false,
                              style: new TextStyle(fontSize: 16),
                              onChanged: (text) {
                                print('文本改变：$text');
                              },
                              onSubmitted: (text) {
                                print('文本提交：$text');
                              },
                              decoration: new InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.people,
                                    color: AppColors.colorPrimary,
                                  ),
                                  hintText: '请输入用户名'),
                            ),
                            new SizedBox(height: 15),
                            new TextField(
                              controller: passwordController,
                              maxLines: 1,
                              obscureText: true,
                              style: new TextStyle(fontSize: 16),
                              onChanged: (text) {
                                print('文本改变：$text');
                              },
                              onSubmitted: (text) {
                                print('文本提交：$text');
                              },
                              decoration: new InputDecoration(
                                  prefixIcon: new Icon(
                                    Icons.lock,
                                    color: AppColors.colorPrimary,
                                  ),
                                  hintText: '请输入密码'),
                            ),
                            new Container(
                              padding: new EdgeInsets.only(top: 15, left: 20),
                              alignment: Alignment.centerLeft,
                              child: new InkWell(
                                child: new Text(
                                  '还没有账号？现在注册',
                                  style: new TextStyle(
                                      color: AppColors.colorPrimary,
                                      fontSize: 14),
                                ),
                                onTap: () {
                                  toRegister();
                                },
                              ),
                            ),
                            new SizedBox(height: 15),
                            SizedBox(
                              width: double.infinity,
                              height: 40,
                              child: new RaisedButton(
                                color: AppColors.colorPrimary,
                                child: Text(
                                  '登录',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  login();
                                },
                              ),
                            ),
                          ],
                        ))),
              )
            ],
          ),
        ),
        onWillPop: () {
          cancelRequest();
        });
  }

  ///取消网络请求
  Future<bool> cancelRequest() {
    mCancelToken.cancel("cancelled");
    return new Future.value(false);
  }
}
