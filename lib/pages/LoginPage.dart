import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/constant/AppColors.dart';
import 'package:flutter_wanandroid/pages/RegisterPage.dart';

///登录页面
class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {

    ///监听用户名输入框文字变化
    final TextEditingController userNameController = TextEditingController();
    userNameController.addListener(() {
      print('输入的内容：${userNameController.text}');
    });

    ///监听密码输入框文字变化
    final TextEditingController passwordController = TextEditingController();
    passwordController.addListener(() {
      print('输入的内容：${passwordController.text}');
    });

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('登录'),
      ),
      backgroundColor: Colors.white,
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
                                  color: AppColors.colorPrimary, fontSize: 14),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                return RegisterPage();
                              }));
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
                              print('被点击了');
                            },
                          ),
                        ),
                      ],
                    ))),
          )
        ],
      ),
    );
  }
}
