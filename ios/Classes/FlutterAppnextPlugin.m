#import "FlutterAppnextPlugin.h"
#import "FlutterAppnextInterestitialAd.h"

@implementation FlutterAppnextPlugin {
  FlutterEventSink _eventSink;
  NSMutableDictionary* _instances;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_appnext_interstitial"
            binaryMessenger:[registrar messenger]];
  FlutterAppnextPlugin* instance = [[FlutterAppnextPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];

  FlutterViewController* controller = (FlutterViewController*)UIApplication.sharedApplication.delegate.window.rootViewController;

  FlutterEventChannel* eventChannel = [FlutterEventChannel
                                       eventChannelWithName:@"flutter_appnext_interstitial/event"
                                       binaryMessenger:controller];
  [eventChannel setStreamHandler:instance];
}

- (id)init {
  self = [super init];
  if (!self) return nil;

  _instances = [NSMutableDictionary new];
  return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSNumber* instanceID = call.arguments[@"instanceID"];
  if (!instanceID) {
    result([FlutterError errorWithCode:@"INVALIDARG"
                               message:@"instanceID is not specified"
                               details:nil]);
    return;
  }

  FlutterAppnextAd* instance = _instances[instanceID];
  if (!instance) {
    if ([@"interestitial.init" isEqualToString:call.method]) {
      instance = [[FlutterAppnextInterestitialAd alloc] initWithPlugin:self instanceID:instanceID];
      if (instance) {
        _instances[instanceID] = instance;
      }
    }
  }

  if (!instance) {
    NSLog(@"appnextAd instance not found; possibly it has already disposed");
    result(nil);
    return;
  }
  
  if (instance) {
    if ([@"dispose" isEqualToString:call.method]) {
      [_instances removeObjectForKey:instanceID];
      result(nil);
    } else {
      [instance handleMethodCall:call result:result];
    }
    return;
  }

  result(FlutterMethodNotImplemented);
}

#pragma mark FlutterStreamHandler

- (FlutterError*)onListenWithArguments:(id)arguments
                             eventSink:(FlutterEventSink)eventSink {
  _eventSink = eventSink;
  return nil;
}

- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
  NSLog(@"onCancelWithArguments");
  _eventSink = nil;
  return nil;
}

- (void)invokeEvent:(id)arguments {
  if (!_eventSink) return;
  _eventSink(arguments);
}

@end
