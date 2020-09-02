# flutter_datafinder

基于datarangers的datafinder SDK 封装的flutter插件;支持android,ios
[数据漫游者](https://datarangers.com.cn/product/datafinder)


## 安装
项目托管在github,在flutter项目的pubspec.yaml 文件中引入
- 引入插件
```yaml
datafinder_plugin:
    git:
      url: https://github.com/mixiaodou/flutter_datafinder.git
      ref: master
```
- 配置android原生平台
[参考datafinder android接入](https://datarangers.com.cn/help/doc?lid=1097&did=10942)

- 配置ios原生平台
[参考datafinder ios接入](https://datarangers.com.cn/help/doc?lid=1097&did=8547)


运行 flutter pub get

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