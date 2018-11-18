import 'dart:async';
import 'dart:ui';

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
    ANAnchorPosition anchorPosition = ANAnchorPosition.bottom,
    Offset anchorOffset,
  }) {
    final arg = <String, dynamic>{
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
      'anchorPosition': anchorPositionToInt(anchorPosition),
      'anchorOffset': <String, double>{
        'x': anchorOffset != null ? anchorOffset.dx : 0.0,
        'y': anchorOffset != null ? anchorOffset.dy : 0.0,
      },
    };
    channel.invokeMethod('banner.init', arg);
    eventChannel.receiveBroadcastStream(arg).listen(onEvent, onError: onError, onDone: onDone);
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

  Future<ANAnchorPosition> getAnchorPosition() async {
    final value = await channel.invokeMethod('getAnchorPosition', <String, dynamic>{'instanceID': this.hashCode});
    return anchorPositionFrom(value);
  }

  Future<void> setAnchorPosition(ANAnchorPosition newValue) async {
    await channel.invokeMethod('setAnchorPosition', <String, dynamic>{
      'instanceID': this.hashCode,
      'newValue': anchorPositionToInt(newValue),
    });
  }

  Future<Offset> getAnchorOffset() async {
    final Map<String, dynamic> value =
        await channel.invokeMethod('getAnchorOffset', <String, dynamic>{'instanceID': this.hashCode});
    return Offset(value['x'], value['y']);
  }

  Future<void> setAnchorOffset(Offset newValue) async {
    await channel.invokeMethod('setAnchorOffset', <String, dynamic>{
      'instanceID': this.hashCode,
      'newValue': <String, dynamic>{'x': newValue.dx, 'y': newValue.dy},
    });
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
