import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_appnext/src/plugin.dart';
import 'package:flutter_appnext/src/types.dart';
import 'package:meta/meta.dart';

class ANNativeAd extends ANAppnextPlugin {
  void Function(ANNativeAd instance, List<ANAdData> ads) adsLoaded;
  void Function(ANNativeAd instance, String error) errorForRequest;
  void Function(ANNativeAd instance, ANAdData adData) storeOpened;
  void Function(ANNativeAd instance, String error, ANAdData adData) errorForAdData;
  void Function(ANNativeAd instance, ANAdData adData) successOpeningAppnextPrivacy;
  void Function(ANNativeAd instance, ANAdData adData) failureOpeningAppnextPrivacy;

  ANNativeAd({
    @required String placementID,
    this.adsLoaded,
    this.errorForRequest,
    this.storeOpened,
    this.errorForAdData,
    this.successOpeningAppnextPrivacy,
    this.failureOpeningAppnextPrivacy,
  }) {
    final arg = <String, dynamic>{
      'instanceID': hashCode,
      'placementID': placementID,
    };
    channel.invokeMethod('native.init', arg);
    eventChannel.receiveBroadcastStream(arg).listen(onEvent, onError: onError, onDone: onDone);
  }

  Future<void> loadAds({
    int count,
    ANCreativeType creativeType,
    List<String> categories,
    String postBack,
    bool clickInApp,
  }) async {
    final arg = <String, dynamic>{
      'instanceID': hashCode,
      'count': count,
      'creativeType': creativeTypeToInt(creativeType),
      'categories': categories,
      'postBack': postBack,
      'clickInApp': clickInApp,
    };
    await channel.invokeMethod('loadAds', arg);
  }

  Future<void> adClicked(String bannerID) async {
    await channel.invokeMethod('adClicked', <String, dynamic>{'instanceID': hashCode, 'bannerID': bannerID});
  }

  Future<void> adImpression(String bannerID) async {
    await channel.invokeMethod('adImpression', <String, dynamic>{'instanceID': hashCode, 'bannerID': bannerID});
  }

  Future<void> videoStarted(String bannerID) async {
    await channel.invokeMethod('videoStarted', <String, dynamic>{'instanceID': hashCode, 'bannerID': bannerID});
  }

  Future<void> videoEnded(String bannerID) async {
    await channel.invokeMethod('videoEnded', <String, dynamic>{'instanceID': hashCode, 'bannerID': bannerID});
  }

  Future<void> privacyClicked(String bannerID) async {
    await channel.invokeMethod('privacyClicked', <String, dynamic>{'instanceID': hashCode, 'bannerID': bannerID});
  }

  @override
  void onEvent(Object event) {
    debugPrint('native.onEvent "$event"');
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
      case 'onAdsLoaded':
        if (adsLoaded != null) _adsLoaded(this, map['ads']);
        return;
      case 'onErrorForRequest':
        if (errorForRequest != null) errorForRequest(this, map['error']);
        return;
      case 'storeOpened':
        if (storeOpened != null) storeOpened(this, ANAdData.fromMap(map['adData']));
        return;
      case 'onErrorForAdData':
        if (errorForAdData != null) errorForAdData(this, map['error'], ANAdData.fromMap(map['adData']));
        return;
      case 'successOpeningAppnextPrivacy':
        if (successOpeningAppnextPrivacy != null) successOpeningAppnextPrivacy(this, ANAdData.fromMap(map['adData']));
        return;
      case 'storeOpened':
        if (failureOpeningAppnextPrivacy != null) failureOpeningAppnextPrivacy(this, ANAdData.fromMap(map['adData']));
        return;
    }

    super.onEvent(event);
  }

  void _adsLoaded(ANNativeAd anNativeAd, List<dynamic> ads) {
    List<ANAdData> adList = List<ANAdData>();
    for (dynamic adData in ads) {
      if (adData is Map<dynamic, dynamic>) {
        adList.add(ANAdData.fromMap(adData));
      }
    }

    adsLoaded(this, adList);
  }
}
