import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:giflutter/giflutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _giuid;
  bool _isSuccess;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    dynamic result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await Giflutter.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    Giflutter.setInstallChannel('Flutter');

    result = await Giflutter.initGInsightSDK('nMSTp6JItAAH5IllE5h2Q3', 'flutter');
    if (result is Map) {
      _isSuccess = result['isSuccess'];
      _giuid = result['result'];
    }
    print(result);

    setState(() {
      _platformVersion = platformVersion;
      _giuid = result['result'] as String;
      _isSuccess = result['isSuccess'] as bool;
    });
  }

  void check() async {
    if (_isSuccess) {
      //查询画像
      String url = 'http://demo-gi.getui.com/v3/?os=android&giuid=$_giuid';
      print('点击 查询画像: $url');
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('GInsight Flutter Demo'),
          ),
          body: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Center(
                child: Text(
                  'Running on: $_platformVersion\nGIUID : $_giuid\n',
                  textAlign: TextAlign.center,
                ),
              ),
              new CupertinoButton(
                child: Text('查询画像'),
                color: Colors.blue,
                onPressed: () {
                  check();
                },
              )
            ],
          )),
    );
  }
}
