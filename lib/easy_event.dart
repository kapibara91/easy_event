
import 'easy_event_platform_interface.dart';

class EasyEvent {
  Future<String?> getPlatformVersion() {
    return EasyEventPlatform.instance.getPlatformVersion();
  }

  Future<String?> test() {
    return EasyEventPlatform.instance.test();
  }
}
