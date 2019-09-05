#import "GiflutterPlugin.h"
#import <GInsightSDK/GInsightSDK.h>

@implementation GiflutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"giflutter"
            binaryMessenger:[registrar messenger]];
  GiflutterPlugin* instance = [[GiflutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
      result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"init" isEqualToString:call.method]) {
      [self startSdk:call result:result];
  } else {
      result(FlutterMethodNotImplemented);
  }
}

- (void)startSdk:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *ConfigurationInfo = call.arguments;
    NSString *appId = ConfigurationInfo[@"appid"] ?: @"";
    NSString *channel = ConfigurationInfo[@"channel"] ?: @"";
    [GInsightSDK startSDK:appId channel:channel onSuccess:^(NSString *giUid) {
        result(@{@"isSuccess":@(YES), @"result": giUid});
    } onFail:^(NSString *failInfo) {
        result(@{@"isSuccess":@(NO), @"result": failInfo});
    }];
}

@end
