#import <Foundation/Foundation.h>
#import "FlutterAppnextPlugin.h"
#import "FlutterAppnextBridge.h"

@implementation FlutterAppnextBridge;

- (id)initWithInstanceID:(NSNumber*)instanceID {
  self = [super init];
  if (!self) return nil;
  
  _instanceID = instanceID;
  return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"dispose" isEqualToString:call.method]) {
    if (_eventSink != nil) {
      _eventSink(FlutterEndOfEventStream);
    }
    return result(nil);
  }
  result(FlutterMethodNotImplemented);
}

@end
