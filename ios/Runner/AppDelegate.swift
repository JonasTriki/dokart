import UIKit
import Flutter
import GoogleMaps
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    
    // Read API key for Google maps
    if let path = Bundle.main.path(forResource: "Config", ofType: "plist") {
        if let config = NSDictionary(contentsOfFile: path) as? [String: Any] {
            let apiKey = config["GOOGLE_CREDENTIALS_API_KEY"] as! String
            GMSServices.provideAPIKey(apiKey)
        }
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
