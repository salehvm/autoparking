//
//  SplashRouter.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

@objc protocol SplashRoutingLogic {
    
    //func routeToSomewhere()
}

protocol SplashDataPassing {
    var dataStore: SplashDataStore? { get }
}

final class SplashRouter: NSObject, SplashRoutingLogic, SplashDataPassing {
    
    weak var viewController: SplashViewController?
    var dataStore: SplashDataStore?
  
    
    // MARK: Routing

//    func routeToSomewhere() {
//        let destinationVC = SomewhereViewController()
//        SomewhereConfigurator.configure(destinationVC)
//
//        var destinationDS = destinationVC.router!.dataStore!
//        passDataToSomewhere(source: dataStore!, destination: &destinationDS)
//
//        navigateToSomewhere(source: viewController!, destination: destinationVC)
//    }

    
    // MARK: Navigation

//    func navigateToSomewhere(source: SplashViewController, destination: SomewhereViewController) {
//        source.show(destination, sender: nil)
//    }

    
    // MARK: Passing data

//    func passDataToSomewhere(source: SplashDataStore, destination: inout SomewhereDataStore) {
//        destination.name = source.name
//    }
}
