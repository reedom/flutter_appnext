import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_appnext/src/plugin.dart';
import 'package:flutter_appnext/src/types.dart';
import 'package:meta/meta.dart';

class ANBannerAd extends ANAppnextPlugin {
  ValueChanged<ANBannerAd> adLoaded;
  ValueChanged<ANBannerAd> adOpened;
  ValueChanged<ANBannerAd> adImpressionReported;
  ValueChanged<ANBannerAd> adClicked;
  ValueChanged<ANBannerAdError> adError;

  ANBannerAd({
    @required String placementID,
    List<String> categories,
    String postBack,
    ANCreative creative,
    bool autoPlay,
    bool mute,
    ANVideoLength videoLength,
    bool clickEnabled,
    int maxVideoLength,
    int minVideoLength,
    bool clickInApp,
    ANBannerType bannerType,
    this.adLoaded,
    this.adOpened,
    this.adImpressionReported,
    this.adClicked,
    this.adError,
  }) {
    channel.invokeMethod('banner.init', <String, dynamic>{
      'instanceID': hashCode,
      'placementID': placementID,
      'categories': categories,
      'postBack': postBack,
      'creative': creativeToInt(creative),
      'autoPlay': autoPlay,
      'mute': mute,
      'videoLength': videoLengthToInt(videoLength),
      'clickEnabled': clickEnabled,
      'maxVideoLength': maxVideoLength,
      'minVideoLength': minVideoLength,
      'clickInApp': clickInApp,
      'bannerType': bannerTypeToInt(bannerType),
    });
  }

  Future<void> loadAd() async {
    await channel.invokeMethod('loadAd', <String, dynamic>{'instanceID': hashCode});
  }

  Future<void> showBanner() async {
    await channel.invokeMethod('showAd', <String, dynamic>{'instanceID': hashCode});
  }

  Future<void> hideBanner() async {
    await channel.invokeMethod('hideAd', <String, dynamic>{'instanceID': hashCode});
  }

  @override
  void onEvent(Object event) {
    debugPrint('banner.onEvent "$event"');
    if (disposed) {
      debugPrint('already disposed');
      return;
    }
    if (!(event is Map<dynamic, dynamic>)) {
      debugPrint('wrong type');
      super.onEvent(event);
      return;
    }

    final map = event as Map<dynamic, dynamic>;
    // We handle events only relates to this instance.
    if (map['instanceID'] != hashCode) {
      debugPrint('hash mismatch ${map['instanceID']} != $hashCode');
      return;
    }

    String cause = map['event'];
    switch (cause) {
      case 'onAppnextBannerLoadedSuccessfully':
        if (adLoaded != null) adLoaded(this);
        return;
      case 'onAppnextBannerError':
        if (adError != null) adError(ANBannerAdError(this, map['error']));
        return;
      case 'onAppnextBannerClicked':
        if (adClicked != null) adClicked(this);
        return;
      case 'onAppnextBannerImpressionReported':
        if (adImpressionReported != null) adImpressionReported(this);
        return;
    }

    super.onEvent(event);
  }
}

class ANBannerAdError {
  final ANBannerAd bannerAd;
  final String error;

  ANBannerAdError(this.bannerAd, this.error);

  @override
  String toString() {
    return 'ANBannerAdError: $error';
  }
}
