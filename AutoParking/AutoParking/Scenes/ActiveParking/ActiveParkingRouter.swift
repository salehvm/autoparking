//
//  ActiveParkingRouter.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

@objc protocol ActiveParkingRoutingLogic {
    
    //func routeToSomewhere()
}

protocol ActiveParkingDataPassing {
    var dataStore: ActiveParkingDataStore? { get }
}

final class ActiveParkingRouter: NSObject, ActiveParkingRoutingLogic, ActiveParkingDataPassing {
    
    weak var viewController: ActiveParkingViewController?
    var dataStore: ActiveParkingDataStore?
  
    
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

//    func navigateToSomewhere(source: ActiveParkingViewController, destination: SomewhereViewController) {
//        source.show(destination, sender: nil)
//    }

    
    // MARK: Passing data

//    func passDataToSomewhere(source: ActiveParkingDataStore, destination: inout SomewhereDataStore) {
//        destination.name = source.name
//    }
}
