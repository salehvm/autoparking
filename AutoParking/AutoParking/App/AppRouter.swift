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
        
//        self.addCar()
    }
    
    func checkStart() {
        if SessionManager.shared.hasLogin {
            self.main()
        } else {
            self.onboarding()
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
    
    func verify() {
        let viewController = VerifyViewController()
        self.window.rootViewController = VerifyConfigurator.configure(viewController)
        self.window.makeKeyAndVisible()
    }
    
    func onboarding() {
        let viewController = OnboardingViewController()
        OnboardingConfigurator.configure(viewController)
        self.window.rootViewController = MainNavigation(rootViewController: viewController)
        self.window.makeKeyAndVisible()
    }
}


extension AppRouter {
    func topMostViewController() -> UIViewController? {
        guard let rootViewController = window.rootViewController else {
            return nil
        }
        return topMostViewController(of: rootViewController)
    }

    private func topMostViewController(of viewController: UIViewController) -> UIViewController {
        if let presentedViewController = viewController.presentedViewController {
            return topMostViewController(of: presentedViewController)
        } else if let navigationController = viewController as? UINavigationController {
            return topMostViewController(of: navigationController.visibleViewController ?? viewController)
        } else if let tabBarController = viewController as? UITabBarController {
            return topMostViewController(of: tabBarController.selectedViewController ?? viewController)
        } else {
            return viewController
        }
    }
}




