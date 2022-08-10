import Flutter
import UIKit

public class SwiftEasyEventPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "easy_event", binaryMessenger: registrar.messenger())
    let instance = SwiftEasyEventPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      
      if call.method == "test" {
          result("message from iOS")
      } else {
          result("iOS " + UIDevice.current.systemVersion)
      }
  }
}
