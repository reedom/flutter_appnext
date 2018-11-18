#import <Flutter/Flutter.h>

@class FlutterAppnextPlugin;

@interface FlutterAppnextBridge : NSObject

@property (nonatomic, strong, readonly) NSNumber* instanceID;
@property (nonatomic, weak) FlutterEventSink eventSink;

- (id)initWithInstanceID:(NSNumber*)instanceID;
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result;
@end
