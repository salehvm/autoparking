//
//  AppRouter.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

final class AppRouter {
    let window: UIWindow
    
    init() {
        window = UIWindow(frame: UIScreen.main.bounds)
    }
    
    func start() {
        self.splash()

    }
    
    func checkStart() {
        if SessionManager.shared.hasLogin {
            self.main()
        }
        else {
            self.signIn()
        }
    }
    
    func splash() {
        let viewController = SplashViewController()
        self.window.rootViewController = SplashConfigurator.configure(viewController)
        self.window.makeKeyAndVisible()
    }

    func main() {
        let viewController = TabBarController()
        TabBarConfigurator.configure(viewController)
        self.window.rootViewController = viewController
        self.window.makeKeyAndVisible()
    }
    
    func signIn() {
        let viewController = SignInViewController()
        SignInConfigurator.configure(viewController)
        let navigation = MainNavigation(rootViewController: viewController)
        self.window.rootViewController = navigation
        self.window.makeKeyAndVisible()
    }
    
    func addCar() {
        let viewController = AddFirstCarViewController()
        self.window.rootViewController = AddFirstCarConfigurator.configure(viewController)
        self.window.makeKeyAndVisible()
    }
}



