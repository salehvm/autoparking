//
//  VerifyRouter.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

@objc protocol VerifyRoutingLogic {
    
    func routeToAddFirstCar()
}

protocol VerifyDataPassing {
    var dataStore: VerifyDataStore? { get }
}

final class VerifyRouter: NSObject, VerifyRoutingLogic, VerifyDataPassing {
    
    weak var viewController: VerifyViewController?
    var dataStore: VerifyDataStore?
  
    
    // MARK: Routing

    func routeToAddFirstCar() {
        let destinationVC = AddFirstCarViewController()
        AddFirstCarConfigurator.configure(destinationVC)

//        var destinationDS = destinationVC.router!.dataStore!
//        passDataToSomewhere(source: dataStore!, destination: &destinationDS)

        navigateToAddFirstCar(source: viewController!, destination: destinationVC)
    }

    
    // MARK: Navigation

    func navigateToAddFirstCar(source: VerifyViewController, destination: AddFirstCarViewController) {
        source.show(destination, sender: nil)
    }

    
    // MARK: Passing data

//    func passDataToSomewhere(source: VerifyDataStore, destination: inout SomewhereDataStore) {
//        destination.name = source.name
//    }
}
