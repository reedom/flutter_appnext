#import <Flutter/Flutter.h>
#import "FlutterAppnextBridge.h"
#import <AppnextNativeAdsSDK/AppnextNativeAdsSDK.h>

@interface FlutterAppnextNativeAd : FlutterAppnextBridge<AppnextNativeAdsRequestDelegate, AppnextNativeAdOpenedDelegate, AppnextPrivacyClickedDelegate>
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result;
@end
