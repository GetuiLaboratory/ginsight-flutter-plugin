# giflutter

A gingisght Flutter plugin.

### 引用

```
dependencies:
  giflutter: ^0.0.1
```


### 配置
#### Android


在 `/android/app/build.gradle` 中添加下列代码

```
android: {
  ....
  defaultConfig {
    ...
    manifestPlaceholders = [
    	GI_APPID            : "USER_APP_ID",
    	GT_INSTALL_CHANNEL  : "Flutter",
    ]
    ...
  }    
  ...
}
```


### 使用

```
import 'package:giflutter/giflutter.dart';
```


### API

#### 初始化和获取giuid

```
result = await Giflutter.initGInsightSDK('nMSTp6JItAAH5IllE5h2Q3', 'flutter');
if (result is Map) {
    _isSuccess = result['isSuccess'];
    _giuid = result['result'];
}

setState(() {
    _giuid = result['result'] as String;
    _isSuccess = result['isSuccess'] as bool;
});

```

#### 设置渠道(Android)

```
Giflutter.setInstallChannel('Flutter');
```
