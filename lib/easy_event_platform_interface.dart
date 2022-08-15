import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'easy_event_color_rgb.dart';
import 'easy_event_method_channel.dart';

abstract class EasyEventPlatform extends PlatformInterface {
  /// Constructs a EasyEventPlatform.
  EasyEventPlatform() : super(token: _token);

  static final Object _token = Object();

  static EasyEventPlatform _instance = MethodChannelEasyEvent();

  /// The default instance of [EasyEventPlatform] to use.
  ///
  /// Defaults to [MethodChannelEasyEvent].
  static EasyEventPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [EasyEventPlatform] when
  /// they register themselves.
  static set instance(EasyEventPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> test() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> addEventCalendar(String title, ColorRGB colorRGB) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
