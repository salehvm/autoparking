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

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        FirebaseApp.configure()
        AppManager.shared.start()
//        App.router.start()
        App.router.start()
        LocationManager.shared.requestPermissions()
        
        
           
        return true
    }
    
    
    
    
}
