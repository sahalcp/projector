import UIKit
import Flutter
import FBSDKCoreKit
import FirebaseCore

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
   // lazy var flutterEngine = FlutterEngine(name: "add to app Flutter sample")
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      FirebaseApp.configure()
    //flutterEngine.run();
    
      
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let CHANNEL = FlutterMethodChannel(name:"flutter.native/helper",binaryMessenger: controller as! FlutterBinaryMessenger)
    
    CHANNEL.setMethodCallHandler{[unowned self] (methodCall,result) in
        if(methodCall.method == "flutterToIosNative"){
            
           // guard let args = methodCall.arguments as? [String : String] else {return}
            //let videoUrl = args["videoUrl"]!
           // let thumbnailPreview = args["thumbnailPreview"]!
           // print(videoUrl)
            
            self.window = UIWindow(frame: UIScreen.main.bounds)
           // let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
//            let viewController = storyBoard.instantiateViewController(withIdentifier: "CustomVideoViewController") as! CustomVideoViewController
            
            
           // viewController.videoUrl = videoUrl
           // viewController.thumnailPreview = thumbnailPreview
            
           // self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
            result("HI from ios swift")
        }
    }
    
      GeneratedPluginRegistrant.register(with: self)
    //GeneratedPluginRegistrant.register(with: self.flutterEngine)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func application(
           _ app: UIApplication,
           open url: URL,
           options: [UIApplication.OpenURLOptionsKey : Any] = [:]
       ) -> Bool {
           ApplicationDelegate.shared.application(
               app,
               open: url,
               sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
               annotation: options[UIApplication.OpenURLOptionsKey.annotation]
           )
       }
   }
    
