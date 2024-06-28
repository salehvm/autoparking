//
//  MyCarsRouter.swift
//  AutoParking
//
//  Created by Saleh Majidov on 26/06/2024.
//

import UIKit

@objc protocol MyCarsRoutingLogic {
    
    //func routeToSomewhere()
}

protocol MyCarsDataPassing {
    var dataStore: MyCarsDataStore? { get }
}

final class MyCarsRouter: NSObject, MyCarsRoutingLogic, MyCarsDataPassing {
    
    weak var viewController: MyCarsViewController?
    var dataStore: MyCarsDataStore?
  
    
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

//    func navigateToSomewhere(source: MyCarsViewController, destination: SomewhereViewController) {
//        source.show(destination, sender: nil)
//    }

    
    // MARK: Passing data

//    func passDataToSomewhere(source: MyCarsDataStore, destination: inout SomewhereDataStore) {
//        destination.name = source.name
//    }
}
