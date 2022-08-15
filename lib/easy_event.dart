
import 'package:easy_event/easy_event_color_rgb.dart';

import 'easy_event_platform_interface.dart';

class EasyEvent {
  Future<String?> getPlatformVersion() {
    return EasyEventPlatform.instance.getPlatformVersion();
  }

  Future<String?> test() {
    return EasyEventPlatform.instance.test();
  }

  Future<bool> addEventCalendar(String title, ColorRGB colorRGB) {
    return EasyEventPlatform.instance.addEventCalendar(title, colorRGB);
  }
}
