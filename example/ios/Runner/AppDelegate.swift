import Flutter
import UIKit
import Foundation
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let keyPath = Bundle.main.path(forResource: "MAPS_API_KEY", ofType: "txt")!
    let mapKey = try! String(contentsOfFile: keyPath)
    GMSServices.provideAPIKey(mapKey)
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
