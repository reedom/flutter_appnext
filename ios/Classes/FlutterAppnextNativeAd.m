#import "FlutterAppnextPlugin.h"
#import "FlutterAppnextNativeAd.h"

@implementation FlutterAppnextNativeAd {
  AppnextNativeAdsSDKApi* _api;
  NSMutableDictionary* _adData;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"native.init" isEqualToString:call.method]) {
    return [self initInstance:call result:result];
  }
  if ([@"loadAds" isEqualToString:call.method]) {
    [_api loadAds:[FlutterAppnextNativeAd requestFrom:call] withRequestDelegate:self];
    return result(nil);
  }
  if ([@"adClicked" isEqualToString:call.method]) {
    [_api adClicked:[self adDataFrom:call] withAdOpenedDelegate:self];
    return result(nil);
  }
  if ([@"adImpression" isEqualToString:call.method]) {
    [_api adImpression:[self adDataFrom:call]];
    return result(nil);
  }
  if ([@"videoStarted" isEqualToString:call.method]) {
    [_api videoStarted:[self adDataFrom:call]];
    return result(nil);
  }
  if ([@"videoEnded" isEqualToString:call.method]) {
    [_api videoEnded:[self adDataFrom:call]];
    return result(nil);
  }
  if ([@"privacyClicked" isEqualToString:call.method]) {
    [_api privacyClicked:[self adDataFrom:call] withPrivacyClickedDelegate:self];
    return result(nil);
  }
  [super handleMethodCall:call result:result];
}

+ (AppnextNativeAdsRequest*)requestFrom:(FlutterMethodCall*)call {
  NSNumber* count = call.arguments[@"count"];
  NSNumber* creativeType = call.arguments[@"creativeType"];
  NSArray* categories = call.arguments[@"categories"];
  NSString* postback = call.arguments[@"postback"];
  NSNumber* clickInApp = call.arguments[@"clickInApp"];

  AppnextNativeAdsRequest *request = [AppnextNativeAdsRequest new];
  if ([count isKindOfClass:[NSNumber class]]) request.count = count.intValue;
  if ([creativeType isKindOfClass:[NSNumber class]]) request.creativeType = creativeType.intValue;
  if ([categories isKindOfClass:[NSArray class]] && [categories count]) request.categories = [categories componentsJoinedByString:@","];
  if ([postback isKindOfClass:[NSString class]]) request.postback = postback;
  if ([clickInApp isKindOfClass:[NSNumber class]]) request.clickInApp = clickInApp.boolValue;
  return request;
}

- (AppnextAdData*)adDataFrom:(FlutterMethodCall*)call {
  AppnextAdData* ret = _adData[bannerId];
  return ret;
}

+ (NSDictionary*)adDataToDict:(AppnextAdData*)adData {
  NSMutableDictionary* dict = [NSMutableDictionary new];
  if (adData.buttonText) dict[@"buttonText"] = adData.buttonText;
  if (adData.title) dict[@"title"] = adData.title;
  if (adData.desc) dict[@"desc"] = adData.desc;
  if (adData.urlImg) dict[@"urlImg"] = adData.urlImg;
  if (adData.urlImgWide) dict[@"urlImgWide"] = adData.urlImgWide;
  if (adData.categories) dict[@"categories"] = adData.categories;
  if (adData.idx) dict[@"idx"] = adData.idx;
  if (adData.iosPackage) dict[@"iosPackage"] = adData.iosPackage;
  if (adData.supportedDevices) dict[@"supportedDevices"] = adData.supportedDevices;
  if (adData.urlVideo) dict[@"urlVideo"] = adData.urlVideo;
  if (adData.urlVideoHigh) dict[@"urlVideoHigh"] = adData.urlVideoHigh;
  if (adData.urlVideo30Sec) dict[@"urlVideo30Sec"] = adData.urlVideo30Sec;
  if (adData.urlVideo30SecHigh) dict[@"urlVideo30SecHigh"] = adData.urlVideo30SecHigh;
  if (adData.bannerId) dict[@"bannerID"] = adData.bannerId;
  if (adData.campaignId) dict[@"campaignID"] = adData.campaignId;
  if (adData.country) dict[@"country"] = adData.country;
  if (adData.campaignType) dict[@"campaignType"] = adData.campaignType;
  if (adData.supportedVersion) dict[@"supportedVersion"] = adData.supportedVersion;
  if (adData.storeRating) dict[@"storeRating"] = adData.storeRating;
  if (adData.appSize) dict[@"appSize"] = adData.appSize;
  return dict;
}

#pragma mark AppnextNativeAdsRequestDelegate

- (void) onAdsLoaded:(NSArray<AppnextAdData *> *)ads forRequest:(AppnextNativeAdsRequest *)request {
  NSMutableArray* adsList = [NSMutableArray new];
  for (AppnextAdData* adData in ads) {
    if (adData.bannerId) {
      _adData[adData.bannerId] = adData;
      [adsList addObject:[FlutterAppnextNativeAd adDataToDict:adData]];
    }
  }
  self.eventSink(@{@"instanceID": self.instanceID,
                   @"event": @"onAdsLoaded",
                   @"ads": adsList});
}

- (void) onError:(NSString *)error forRequest:(AppnextNativeAdsRequest *)request {
  self.eventSink(@{@"instanceID": self.instanceID,
                   @"event": @"onErrorForRequest",
                   @"error": error});
}

#pragma mark AppnextNativeAdOpenedDelegate

- (void) storeOpened:(AppnextAdData *)adData {
  self.eventSink(@{@"instanceID": self.instanceID,
                   @"event": @"storeOpened",
                   @"adData": [FlutterAppnextNativeAd adDataToDict:adData]});
}

- (void) onError:(NSString *)error forAdData:(AppnextAdData *)adData {
  self.eventSink(@{@"instanceID": self.instanceID,
                   @"event": @"onErrorForAdData",
                   @"error": error,
                   @"adData": [FlutterAppnextNativeAd adDataToDict:adData]});
}

#pragma mark AppnextPrivacyClickedDelegate

- (void) successOpeningAppnextPrivacy:(AppnextAdData *)adData {
  self.eventSink(@{@"instanceID": self.instanceID,
                   @"event": @"successOpeningAppnextPrivacy",
                   @"adData": [FlutterAppnextNativeAd adDataToDict:adData]});
}

- (void) failureOpeningAppnextPrivacy:(AppnextAdData *)adData {
  self.eventSink(@{@"instanceID": self.instanceID,
                   @"event": @"failureOpeningAppnextPrivacy",
                   @"adData": [FlutterAppnextNativeAd adDataToDict:adData]});
}

#pragma mark FlutterMethodCall handlers

- (void) initInstance:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSString* placementID = call.arguments[@"placementID"];
  _api = [[AppnextNativeAdsSDKApi alloc] initWithPlacementID:placementID withViewController:[FlutterAppnextNativeAd rootViewController]];
  _adData = [NSMutableDictionary new];
  result(nil);
}

#pragma mark Flutter

+ (UIViewController *)rootViewController {
  return [UIApplication sharedApplication].delegate.window.rootViewController;
}

@end
