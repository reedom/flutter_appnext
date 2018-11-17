import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_appnext/src/ad.dart';
import 'package:flutter_appnext/src/types.dart';

class ANInterstitialAd extends ANAd {
  @override
  String get initMethod => 'interestitial.init';

  ValueChanged<ANInterstitialAd> adLoaded;
  ValueChanged<ANInterstitialAd> adOpened;
  ValueChanged<ANInterstitialAd> adClosed;
  ValueChanged<ANInterstitialAd> adClicked;
  ValueChanged<ANInterstitialAd> adUserWillLeaveApplication;
  ValueChanged<ANInterstitialAdError> adError;

  ANInterstitialAd({
    String placementID,
    ANAdConfiguration adConfiguration,
    this.adLoaded,
    this.adOpened,
    this.adClicked,
    this.adUserWillLeaveApplication,
    this.adError,
  }) : super(placementID: placementID, adConfiguration: adConfiguration);

  Future<ANCreativeType> getCreativeType() async {
    final value = await channel.invokeMethod('getCreativeType', <String, dynamic>{'instanceID': this.hashCode});
    return creativeTypeFrom(value);
  }

  void setCreativeType(ANCreativeType creativeType) async {
    int value = creativeTypeToInt(creativeType);
    await channel.invokeMethod('setCreativeType', <String, dynamic>{
      'instanceID': this.hashCode,
      'newValue': value,
    });
  }

  Future<String> getSkipText() async {
    return await channel.invokeMethod('getSkipText', <String, dynamic>{'instanceID': this.hashCode});
  }

  Future<void> setSkipText(String text) async {
    await channel.invokeMethod('setSkipText', <String, dynamic>{
      'instanceID': this.hashCode,
      'newValue': text,
    });
  }

  Future<bool> getAutoPlay() async {
    return await channel.invokeMethod('getAutoPlay', <String, dynamic>{'instanceID': this.hashCode});
  }

  Future<void> setAutoPlay(bool autoPlay) async {
    await channel.invokeMethod('setAutoPlay', <String, dynamic>{
      'instanceID': this.hashCode,
      'newValue': autoPlay,
    });
  }

  @override
  void onEvent(Object event) {
    if (disposed) {
      debugPrint('disposed');
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
      case 'adLoaded':
        if (adLoaded != null) adLoaded(this);
        return;
      case 'adOpened':
        if (adOpened != null) adOpened(this);
        return;
      case 'adClosed':
        if (adClosed != null) adClosed(this);
        return;
      case 'adClicked':
        if (adClicked != null) adClicked(this);
        return;
      case 'adUserWillLeaveApplication':
        if (adUserWillLeaveApplication != null) adUserWillLeaveApplication(this);
        return;
      case 'adError':
        if (adError != null) adError(ANInterstitialAdError(this, map['error']));
        return;
    }

    super.onEvent(event);
  }

  @override
  void onError(Object error) {
    super.onError(error);
  }
}

class ANInterstitialAdError {
  final ANInterstitialAd interstitialAd;
  final String error;

  ANInterstitialAdError(this.interstitialAd, this.error);

  @override
  String toString() {
    return 'AppnextInterstitialAdError: $error';
  }
}
