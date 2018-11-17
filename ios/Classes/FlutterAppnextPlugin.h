#import <Flutter/Flutter.h>
#import "FlutterStreamsChannel.h"

@interface FlutterAppnextPlugin : NSObject<FlutterPlugin, FlutterStreamHandler>
- (void)invokeEvent:(id)arguments;
@end
