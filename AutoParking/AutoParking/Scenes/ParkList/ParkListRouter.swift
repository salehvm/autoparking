//
//  ParkListRouter.swift
//  AutoParking
//
//  Created by Saleh Majidov on 25/06/2024.
//

import UIKit

@objc protocol ParkListRoutingLogic {
    
    //func routeToSomewhere()
}

protocol ParkListDataPassing {
    var dataStore: ParkListDataStore? { get }
}

final class ParkListRouter: NSObject, ParkListRoutingLogic, ParkListDataPassing {
    
    weak var viewController: ParkListViewController?
    var dataStore: ParkListDataStore?
  
    
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

//    func navigateToSomewhere(source: ParkListViewController, destination: SomewhereViewController) {
//        source.show(destination, sender: nil)
//    }

    
    // MARK: Passing data

//    func passDataToSomewhere(source: ParkListDataStore, destination: inout SomewhereDataStore) {
//        destination.name = source.name
//    }
}
