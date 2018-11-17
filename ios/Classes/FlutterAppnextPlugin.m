#import "FlutterAppnextPlugin.h"
#import "FlutterAppnextBannerAd.h"
#import "FlutterAppnextInterestitialAd.h"

#define _GET_INSTANCE_ID(arg) ([arg isKindOfClass:[NSDictionary class]] ? arg[@"instanceID"] : nil)

@implementation FlutterAppnextPlugin {
  NSMutableDictionary* _instances;
  NSMutableDictionary* _events;
}


+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"com.reedom.flutter_appnext"
            binaryMessenger:[registrar messenger]];
  FlutterAppnextPlugin* instance = [[FlutterAppnextPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];

  FlutterViewController* controller = (FlutterViewController*)UIApplication.sharedApplication.delegate.window.rootViewController;

  FlutterStreamsChannel *eventChannel = [FlutterStreamsChannel
                                         streamsChannelWithName:@"com.reedom.flutter_appnext/event"
                                         binaryMessenger:registrar.messenger]; // controller
  [eventChannel setStreamHandlerFactory:^NSObject<FlutterStreamHandler> *(id arguments) {
    NSLog(@"setStreamHandlerFactory");
    return instance;
  }];
}

- (id)init {
  self = [super init];
  if (!self) return nil;

  _instances = [NSMutableDictionary new];
  _events = [NSMutableDictionary new];
  return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSNumber* instanceID = _GET_INSTANCE_ID(call.arguments);
  if (!instanceID) {
    NSLog(@"instanceID is not specified");
    result([FlutterError errorWithCode:@"INVALIDARG"
                               message:@"instanceID is not specified"
                               details:nil]);
    return;
  }

  FlutterAppnextBridge* instance = _instances[instanceID];
  if (!instance) {
    if ([@"banner.init" isEqualToString:call.method]) {
      instance = [[FlutterAppnextBannerAd alloc] initWithPlugin:self instanceID:instanceID];
    } else if ([@"interestitial.init" isEqualToString:call.method]) {
      instance = [[FlutterAppnextInterestitialAd alloc] initWithPlugin:self instanceID:instanceID];
    }
    if (instance) {
      _instances[instanceID] = instance;
    }
  }

  if (!instance) {
    NSLog(@"FlutterAppnextBridge instance not found; possibly it has already been disposed");
    result([FlutterError errorWithCode:@"INVALIDARG"
                               message:@"instance not found"
                               details:nil]);
    return;
  }
  
  if (instance) {
    [instance handleMethodCall:call result:result];
    if ([@"dispose" isEqualToString:call.method]) {
      [_instances removeObjectForKey:instanceID];
    }
    return;
  }

  result(FlutterMethodNotImplemented);
}

#pragma mark FlutterStreamHandler

- (FlutterError*)onListenWithArguments:(id)arguments
                             eventSink:(FlutterEventSink)eventSink {
  NSNumber* instanceID = _GET_INSTANCE_ID(arguments);
  if (!instanceID) {
    return [FlutterError errorWithCode:@"INVALIDARG"
                               message:@"instanceID is not specified"
                               details:nil];
  }
  _events[instanceID] = eventSink;
  return nil;
}

- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
  NSLog(@"onCancelWithArguments");
  // _eventSink should not be set nil since cancelling occurs
  // whenever any Dart class instance which is listening to this
  // eventChannel has been destroyed.
  // _eventSink = nil;
  return nil;
}

- (void)invokeEvent:(id)arguments {
  NSNumber* instanceID = _GET_INSTANCE_ID(arguments);
  if (!instanceID) {
    NSLog(@"invokeEvent: instance ID is required");
    return;
  }
  
  FlutterEventSink eventSink = _events[instanceID];
  if (!eventSink) {
    NSLog(@"event sink is not found");
    return;
  }
  eventSink(arguments);
}

@end
