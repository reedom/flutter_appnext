#import <Flutter/Flutter.h>

@class FlutterAppnextPlugin;

@interface FlutterAppnextBridge : NSObject

@property (nonatomic, weak, readonly) FlutterAppnextPlugin* plugin;
@property (nonatomic, strong, readonly) NSNumber* instanceID;

- (id)initWithPlugin:(FlutterAppnextPlugin*)plugin instanceID:(NSNumber*)instanceID;
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result;
@end
