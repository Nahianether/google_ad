import Flutter
import UIKit
import GoogleMobileAds

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if let registry = self.registrar(forPlugin: "FLTGoogleMobileAdsPlugin") {
      FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
        registry.messenger(),
        factoryId: "listTile",
        nativeAdFactory: ListTileNativeAdFactory()
      )
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
