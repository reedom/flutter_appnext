import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_appnext/src/types.dart';

class ANAdConfiguration {
  String categories;
  String postback;
  String buttonColor;
  ANPreferredOrientation preferredOrientation;
  bool clickInApp;

  ANAdConfiguration({
    this.categories,
    this.postback,
    this.buttonColor,
    this.preferredOrientation,
    this.clickInApp = false,
  });
}

abstract class ANAd {
  MethodChannel get channel;
  EventChannel get eventChannel;
  String get initMethod;

  bool _disposed = false;
  bool get disposed => _disposed;

  ANAd({String placementID, ANAdConfiguration adConfiguration}) {
    eventChannel.receiveBroadcastStream().listen(onEvent, onError: onError);

    channel.invokeMethod(initMethod, <String, dynamic>{
      'instanceID': this.hashCode,
      'placementID': placementID,
      'categories': adConfiguration != null ? adConfiguration.categories : null,
      'postback': adConfiguration != null ? adConfiguration.postback : null,
      'buttonColor': adConfiguration != null ? adConfiguration.buttonColor : null,
      'preferredOrientation':
          adConfiguration != null ? preferredOrientationToString(adConfiguration.preferredOrientation) : null,
      'clickInApp': adConfiguration != null ? adConfiguration.clickInApp : null,
    });
  }

  Future<void> dispose() async {
    if (!_disposed) {
      _disposed = true;
      await channel.invokeMethod('dispose', <String, dynamic>{'instanceID': this.hashCode});
    }
  }

  Future<String> get placementID async {
    return channel.invokeMethod('placementID', <String, dynamic>{'instanceID': this.hashCode});
  }

  set placementID(value) {
    channel.invokeMethod('setPlacementID', <String, dynamic>{
      'instanceID': this.hashCode,
      'placementID': value,
    });
  }

  Future<ANAdConfiguration> get adConfiguration async {
    final Map<String, dynamic> value =
        await channel.invokeMethod('adConfiguration', <String, dynamic>{'instanceID': this.hashCode});
    ANAdConfiguration adConfiguration;
    adConfiguration.categories = value['categories'];
    adConfiguration.postback = value['postback'];
    adConfiguration.buttonColor = value['buttonColor'];
    adConfiguration.preferredOrientation = preferredOrientationFrom(value['preferredOrientation']);
    adConfiguration.clickInApp = value['clickInApp'];
    return adConfiguration;
  }

  Future<bool> get adIsLoaded async {
    return channel.invokeMethod('adIsLoaded', <String, dynamic>{'instanceID': this.hashCode});
  }

  Future<void> loadAd() async {
    await channel.invokeMethod('loadAd', <String, dynamic>{'instanceID': this.hashCode});
  }

  Future<void> showAd() async {
    await channel.invokeMethod('showAd', <String, dynamic>{'instanceID': this.hashCode});
  }

  Future<void> setCategories(List<String> newValue) async {
    await channel.invokeMethod('setCategories', <String, dynamic>{
      'instanceID': this.hashCode,
      'newValue': newValue.join('%20'),
    });
  }

  Future<String> getCategories() async {
    return await channel.invokeMethod('getCategories', <String, dynamic>{'instanceID': this.hashCode});
  }

  Future<void> setPostback(String newValue) async {
    await channel.invokeMethod('setPostback', <String, dynamic>{
      'instanceID': this.hashCode,
      'newValue': newValue,
    });
  }

  Future<String> getPostback() async {
    return await channel.invokeMethod('getPostback', <String, dynamic>{'instanceID': this.hashCode});
  }

  Future<String> getButtonText() async {
    return await channel.invokeMethod('getButtonText', <String, dynamic>{'instanceID': this.hashCode});
  }

  Future<void> setButtonColor(String newValue) async {
    await channel.invokeMethod('setButtonColor', <String, dynamic>{
      'instanceID': this.hashCode,
      'newValue': newValue,
    });
  }

  Future<String> getButtonColor() async {
    return await channel.invokeMethod('getButtonColor', <String, dynamic>{'instanceID': this.hashCode});
  }

  Future<void> setPreferredOrientation(ANPreferredOrientation newValue) async {
    return channel.invokeMethod('setPreferredOrientation', <String, dynamic>{
      'instanceID': this.hashCode,
      'newValue': preferredOrientationToString(newValue),
    });
  }

  Future<ANPreferredOrientation> getPreferredOrientation() async {
    final value = await channel.invokeMethod('getPreferredOrientation', <String, dynamic>{'instanceID': this.hashCode});
    return preferredOrientationFrom(value);
  }

  Future<void> setClickInApp(bool newValue) async {
    return channel.invokeMethod('setClickInApp', <String, dynamic>{
      'instanceID': this.hashCode,
      'newValue': newValue,
    });
  }

  void onEvent(Object event) {}

  void onError(Object error) {}
}
