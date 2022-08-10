import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'easy_event_platform_interface.dart';

/// An implementation of [EasyEventPlatform] that uses method channels.
class MethodChannelEasyEvent extends EasyEventPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('easy_event');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> test() async {
    return await methodChannel.invokeMethod<String>("test");
  }
}
