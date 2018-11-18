#import <Flutter/Flutter.h>
#import <AppnextLib/AppnextLib.h>
#import "FlutterAppnextBridge.h"

@interface FlutterAppnextAd : FlutterAppnextBridge<AppnextAdDelegate>

@property (nonatomic, strong) AppnextAd* appnextAd;

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result;
@end
