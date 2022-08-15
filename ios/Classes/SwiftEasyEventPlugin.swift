import Flutter
import UIKit
import EventKit

public class SwiftEasyEventPlugin: NSObject, FlutterPlugin {
    
    private let eventStore = EKEventStore.init()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "easy_event", binaryMessenger: registrar.messenger())
        let instance = SwiftEasyEventPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

        if call.method == "test" {
            result("message from iOS")
        } else if call.method == "addEventCalendar" {
            if let args = call.arguments as? Dictionary<String, Any> {
                guard let title = args["title"] as? String else {
                    let error = FlutterError.init(code: "-2", message: "arguments title is null", details: "arguments is \(args)")
                    result(error)
                    return
                }
                guard let colorRGB = args["colorRGB"] as? Dictionary<String, Int> else {
                    let error = FlutterError.init(code: "-3", message: "arguments colorRGB is not Correct #1", details: "arguments is \(args)")
                    result(error)
                    return
                }
                guard let red = colorRGB["red"], let green = colorRGB["green"], let blue = colorRGB["blue"] else {
                    let error = FlutterError.init(code: "-4", message: "arguments colorRGB is not Correct #2", details: "red is \(colorRGB["red"] ?? -999) green is \(colorRGB["green"] ?? -999) blue is \(colorRGB["blue"] ?? -999)")
                    result(error)
                    return
                }
                guard red >= 0 || red <= 255, green >= 0 || green <= 255, blue >= 0 || blue <= 255 else {
                    let error = FlutterError.init(code: "-5", message: "arguments colorRGB is not Correct #3", details: "red is \(colorRGB["red"] ?? -999) green is \(colorRGB["green"] ?? -999) blue is \(colorRGB["blue"] ?? -999)")
                    result(error)
                    return
                }
                addEventCalendar(title: title, color: UIColor.init(red: Double(red)/255, green: Double(green)/255, blue: Double(blue)/255, alpha: 1).cgColor, result: result)

            } else {
                let error = FlutterError.init(code: "-1", message: "arguments is not correct", details: "arguments is \(call.arguments ?? "null")")
                result(error)
            }
        } else {
            result("iOS " + UIDevice.current.systemVersion)
        }
    }
    
    private func addEventCalendar(title: String, color: CGColor, result: @escaping FlutterResult) {
        
        eventStore.requestAccess(to: EKEntityType.event) { granted, error in
            if !granted {
                let flutterError = FlutterError.init(code: "no EventCalendar permission", message: nil, details: error)
                result(flutterError)
            } else {
                
                var isCreated = false
                
                for calendar in self.eventStore.calendars(for: .event) {
                    if calendar.title == title {
                        isCreated = true
                        break
                    }
                }
                
                if !isCreated {
                    let calendar = EKCalendar.init(for: EKEntityType.event, eventStore: self.eventStore)
                    for source in self.eventStore.sources {
                        if source.sourceType == .local {
                            calendar.source = source
                            break
                        }
                    }
                    calendar.title = title
                    calendar.cgColor = color
                    try! self.eventStore.saveCalendar(calendar, commit: true)
                    
                }
                result(true)
            }
        }
    }
}
