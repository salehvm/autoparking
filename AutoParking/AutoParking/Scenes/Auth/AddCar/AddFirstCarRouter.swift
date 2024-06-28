//
//  AddFirstCarRouter.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

@objc protocol AddFirstCarRoutingLogic {
    
    //func routeToSomewhere()
}

protocol AddFirstCarDataPassing {
    var dataStore: AddFirstCarDataStore? { get }
}

final class AddFirstCarRouter: NSObject, AddFirstCarRoutingLogic, AddFirstCarDataPassing {
    
    weak var viewController: AddFirstCarViewController?
    var dataStore: AddFirstCarDataStore?
  
    
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

//    func navigateToSomewhere(source: AddFirstCarViewController, destination: SomewhereViewController) {
//        source.show(destination, sender: nil)
//    }

    
    // MARK: Passing data

//    func passDataToSomewhere(source: AddFirstCarDataStore, destination: inout SomewhereDataStore) {
//        destination.name = source.name
//    }
}
