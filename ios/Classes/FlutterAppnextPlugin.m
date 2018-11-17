#import "FlutterAppnextPlugin.h"
#import "FlutterAppnextBannerAd.h"
#import "FlutterAppnextInterestitialAd.h"
#import "FlutterStreamsChannel.h"

#define _GET_INSTANCE_ID(arg) ([arg isKindOfClass:[NSDictionary class]] ? arg[@"instanceID"] : nil)

@interface StreamsHandler : NSObject<FlutterStreamHandler>
@end

@implementation FlutterAppnextPlugin {
  NSMutableDictionary* _methodHandlers;
}

static NSMutableDictionary* streamsHandlers;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"com.reedom.flutter_appnext"
            binaryMessenger:[registrar messenger]];
  FlutterAppnextPlugin* instance = [[FlutterAppnextPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];

  streamsHandlers = [NSMutableDictionary new];

  FlutterStreamsChannel *eventChannel = [FlutterStreamsChannel
                                         streamsChannelWithName:@"com.reedom.flutter_appnext/event"
                                         binaryMessenger:registrar.messenger]; // controller
  [eventChannel setStreamHandlerFactory:^NSObject<FlutterStreamHandler> *(id arguments) {
    return [StreamsHandler new];
  }];
}

- (id)init {
  self = [super init];
  if (!self) return nil;

  _methodHandlers = [NSMutableDictionary new];
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

  FlutterAppnextBridge* instance = _methodHandlers[instanceID];
  if (!instance) {
    if ([@"banner.init" isEqualToString:call.method]) {
      instance = [[FlutterAppnextBannerAd alloc] initWithPlugin:self instanceID:instanceID];
    } else if ([@"interestitial.init" isEqualToString:call.method]) {
      instance = [[FlutterAppnextInterestitialAd alloc] initWithPlugin:self instanceID:instanceID];
    }
    if (instance) {
      _methodHandlers[instanceID] = instance;
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
      [self close:instanceID];
    }
    return;
  }

  result(FlutterMethodNotImplemented);
}

- (void)invokeEvent:(id)arguments {
  NSNumber* instanceID = _GET_INSTANCE_ID(arguments);
  if (!instanceID) {
    NSLog(@"invokeEvent: instance ID is required");
    return;
  }
  
  FlutterEventSink eventSink = streamsHandlers[instanceID];
  if (!eventSink) {
    NSLog(@"event sink is not found");
    return;
  }
  if (arguments[@"event"] == FlutterEndOfEventStream) {
    eventSink(FlutterEndOfEventStream);
  } else {
    eventSink(arguments);
  }
}

- (void)close:(NSNumber*)instanceID {
  FlutterEventSink eventSink = streamsHandlers[instanceID];
  if (!eventSink) {
    NSLog(@"event sink is not found");
    return;
  }
  eventSink(FlutterEndOfEventStream);
  [streamsHandlers removeObjectForKey:instanceID];
  [_methodHandlers removeObjectForKey:instanceID];
}

@end

#pragma mark FlutterStreamHandler

@implementation StreamsHandler

- (void)dealloc {
  NSLog(@"dealloc");
}

- (FlutterError*)onListenWithArguments:(id)arguments
                             eventSink:(FlutterEventSink)eventSink {
  NSNumber* instanceID = _GET_INSTANCE_ID(arguments);
  if (!instanceID) {
    return [FlutterError errorWithCode:@"INVALIDARG"
                               message:@"instanceID is not specified"
                               details:nil];
  }
  streamsHandlers[instanceID] = eventSink;
  return nil;
}

- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
  NSLog(@"onCancelWithArguments %@", arguments);
  return nil;
}

@end
