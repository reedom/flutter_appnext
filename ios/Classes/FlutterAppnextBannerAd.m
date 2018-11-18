#import <AppnextSDKCore/AppnextSDKCore.h>
#import "FlutterAppnextPlugin.h"
#import "FlutterAppnextBannerAd.h"

@interface UIView (RemoveConstraints)

- (void)removeAllConstraints;

@end


@implementation UIView (RemoveConstraints)

- (void)removeAllConstraints
{
  UIView *superview = self.superview;
  while (superview != nil) {
    for (NSLayoutConstraint *c in superview.constraints) {
      if (c.firstItem == self || c.secondItem == self) {
        [superview removeConstraint:c];
      }
    }
    superview = superview.superview;
  }

  [self removeConstraints:self.constraints];
  self.translatesAutoresizingMaskIntoConstraints = YES;
}

@end

@implementation FlutterAppnextBannerAd {
  NSString* _placementID;
  AppnextBannerView* _bannerView;
  BannerRequest* _bannerRequest;
  ANPositionInViewType _anchorPosition;
  BannerType _bannerType;
  CGVector _anchorOffset;
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
  } else if ([@"setAnchorPosition" isEqualToString:call.method]) {
    _anchorPosition = [call.arguments[@"newValue"] intValue];
    [self performSelectorOnMainThread:@selector(placeBanner) withObject:nil waitUntilDone:FALSE];
    return result(nil);
  } else if ([@"getAnchorPosition" isEqualToString:call.method]) {
    return result([NSNumber numberWithUnsignedInteger:_anchorPosition]);
  } else if ([@"setAnchorOffset" isEqualToString:call.method]) {
    [self setAnchorOffset:call.arguments[@"newValue"]];
    [self performSelectorOnMainThread:@selector(placeBanner) withObject:nil waitUntilDone:FALSE];
    return result(nil);
  } else if ([@"getAnchorOffset" isEqualToString:call.method]) {
    return result(@{@"x": [NSNumber numberWithDouble:_anchorOffset.dx],
                    @"y": [NSNumber numberWithDouble:_anchorOffset.dy]});
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
  NSNumber* anchorPosition = call.arguments[@"anchorPosition"];
  NSDictionary* anchorOffset = call.arguments[@"anchorOffset"];

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
  if ([bannerType isKindOfClass:[NSNumber class]]) {
    _bannerRequest.bannerType = bannerType.intValue;
    _bannerType = bannerType.intValue;
  }
  if ([anchorPosition isKindOfClass:[NSNumber class]]) _anchorPosition = anchorPosition.intValue;
  [self setAnchorOffset:anchorOffset];

  if (@available(ios 11.0, *)) {
  } else {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(orientationChanged:)
                                               name:UIDeviceOrientationDidChangeNotification
                                             object:nil];
  }
}

- (void)dealloc {
  [NSNotificationCenter.defaultCenter removeObserver:self];
}

-(void)orientationChanged:(NSNotification*)notification {
  [self placeBanner];
}

-(void)setAnchorOffset:(NSDictionary*)newValue {
  double x = 0;
  double y = 0;
  if (newValue) {
    if ([newValue[@"x"] isKindOfClass:[NSNumber class]]) {
      x = [newValue[@"x"] doubleValue];
    }
    if ([newValue[@"y"] isKindOfClass:[NSNumber class]]) {
      y = [newValue[@"y"] doubleValue];
    }
  }
  _anchorOffset = CGVectorMake(x, y);
}

- (CGSize) getBannerSize {
  switch (_bannerType) {
    case Banner:
    default:
      return CGSizeMake(320.0, 50.0);
    case LargeBanner:
      return CGSizeMake(320.0, 100.0);
    case MediumRectangle:
      return CGSizeMake(300.0, 250.0);
  }
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
  [screen addSubview:_bannerView];

  [self placeBanner];
}

- (void)destoyBanner {
  [_bannerView removeFromSuperview];
  _bannerView = nil;
}

- (void)placeBanner {
  if (@available(ios 11.0, *)) {
    [self placeBannerIos11];
  } else {
    [self placeBannerPreIos11];
  }
}

- (void)placeBannerIos11 {
  if (!_bannerView) return;

  if (@available(ios 11.0, *)) {
    UIView *screen = [FlutterAppnextBannerAd rootViewController].view;
    UILayoutGuide *guide = screen.safeAreaLayoutGuide;
    NSLayoutXAxisAnchor* viewAnchorX = nil;
    NSLayoutXAxisAnchor* guideAnchorX = nil;
    switch (_anchorPosition) {
      case ANPositionInViewTypeBottomRight:
      case ANPositionInViewTypeTopRight:
      case ANPositionInViewTypeRight:
        viewAnchorX = _bannerView.rightAnchor;
        guideAnchorX = guide.rightAnchor;
        break;
      case ANPositionInViewTypeBottomLeft:
      case ANPositionInViewTypeTopLeft:
      case ANPositionInViewTypeLeft:
        viewAnchorX = _bannerView.leftAnchor;
        guideAnchorX = guide.leftAnchor;
        break;
      case ANPositionInViewTypeNone:
      case ANPositionInViewTypeBottom:
      case ANPositionInViewTypeTop:
      case ANPositionInViewTypeCenter:
      default:
        viewAnchorX = _bannerView.centerXAnchor;
        guideAnchorX = guide.centerXAnchor;
        break;
    }

    NSLayoutYAxisAnchor* viewAnchorY = nil;
    NSLayoutYAxisAnchor* guideAnchorY = nil;
    switch (_anchorPosition) {
      case ANPositionInViewTypeBottomRight:
      case ANPositionInViewTypeBottomLeft:
      case ANPositionInViewTypeNone:
      case ANPositionInViewTypeBottom:
      default:
        viewAnchorY = _bannerView.bottomAnchor;
        guideAnchorY = guide.bottomAnchor;
        break;
      case ANPositionInViewTypeTopRight:
      case ANPositionInViewTypeTopLeft:
      case ANPositionInViewTypeTop:
        viewAnchorY = _bannerView.topAnchor;
        guideAnchorY = guide.topAnchor;
        break;
      case ANPositionInViewTypeRight:
      case ANPositionInViewTypeLeft:
      case ANPositionInViewTypeCenter:
        viewAnchorY = _bannerView.centerYAnchor;
        guideAnchorY = guide.centerYAnchor;
        break;
    }

    CGSize bannerSize = [self getBannerSize];
    [_bannerView removeAllConstraints];
    _bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[[_bannerView.widthAnchor constraintEqualToConstant:bannerSize.width],
                                              [_bannerView.heightAnchor constraintEqualToConstant:bannerSize.height],
                                              (0 <= _anchorOffset.dx) ?
                                              [viewAnchorX constraintGreaterThanOrEqualToAnchor:guideAnchorX constant:_anchorOffset.dx] :
                                              [viewAnchorX constraintLessThanOrEqualToAnchor:guideAnchorX constant:_anchorOffset.dx],
                                              (0 <= _anchorOffset.dy) ?
                                              [viewAnchorY constraintGreaterThanOrEqualToAnchor:guideAnchorY constant:_anchorOffset.dy] :
                                              [viewAnchorY constraintLessThanOrEqualToAnchor:guideAnchorY constant:_anchorOffset.dy]]];
  }
}

- (void)placeBannerPreIos11 {
  UIView *screen = [FlutterAppnextBannerAd rootViewController].view;
  CGSize bannerSize = [self getBannerSize];

  CGFloat x, y;
  switch (_anchorPosition) {
    case ANPositionInViewTypeBottomRight:
    case ANPositionInViewTypeTopRight:
    case ANPositionInViewTypeRight:
      x = screen.frame.size.width - bannerSize.width + _anchorOffset.dx;
      break;
    case ANPositionInViewTypeBottomLeft:
    case ANPositionInViewTypeTopLeft:
    case ANPositionInViewTypeLeft:
      x = _anchorOffset.dx;
      break;
    case ANPositionInViewTypeNone:
    case ANPositionInViewTypeBottom:
    case ANPositionInViewTypeTop:
    case ANPositionInViewTypeCenter:
    default:
      x = screen.frame.size.width / 2 - bannerSize.width / 2 + _anchorOffset.dx;
      break;
  }

  switch (_anchorPosition) {
    case ANPositionInViewTypeBottomRight:
    case ANPositionInViewTypeBottomLeft:
    case ANPositionInViewTypeNone:
    case ANPositionInViewTypeBottom:
    default:
      y = screen.frame.size.height - bannerSize.height + _anchorOffset.dy;
      break;
    case ANPositionInViewTypeTopRight:
    case ANPositionInViewTypeTopLeft:
    case ANPositionInViewTypeTop:
      y = _anchorOffset.dy;
      break;
    case ANPositionInViewTypeRight:
    case ANPositionInViewTypeLeft:
    case ANPositionInViewTypeCenter:
      y = screen.frame.size.height / 2 - bannerSize.height / 2 + _anchorOffset.dy;
      break;
  }

  _bannerView.frame = (CGRect){{x, y}, bannerSize};
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
