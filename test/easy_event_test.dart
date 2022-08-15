import 'package:easy_event/easy_event_color_rgb.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_event/easy_event.dart';
import 'package:easy_event/easy_event_platform_interface.dart';
import 'package:easy_event/easy_event_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockEasyEventPlatform 
    with MockPlatformInterfaceMixin
    implements EasyEventPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> test() => Future.value("123");

  @override
  Future<bool> addEventCalendar(String title, ColorRGB colorRGB) {
    // TODO: implement addEventCalendar
    throw UnimplementedError();
  }
}

void main() {
  final EasyEventPlatform initialPlatform = EasyEventPlatform.instance;

  test('$MethodChannelEasyEvent is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelEasyEvent>());
  });

  test('getPlatformVersion', () async {
    EasyEvent easyEventPlugin = EasyEvent();
    MockEasyEventPlatform fakePlatform = MockEasyEventPlatform();
    EasyEventPlatform.instance = fakePlatform;
  
    expect(await easyEventPlugin.getPlatformVersion(), '42');
  });
}
