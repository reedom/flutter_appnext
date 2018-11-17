import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:streams_channel/streams_channel.dart';

const MethodChannel _channel = const MethodChannel('com.reedom.flutter_appnext');
final StreamsChannel _eventChannel = StreamsChannel('com.reedom.flutter_appnext/event');

abstract class ANAppnextPlugin {
  bool _disposed = false;

  bool get disposed => _disposed;

  @override
  MethodChannel get channel => _channel;

  @override
  StreamsChannel get eventChannel => _eventChannel;

  ANAppnextPlugin() {
    final arg = <String, dynamic>{'instanceID': this.hashCode};
    eventChannel.receiveBroadcastStream(arg).listen(onEvent, onError: onError, onDone: onDone);
  }

  Future<void> dispose() async {
    if (!_disposed) {
      await channel.invokeMethod('dispose', <String, dynamic>{'instanceID': this.hashCode});
      _disposed = true;
    }
  }

  void onEvent(Object event) {}

  void onError(Object error) {
    debugPrint('receiveBroadcastStream.onError instanceID = $hashCode, error = $error}');
  }

  void onDone() {
    debugPrint('receiveBroadcastStream.onDone instanceID = $hashCode');
  }
}
