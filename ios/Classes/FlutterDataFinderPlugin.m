#import "FlutterDataFinderPlugin.h"
#import <RangersAppLog/BDAutoTrack.h>
#import <RangersAppLog/BDAutoTrackConfig.h>
#import <Foundation/Foundation.h>

@implementation FlutterDataFinderPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_datafinder"
            binaryMessenger:[registrar messenger]];
  FlutterDataFinderPlugin* instance = [[FlutterDataFinderPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"init" isEqualToString:call.method]) {
     [self init:call result:result];
  }
  else if ([@"setUid" isEqualToString:call.method]) {
       [self setUid:call result:result];
  }
  else if ([@"event" isEqualToString:call.method]) {
       [self event:call result:result];
  }
  else if ([@"pageStart" isEqualToString:call.method]) {
         [self pageStart:call result:result];
  }
  else if ([@"pageEnd" isEqualToString:call.method]) {
           [self pageEnd:call result:result];
   }
  else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)init:(FlutterMethodCall*)call result:(FlutterResult)result {
      NSString* appId= call.arguments[@"appId"];
      NSString* appName= call.arguments[@"appName"];

      NSLog(@"init appId:%@",appId);
      NSLog(@"init appName:%@",appName);

        /* 初始化开始 */
      BDAutoTrackConfig*config =[BDAutoTrackConfig configWithAppID:appId];

    	/* 只支持上报到国内: BDAutoTrackServiceVendorCN */
      config.serviceVendor = BDAutoTrackServiceVendorCN;

      config.appName = appName; // 与您申请APPID时的app_name一致
      config.channel = @"App Store"; // iOS一般默认App Store
      config.abEnable = FALSE; //开启ab测试，默认为YES

      config.showDebugLog = YES; // 是否在控制台输出日志，仅调试使用，需要同时设置logger。release版本请设置为 NO
      config.logger = ^(NSString * _Nullable log) {
          NSLog(@"%@",log);
      };
      config.logNeedEncrypt = YES; // 是否加密日志，默认加密。release版本请设置为 YES

      config.autoTrackEnabled = YES;
      [BDAutoTrack startTrackWithConfig:config];

      //
      result([NSNumber numberWithBool:YES]);
}

- (void)setUid:(FlutterMethodCall*)call result:(FlutterResult)result {
      NSString* uid= call.arguments[@"uid"];

      NSLog(@"setUid uid:%@",uid);

      //设置您自己的账号体系ID, 并保证其唯一性 ！
      [BDAutoTrack setCurrentUserUniqueID:uid];

      //
      result([NSNumber numberWithBool:YES]);
}

- (void)event:(FlutterMethodCall*)call result:(FlutterResult)result {
      NSString* eventName= call.arguments[@"eventName"];
      NSDictionary* params= call.arguments[@"params"];

      NSLog(@"event eventName:%@",eventName);
      NSLog(@"event params:%@",params);

      NSString* event=[@"event_" stringByAppendingString:eventName];

      if ([params isKindOfClass:[NSNull class]] || [params isEqual:[NSNull null]]) {
             [BDAutoTrack eventV3:event params: NULL];
              result([NSNumber numberWithBool:YES]);
              return;
       }

      [BDAutoTrack eventV3:event params: params];
      //
      result([NSNumber numberWithBool:YES]);
}

- (void)pageStart:(FlutterMethodCall*)call result:(FlutterResult)result {
      NSString* pageName= call.arguments[@"pageName"];
      NSDictionary* params= call.arguments[@"params"];

      NSLog(@"pageStart pageName:%@",pageName);
      NSLog(@"pageStart params:%@",params);

      NSString* event= [@"pageStart_" stringByAppendingString:pageName];

      if ([params isKindOfClass:[NSNull class]] || [params isEqual:[NSNull null]]) {
            [BDAutoTrack eventV3:event params: NULL];
            result([NSNumber numberWithBool:YES]);
            return;
      }
      [BDAutoTrack eventV3:event params: params];

      //
      result([NSNumber numberWithBool:YES]);
}

- (void)pageEnd:(FlutterMethodCall*)call result:(FlutterResult)result {
      NSString* pageName= call.arguments[@"pageName"];
      NSDictionary* params= call.arguments[@"params"];

      NSLog(@"pageEnd pageName:%@",pageName);
      NSLog(@"pageEnd params:%@",params);

      NSString* event= [@"pageEnd_" stringByAppendingString:pageName];

      if ([params isKindOfClass:[NSNull class]] || [params isEqual:[NSNull null]]) {
             [BDAutoTrack eventV3:event params: NULL];
             result([NSNumber numberWithBool:YES]);
             return;
      }

      [BDAutoTrack eventV3:event params: params];

      //
      result([NSNumber numberWithBool:YES]);
}


@end
