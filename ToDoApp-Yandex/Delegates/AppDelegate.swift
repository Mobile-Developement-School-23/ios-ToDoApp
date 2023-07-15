import UIKit
//import CocoaLumberjack
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var fileCache: FileCache?
    let networkingService = DefaultNetworkingService()
    override init() {
        fileCache = FileCache()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
//        DDLog.add(DDOSLogger.sharedInstance)
//        let fileLogger: DDFileLogger = DDFileLogger()
//        fileLogger.rollingFrequency = 0
//        fileLogger.maximumFileSize = 1 * 1024 * 1024
//        fileLogger.logFileManager.maximumNumberOfLogFiles = 2
//        DDLog.add(fileLogger)
        
        let mainViewController = MainViewController()
        mainViewController.title = "Task"
        
        let navigationController = UINavigationController(rootViewController: mainViewController)
        
        // Assign the navigationController as the rootViewController of the window
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        guard let mainViewController = window?.rootViewController as? MainViewController else {
            return
        }

        mainViewController.fetchToDoItems()
    }
}
