//
//  AppDelegate.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        AppManager.shared.start()
//        App.router.start()
        App.router.start()
        LocationManager.shared.requestPermissions()
        
        
           
        return true
    }
    
    
    
    
}
