#import <Foundation/Foundation.h>
#import "FlutterAppnextPlugin.h"
#import "FlutterAppnextBridge.h"

@implementation FlutterAppnextBridge;

- (id)initWithPlugin:(FlutterAppnextPlugin*)plugin instanceID:(NSNumber*)instanceID {
  self = [super init];
  if (!self) return nil;
  
  _plugin = plugin;
  _instanceID = instanceID;
  return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"dispose" isEqualToString:call.method]) {
    return result(nil);
  }
  result(FlutterMethodNotImplemented);
}

@end
