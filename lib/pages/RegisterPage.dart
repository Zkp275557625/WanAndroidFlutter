import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/constant/AppColors.dart';

///注册页面
class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage> {
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

    ///监听重复密码输入框变化
    final TextEditingController rePasswordController = TextEditingController();
    rePasswordController.addListener(() {
      print('输入的内容：${rePasswordController.text}');
    });

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('注册'),
      ),
      backgroundColor: Colors.white,
      body: new Column(
        children: <Widget>[
          new Container(
            height: 180,
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
                        new SizedBox(height: 15),
                        new TextField(
                          controller: rePasswordController,
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
                              hintText: '请再次输入密码'),
                        ),
                        new SizedBox(height: 30),
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
