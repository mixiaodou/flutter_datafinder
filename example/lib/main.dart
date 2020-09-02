import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_datafinder/flutter_datafinder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterDataFinder.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('flutter_datafinder example'),
        ),
        body: Column(
          children: <Widget>[
            Center(
              child: Text('Running on: $_platformVersion\n'),
            ),
            RaisedButton(
              onPressed: () async {
                //appid:是在官方 https://datarangers.com.cn/ 上注册的应用标示
                if (Platform.isAndroid) {
                  //android平台
                  await FlutterDataFinder.initAndroid(
                      'appid', 'appChannel_abc');
                } else {
                  //ios平台
                  await FlutterDataFinder.initIOS('appid', 'appName_abc');
                }
              },
              child: Text("init"),
            ),
            RaisedButton(
              onPressed: () async {
                //设置 uid用户唯一标示uid
                await FlutterDataFinder.setUid('abc123');
              },
              child: Text("setUid"),
            ),
            RaisedButton(
              onPressed: () async {
                //上报 事件
                await FlutterDataFinder.event('onclick');
              },
              child: Text("event"),
            ),
            RaisedButton(
              onPressed: () async {
                //上报 事件,可携带参数params
                await FlutterDataFinder.event('onclick2', params: {'a': 1});
              },
              child: Text("event params"),
            ),
            RaisedButton(
              onPressed: () async {
                //上报 pageStart事件,指定pageName(datafinder并没有page的切换事件，这里是基于event的封装)
                await FlutterDataFinder.pageStart('homePage');
              },
              child: Text("pageStart"),
            ),
            RaisedButton(
              onPressed: () async {
                //上报 pageStart事件,指定pageName(datafinder并没有page的切换事件，这里是基于event的封装)
                await FlutterDataFinder.pageStart('homePage',
                    params: {'a': 123});
              },
              child: Text("pageStart params"),
            ),
            RaisedButton(
              onPressed: () async {
                //上报 pageEnd事件,指定pageName(datafinder并没有page的切换事件，这里是基于event的封装)
                await FlutterDataFinder.pageEnd('homePage', params: {'a': 123});
              },
              child: Text("pageEnd params"),
            ),
          ],
        ),
      ),
    );
  }
}
