import 'dart:async';

import 'package:flutter/services.dart';
import 'package:streams_channel/streams_channel.dart';

const MethodChannel _channel = const MethodChannel('com.reedom.flutter_appnext');

abstract class ANAppnextPlugin {
  final StreamsChannel _eventChannel = StreamsChannel('com.reedom.flutter_appnext/event');

  bool _disposed = false;
  bool get disposed => _disposed;

  @override
  MethodChannel get channel => _channel;

  @override
  StreamsChannel get eventChannel => _eventChannel;

  ANAppnextPlugin() {
    print('ANAppnextPlugin, instanceID = $hashCode, $this');
    final arg = <String, dynamic>{'instanceID': this.hashCode};
    eventChannel.receiveBroadcastStream(arg).listen(onEvent, onError: onError, onDone: onDone);
  }

  Future<void> dispose() async {
    if (!_disposed) {
      _disposed = true;
      await channel.invokeMethod('dispose', <String, dynamic>{'instanceID': this.hashCode});
    }
  }

  void onEvent(Object event) {}

  void onError(Object error) {
    print('receiveBroadcastStream.onError instanceID = $hashCode, error = $error}');
  }

  void onDone() {
    print('receiveBroadcastStream.onDone instanceID = $hashCode');
  }
}
