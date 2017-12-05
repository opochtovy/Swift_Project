//
//  AppDelegate.swift
//  Kubazar
//
//  Created by Mobexs on 11/3/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Firebase
import UserNotifications
import IQKeyboardManagerSwift
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    let client = Client()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        let controller = RootVC(client: self.client)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = controller;
        self.window?.makeKeyAndVisible();
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().toolbarDoneBarButtonItemText = NSLocalizedString(ButtonTitles.doneButtonTitle, comment: "Done Button Title")
        
        Fabric.with([Crashlytics.self])
        
        // Facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        FBSDKLoginManager.renewSystemCredentials { (result:ACAccountCredentialRenewResult, error:Error!) -> Void in
            //
        }
        
        return true
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let isFacebookURL = url.scheme != nil && url.scheme!.hasPrefix("fb\(FBSDKSettings.appID())") && url.host == "authorize"
        if isFacebookURL {
            return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //MARK: - Remote Notifications
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let token = Messaging.messaging().fcmToken
        self.client.authenticator.fcmToken = token ?? ""
        print("FCM token: \(token ?? "")")
        
        // Pass device token to auth.
        
        //At development time we use .sandbox
        Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)
        
        // At time of production it will be set to .prod
//        Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.prod)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if (Auth.auth().canHandleNotification(userInfo)){
            print(userInfo)
            return
        }
        
        // Print message ID.
        let gcmMessageIDKey = "gcm.message_id"
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    //MARK: - MessagingDelegate
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        
        print("Firebase registration token: \(fcmToken)")
        
        let token = Messaging.messaging().fcmToken
        self.client.authenticator.fcmToken = token ?? ""
        print("FCM token: \(token ?? "")")
    }
}

