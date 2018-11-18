#import <Flutter/Flutter.h>
#import <AppnextLib/AppnextLib.h>
#import "FlutterAppnextBridge.h"

@class FlutterAppnextPlugin;

@interface FlutterAppnextBannerAd : FlutterAppnextBridge<AppnextBannerDelegate>

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result;
@end
