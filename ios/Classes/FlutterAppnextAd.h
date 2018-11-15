#import <Flutter/Flutter.h>
#import <AppnextLib/AppnextLib.h>

@class FlutterAppnextPlugin;

@interface FlutterAppnextAd : NSObject<AppnextAdDelegate>

@property (nonatomic, weak, readonly) FlutterAppnextPlugin* plugin;
@property (nonatomic, strong, readonly) NSNumber* instanceID;
@property (nonatomic, strong) AppnextAd* appnextAd;

- (id)initWithPlugin:(FlutterAppnextPlugin*)plugin instanceID:(NSNumber*)instanceID;
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result;
@end
