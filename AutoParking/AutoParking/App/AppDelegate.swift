//
//  AppDelegate.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import UserNotifications
//import FirebaseAnalytics

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    let router = AppRouter()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        // Enable Firebase Analytics debug logging
//        Analytics.setAnalyticsCollectionEnabled(true)
//        Analytics.setUserProperty("debug_mode", forName: "mode")
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
            if success {
                print("Notification permission granted.")
            } else if let error = error {
                print("Failed to request notification permission: \(error)")
            }
        }
        
        application.registerForRemoteNotifications()
        
        router.start()
        
        LocationManager.shared.requestPermissions()
        return true
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { token, error in
            if let token = token {
                print("FCM token: \(token)")
            } else if let error = error {
                print("Failed to fetch FCM token: \(error)")
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Received remote notification: \(userInfo)")
        completionHandler(.newData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .list, .sound, .badge])
        } else {
            completionHandler([.alert, .sound, .badge])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("User responded to notification: \(response.notification.request.content.userInfo)")
        
        let userInfo = response.notification.request.content.userInfo
        
        guard let parkId = userInfo["parkId"] as? String else {
            print("Park ID not found in userInfo")
            completionHandler()
            return
        }

        if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            print("Default action identifier matched")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if let topViewController = self.router.topMostViewController() {
                    print("Top view controller: \(topViewController)")
                    let alertController = UIAlertController(title: "Confirm Parking", message: "Do you want us to park for you?", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                        AudioPortManager.shared.startBook(selectedCardId: AudioPortManager.shared.activeCar?.id ?? "", parkId: parkId)
                    }))
                    alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                    
                    DispatchQueue.main.async {
                        print("Presenting alert controller")
                        topViewController.present(alertController, animated: true, completion: nil)
                    }
                } else {
                    print("Top view controller is nil")
                }
            }
        } else {
            print("Action identifier does not match default")
        }

        completionHandler()
    }
}
