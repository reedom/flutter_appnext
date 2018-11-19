#import "FlutterAppnextPlugin.h"
#import "FlutterAppnextInterstitialAd.h"

@implementation FlutterAppnextInterstitialAd {
  AppnextInterstitialAd *_interstitial;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"Interstitial.init" isEqualToString:call.method]) {
    return [self initInstance:call result:result];
  } else if ([@"getCreativeType" isEqualToString:call.method]) {
    ANCreativeType value = [_interstitial getCreativeType];
    return result([NSNumber numberWithInt:value]);
  } else if ([@"setCreativeType" isEqualToString:call.method]) {
    NSNumber* newValue = call.arguments[@"newValue"];
    [_interstitial setCreativeType:(ANCreativeType)newValue.intValue];
    return result(nil);
  } else if ([@"getSkipText" isEqualToString:call.method]) {
    return result([_interstitial getSkipText]);
  } else if ([@"setSkipText" isEqualToString:call.method]) {
    [_interstitial setSkipText:call.arguments[@"newValue"]];
    return result(nil);
  } else if ([@"getAutoPlay" isEqualToString:call.method]) {
    BOOL value = [_interstitial getAutoPlay];
    return result([NSNumber numberWithBool:value]);
  } else if ([@"setAutoPlay" isEqualToString:call.method]) {
    NSNumber* newValue = call.arguments[@"newValue"];
    [_interstitial setAutoPlay:newValue.boolValue];
    return result(nil);
  }
  [super handleMethodCall:call result:result];
}

#pragma mark FlutterMethodCall handlers

- (void) initInstance:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSString* placementID = call.arguments[@"placementID"];
  NSString* categories = call.arguments[@"categories"];
  NSString* postback = call.arguments[@"postback"];
  NSString* preferredOrientation = call.arguments[@"preferredOrientation"];
  NSNumber* clickInApp = call.arguments[@"clickInApp"];
  
  BOOL useConfig =
  [categories isKindOfClass:[NSString class]] ||
  [postback isKindOfClass:[NSString class]] ||
  [preferredOrientation isKindOfClass:[NSString class]] ||
  clickInApp.boolValue;
  
  if (useConfig) {
    AppnextInterstitialAdConfiguration *interstitialConfig = [[AppnextInterstitialAdConfiguration alloc] init];
    interstitialConfig.categories = [categories isKindOfClass:[NSString class]] ? categories : nil;
    interstitialConfig.postback = [postback isKindOfClass:[NSString class]] ? postback : nil;
    interstitialConfig.preferredOrientation = [preferredOrientation isKindOfClass:[NSString class]] ? preferredOrientation : nil;
    interstitialConfig.clickInApp = clickInApp.boolValue;
    if ([placementID isKindOfClass:[NSString class]]) {
      _interstitial = [[AppnextInterstitialAd alloc] initWithConfig:interstitialConfig placementID:placementID];
    } else {
      _interstitial = [[AppnextInterstitialAd alloc] initWithConfig:interstitialConfig];
    }
  } else {
    if ([placementID isKindOfClass:[NSString class]]) {
      _interstitial = [[AppnextInterstitialAd alloc] initWithPlacementID:placementID];
    } else {
      _interstitial = [[AppnextInterstitialAd alloc] init];
    }
  }
  _interstitial.delegate = self;
  self.appnextAd = _interstitial;
  result(nil);
}

@end
