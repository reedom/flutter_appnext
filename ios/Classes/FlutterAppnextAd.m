#import "FlutterAppnextPlugin.h"
#import "FlutterAppnextAd.h"

@implementation FlutterAppnextAd;

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"loadAd" isEqualToString:call.method]) {
    [self.appnextAd loadAd];
    return result(nil);
  } else if ([@"showAd" isEqualToString:call.method]) {
    [self.appnextAd showAd];
    return result(nil);
  } else if ([@"setCategories" isEqualToString:call.method]) {
    [self.appnextAd setCategories:call.arguments[@"newValue"]];
    return result(nil);
  } else if ([@"getCategories" isEqualToString:call.method]) {
    return result([self.appnextAd getCategories]);
  } else if ([@"setPostback" isEqualToString:call.method]) {
    [self.appnextAd setPostback:call.arguments[@"newValue"]];
    return result(nil);
  } else if ([@"getPostback" isEqualToString:call.method]) {
    return result([self.appnextAd getPostback]);
  } else if ([@"getButtonText" isEqualToString:call.method]) {
    return result([self.appnextAd getButtonText]);
  } else if ([@"setButtonColor" isEqualToString:call.method]) {
    [self.appnextAd setButtonColor:call.arguments[@"newValue"]];
    return result(nil);
  } else if ([@"getButtonColor" isEqualToString:call.method]) {
    return result([self.appnextAd getButtonColor]);
  } else if ([@"setPreferredOrientation" isEqualToString:call.method]) {
    [self.appnextAd setPreferredOrientation:call.arguments[@"newValue"]];
    return result(nil);
  } else if ([@"getPreferredOrientation" isEqualToString:call.method]) {
    return result([self.appnextAd getPreferredOrientation]);
  } else if ([@"setClickInApp" isEqualToString:call.method]) {
    NSNumber* newValue = call.arguments[@"newValue"];
    [self.appnextAd setClickInApp:newValue.boolValue];
    return result(nil);
  }
  [super handleMethodCall:call result:result];
}

#pragma mark AppnextAdDelegate

- (void) adLoaded:(AppnextAd *)ad
{
  [self.plugin invokeEvent:@{@"instanceID": self.instanceID, @"event": @"adLoaded"}];
}

- (void) adOpened:(AppnextAd *)ad
{
  [self.plugin invokeEvent:@{@"instanceID": self.instanceID, @"event": @"adOpened"}];
}

- (void) adClosed:(AppnextAd *)ad {
  [self.plugin invokeEvent:@{@"instanceID": self.instanceID, @"event": @"adClosed"}];
}

- (void) adClicked:(AppnextAd *)ad {
  [self.plugin invokeEvent:@{@"instanceID": self.instanceID, @"event": @"adClicked"}];
}

- (void) adUserWillLeaveApplication:(AppnextAd *)ad {
  [self.plugin invokeEvent:@{@"instanceID": self.instanceID, @"event": @"adUserWillLeaveApplication"}];
}

- (void) adError:(AppnextAd *)ad error:(NSString *)error {
  [self.plugin invokeEvent:@{@"instanceID": self.instanceID, @"event": @"adError", @"error": error}];
}

@end
