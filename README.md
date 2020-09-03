# flutter_datafinder

基于datarangers[数据漫游者](https://datarangers.com.cn/product/datafinder)的datafinder SDK 封装的flutter插件;
#### 支持android,ios


## 安装
项目托管在github,在flutter项目的pubspec.yaml 文件中引入
- 引入插件
```yaml
flutter_datafinder:
    git:
      url: https://github.com/mixiaodou/flutter_datafinder.git
      ref: master
```
- 配置android原生平台
[参考datafinder android接入](https://datarangers.com.cn/help/doc?lid=1097&did=10942)
1. flutter项目android目录下的 build.gradle中添加:
 ```groovy
 dependencies {
        //
        classpath 'com.bytedance.applog:RangersAppLog-All-plugin:5.2.6'
    }
```
2. android/app/目录下的 build.gradle中添加:
```groovy
//
apply plugin: 'com.bytedance.std.tracker'


android{

    defaultConfig {
         
           //url_scheme,在数据漫游者平台注册的应用的url_scheme
           manifestPlaceholders.put("APPLOG_SCHEME", "应用的url_scheme".toLowerCase())
    }
}

```
3. app/src/main目录下的 AndroidManifest.xml 中添加:
```xml
    <uses-permission android:name="android.permission.READ_PHONE_STATE"/>
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

- 配置ios原生平台
[参考datafinder ios接入](https://datarangers.com.cn/help/doc?lid=1097&did=8547)
1. flutter项目下ios目录下 Podfile添加源：
```
source 'https://github.com/bytedance/cocoapods_sdk_source_repo.git'
```
执行 pod install --repo-update 更新Pods

2. [添加URL Scheme 参考](https://datarangers.com.cn/help/doc?lid=1097&did=8547#_4-%E6%B7%BB%E5%8A%A0url-scheme)



- 运行 flutter pub get

## 使用
- 初始化datafinder的sdk
```dart
      //appid:是在官方 https://datarangers.com.cn/ 上注册的应用标示
       if (Platform.isAndroid) {
            //android平台
           await DataFinderPlugin.initAndroid('appid', 'appChannel_abc');
       } else {
             //ios平台
           await DataFinderPlugin.initIOS('appid', 'appName_abc');
       }
       
```
- 事件上报
```dart
//上报 事件,可携带参数params
await FlutterDataFinder.event('onclick2', params: {'a': 1});

//上报 pageStart事件,指定pageName(datafinder并没有page的切换事件，这里是基于event的封装)
await FlutterDataFinder.pageStart('homePage');

 //上报 pageStart事件,指定pageName(datafinder并没有page的切换事件，这里是基于event的封装),可携带参数params
await FlutterDataFinder.pageStart('homePage',params: {'a': 123});

//上报 pageEnd事件,指定pageName(datafinder并没有page的切换事件，这里是基于event的封装)
await FlutterDataFinder.pageEnd('homePage');

//上报 pageEnd事件,指定pageName(datafinder并没有page的切换事件，这里是基于event的封装),可携带参数params
await FlutterDataFinder.pageEnd('homePage', params: {'a': 123});

```

## 补充说明
- flutter_datafinder事件上报api和datafinder事件上报api对照表

| flutter_datafinder | datafinder sdk |
| ------ | ------ |
| event(eventName)   | event("event_"+eventName)  |
| pageStart(pageName)| event("pageStart_"+pageName)|
| pageEnd(pageName)  | event("pageEnd_"+pageName)  |
