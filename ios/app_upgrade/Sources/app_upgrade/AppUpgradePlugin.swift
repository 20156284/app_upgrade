import Flutter
import UIKit

public class AppUpgradePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "app_upgrade", binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(AppUpgradePlugin(), channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getAppInfo":
      let info = Bundle.main.infoDictionary
      result([
        "packageName": info?["CFBundleIdentifier"] as? String,
        "versionName": info?["CFBundleShortVersionString"] as? String,
        "versionCode": "0",
      ])
    case "toAppStore":
      let id = (call.arguments as? [String: String])?["id"] ?? ""
      if let url = URL(string: "itms-apps://itunes.apple.com/app/\(id)") {
        UIApplication.shared.open(url)
      }
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
