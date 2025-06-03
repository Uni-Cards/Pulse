import UIKit
import Flutter
import workmanager

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
    WorkmanagerPlugin.registerTask(withIdentifier: "mobile-events-sdk-bg-task")
    WorkmanagerPlugin.registerTask(withIdentifier: "pulse-events-sdk-bg-task")
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    
}
