//
//  AddFirstCarRouter.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

@objc protocol AddFirstCarRoutingLogic {
    
    func routeToPermissionScreen()
}

protocol AddFirstCarDataPassing {
    var dataStore: AddFirstCarDataStore? { get }
}

final class AddFirstCarRouter: NSObject, AddFirstCarRoutingLogic, AddFirstCarDataPassing {
    
    weak var viewController: AddFirstCarViewController?
    var dataStore: AddFirstCarDataStore?
  
    
    // MARK: Routing

    func routeToPermissionScreen() {
        let destinationVC = PermissionAuthViewController()
        PermissionAuthConfigurator.configure(destinationVC)

//        var destinationDS = destinationVC.router!.dataStore!
//        passDataToSomewhere(source: dataStore!, destination: &destinationDS)

        navigateToPermission(source: viewController!, destination: destinationVC)
    }

    
    // MARK: Navigation

    func navigateToPermission(source: AddFirstCarViewController, destination: PermissionAuthViewController) {
        source.show(destination, sender: nil)
    }

    
    // MARK: Passing data

//    func passDataToSomewhere(source: AddFirstCarDataStore, destination: inout SomewhereDataStore) {
//        destination.name = source.name
//    }
}
