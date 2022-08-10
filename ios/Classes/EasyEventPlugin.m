#import "EasyEventPlugin.h"
#if __has_include(<easy_event/easy_event-Swift.h>)
#import <easy_event/easy_event-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "easy_event-Swift.h"
#endif

@implementation EasyEventPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftEasyEventPlugin registerWithRegistrar:registrar];
}
@end
