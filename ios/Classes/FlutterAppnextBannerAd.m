#import "FlutterAppnextPlugin.h"
#import "FlutterAppnextBannerAd.h"

@implementation FlutterAppnextBannerAd {
  NSString* _placementID;
  AppnextBannerView* _bannerView;
  BannerRequest* _bannerRequest;
  int _anchorOffset;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"banner.init" isEqualToString:call.method]) {
    return [self initInstance:call result:result];
  } else if ([@"loadAd" isEqualToString:call.method]) {
    [self loadBanner];
    return result(nil);
  } else if ([@"showAd" isEqualToString:call.method]) {
    [self loadBanner];
    return result(nil);
  } else if ([@"hideAd" isEqualToString:call.method]) {
    [self destoyBanner];
    return result(nil);
  }

  if ([@"dispose" isEqualToString:call.method]) {
    [self destoyBanner];
  }
  [super handleMethodCall:call result:result];
}

#pragma mark instantiate

- (void)initInstance:(FlutterMethodCall*)call result:(FlutterResult)result {
  _placementID = call.arguments[@"placementID"];
  NSArray* categories = call.arguments[@"categories"];
  NSString* postBack = call.arguments[@"postBack"];
  NSNumber* creative = call.arguments[@"creative"];
  NSNumber* autoPlay = call.arguments[@"autoPlay"];
  NSNumber* mute = call.arguments[@"mute"];
  NSNumber* videoLength = call.arguments[@"videoLength"];
  NSNumber* clickEnabled = call.arguments[@"clickEnabled"];
  NSNumber* maxVideoLength = call.arguments[@"maxVideoLength"];
  NSNumber* minVideoLength = call.arguments[@"minVideoLength"];
  NSNumber* clickInApp = call.arguments[@"clickInApp"];
  NSNumber* bannerType = call.arguments[@"bannerType"];
  
  _bannerRequest = [BannerRequest new];
  if ([categories isKindOfClass:[NSArray class]]) _bannerRequest.categories = categories;
  if ([postBack isKindOfClass:[NSString class]]) _bannerRequest.postBack = postBack;
  if ([creative isKindOfClass:[NSNumber class]]) _bannerRequest.creative = creative.intValue;
  if ([autoPlay isKindOfClass:[NSNumber class]]) _bannerRequest.autoPlay = autoPlay.boolValue;
  if ([mute isKindOfClass:[NSNumber class]]) _bannerRequest.mute = mute.boolValue;
  if ([videoLength isKindOfClass:[NSNumber class]]) _bannerRequest.videoLength = videoLength.intValue;
  if ([clickEnabled isKindOfClass:[NSNumber class]]) _bannerRequest.clickEnabled = clickEnabled.boolValue;
  if ([maxVideoLength isKindOfClass:[NSNumber class]]) _bannerRequest.maxVideoLength = maxVideoLength.intValue;
  if ([minVideoLength isKindOfClass:[NSNumber class]]) _bannerRequest.minVideoLength = minVideoLength.intValue;
  if ([clickInApp isKindOfClass:[NSNumber class]]) _bannerRequest.clickInApp = clickInApp.boolValue;
  if ([bannerType isKindOfClass:[NSNumber class]]) _bannerRequest.bannerType = bannerType.intValue;

  _anchorOffset = 0;
}

- (void)loadBanner {
  if (!_bannerView) {
    [self createBanner];
  }
  [_bannerView loadAd];
}

- (void)createBanner {
  _bannerView = [[AppnextBannerView alloc] initBannerWithPlacementID:_placementID withBannerRequest:_bannerRequest];
  _bannerView.delegate = self;
  
  UIView *screen = [FlutterAppnextBannerAd rootViewController].view;
  _bannerView.translatesAutoresizingMaskIntoConstraints = NO;
  [screen addSubview:_bannerView];
  
#if defined(__IPHONE_11_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0)
  if (@available(ios 11.0, *)) {
    [self placeBanner];
  } else {
    [self placeBannerPreIos11];
  }
#else
  [self placeBannerPreIos11];
#endif
}

- (void)destoyBanner {
  [_bannerView removeFromSuperview];
  _bannerView = nil;
}

#if defined(__IPHONE_11_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0)
- (void)placeBanner {
  UIView *screen = [FlutterAppnextBannerAd rootViewController].view;
  UILayoutGuide *guide = screen.safeAreaLayoutGuide;
  [NSLayoutConstraint activateConstraints:@[
                                            [_bannerView.centerXAnchor constraintEqualToAnchor:guide.centerXAnchor],
                                            [_bannerView.bottomAnchor
                                             constraintEqualToAnchor:guide.bottomAnchor
                                             constant:_anchorOffset]
                                            ]];
}
#endif

- (void)placeBannerPreIos11 {
  UIView *screen = [FlutterAppnextBannerAd rootViewController].view;
  CGFloat x = screen.frame.size.width / 2 - _bannerView.frame.size.width / 2;
  CGFloat y = screen.frame.size.height - _bannerView.frame.size.height + _anchorOffset;
  _bannerView.frame = (CGRect){{x, y}, _bannerView.frame.size};
}

#pragma mark Flutter

+ (UIViewController *)rootViewController {
  return [UIApplication sharedApplication].delegate.window.rootViewController;
}

#pragma mark AppnextBannerDelegate

- (void) onAppnextBannerLoadedSuccessfully {
  if (self.eventSink) {
    self.eventSink(@{@"instanceID": self.instanceID, @"event": @"onAppnextBannerLoadedSuccessfully"});
  }
}

- (void) onAppnextBannerError:(AppnextError) error {
  if (self.eventSink) {
    self.eventSink(@{@"instanceID": self.instanceID, @"event": @"onAppnextBannerError", @"error": [NSNumber numberWithInt:error]});
  }
}

- (void) onAppnextBannerClicked {
  if (self.eventSink) {
    self.eventSink(@{@"instanceID": self.instanceID, @"event": @"onAppnextBannerClicked"});
  }
}

- (void) onAppnextBannerImpressionReported {
  if (self.eventSink) {
    self.eventSink(@{@"instanceID": self.instanceID, @"event": @"onAppnextBannerImpressionReported"});
  }
}

@end
