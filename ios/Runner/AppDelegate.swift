import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  // override func application(
  //   _ application: UIApplication,
  //   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  // ) -> Bool {
  //   GeneratedPluginRegistrant.register(with: self)
  //   return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  // }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let anydeskChannel = FlutterMethodChannel(name: "com.stlghana.fcm_voip/anydesk",
                                              binaryMessenger: controller.binaryMessenger)

    anydeskChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if (call.method == "openAnyDesk") {
        if let url = URL(string: "anydesk://") {
          if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            result(nil)
          } else {
            result(FlutterError(code: "UNAVAILABLE",
                                message: "AnyDesk not installed",
                                details: nil))
          }
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
