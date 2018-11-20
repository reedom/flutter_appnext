#import <Flutter/Flutter.h>
#import <AppnextLib/AppnextLib.h>
#import "FlutterAppnextAd.h"

@class FlutterAppnextPlugin;

@interface FlutterAppnextInterstitialAd : FlutterAppnextAd
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result;
@end
