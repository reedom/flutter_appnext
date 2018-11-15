#import <Flutter/Flutter.h>

@interface FlutterAppnextPlugin : NSObject<FlutterPlugin, FlutterStreamHandler>
- (void)invokeEvent:(id)arguments;
@end
