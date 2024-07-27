//
//  OnboardingRouter.swift
//  AutoParking
//
//  Created by Saleh Majidov on 27/07/2024.
//

import UIKit

@objc protocol OnboardingRoutingLogic {
    
    func routeToSignIn()
}

protocol OnboardingDataPassing {
    var dataStore: OnboardingDataStore? { get }
}

final class OnboardingRouter: NSObject, OnboardingRoutingLogic, OnboardingDataPassing {
    
    weak var viewController: OnboardingViewController?
    var dataStore: OnboardingDataStore?
  
    
    // MARK: Routing

    func routeToSignIn() {
        let destinationVC = SignInViewController()
        SignInConfigurator.configure(destinationVC)

//        var destinationDS = destinationVC.router!.dataStore!
//        passDataToSomewhere(source: dataStore!, destination: &destinationDS)

        navigateToSignIn(source: viewController!, destination: destinationVC)
    }

    
    // MARK: Navigation

    func navigateToSignIn(source: OnboardingViewController, destination: SignInViewController) {
        source.show(destination, sender: nil)
    }

    
    // MARK: Passing data

//    func passDataToSomewhere(source: OnboardingDataStore, destination: inout SomewhereDataStore) {
//        destination.name = source.name
//    }
}
