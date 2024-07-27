//
//  PermissionAuthRouter.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/07/2024.
//

import UIKit

@objc protocol PermissionAuthRoutingLogic {
    
    //func routeToSomewhere()
}

protocol PermissionAuthDataPassing {
    var dataStore: PermissionAuthDataStore? { get }
}

final class PermissionAuthRouter: NSObject, PermissionAuthRoutingLogic, PermissionAuthDataPassing {
    
    weak var viewController: PermissionAuthViewController?
    var dataStore: PermissionAuthDataStore?
  
    
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

//    func navigateToSomewhere(source: PermissionAuthViewController, destination: SomewhereViewController) {
//        source.show(destination, sender: nil)
//    }

    
    // MARK: Passing data

//    func passDataToSomewhere(source: PermissionAuthDataStore, destination: inout SomewhereDataStore) {
//        destination.name = source.name
//    }
}
