#import "FlutterAppnextPlugin.h"
#import "FlutterAppnextBannerAd.h"
#import "FlutterAppnextInterstitialAd.h"
#import "FlutterStreamsChannel.h"

#define _GET_INSTANCE_ID(arg) ([arg isKindOfClass:[NSDictionary class]] ? arg[@"instanceID"] : nil)

@interface StreamsHandler : NSObject<FlutterStreamHandler>
@end

@implementation FlutterAppnextPlugin {
}

static NSMutableDictionary* _methodHandlers;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"com.reedom.flutter_appnext"
            binaryMessenger:[registrar messenger]];
  FlutterAppnextPlugin* instance = [[FlutterAppnextPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];

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
      instance = [[FlutterAppnextBannerAd alloc] initWithInstanceID:instanceID];
    } else if ([@"interstitial.init" isEqualToString:call.method]) {
      instance = [[FlutterAppnextInterstitialAd alloc] initWithInstanceID:instanceID];
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
      [_methodHandlers removeObjectForKey:instanceID];
    }
    return;
  }

  result(FlutterMethodNotImplemented);
}

@end

#pragma mark FlutterStreamHandler

@implementation StreamsHandler

- (FlutterError*)onListenWithArguments:(id)arguments
                             eventSink:(FlutterEventSink)eventSink {
  NSNumber* instanceID = _GET_INSTANCE_ID(arguments);
  if (!instanceID) {
    return [FlutterError errorWithCode:@"INVALIDARG"
                               message:@"instanceID is not specified"
                               details:nil];
  }

  FlutterAppnextBridge* instance = _methodHandlers[instanceID];
  if (!instance) {
    return [FlutterError errorWithCode:@"UNEXPECTED"
                               message:@"instance not found"
                               details:nil];
  }

  instance.eventSink = eventSink;
  return nil;
}

- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
  NSNumber* instanceID = _GET_INSTANCE_ID(arguments);
  if (instanceID) {
    [_methodHandlers removeObjectForKey:instanceID];
  }
  return nil;
}

@end
