//
//  SignInRouter.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

@objc protocol SignInRoutingLogic {
    
    func routeToVerify()
}

protocol SignInDataPassing {
    var dataStore: SignInDataStore? { get }
}

final class SignInRouter: NSObject, SignInRoutingLogic, SignInDataPassing {
    
    weak var viewController: SignInViewController?
    var dataStore: SignInDataStore?
  
    // MARK: Routing

    func routeToVerify() {
        let destinationVC = VerifyViewController()
        VerifyConfigurator.configure(destinationVC)

        var destinationDS = destinationVC.router!.dataStore!
        passDataToVerify(source: dataStore!, destination: &destinationDS)

        navigateToVerify(source: viewController!, destination: destinationVC)
    }
    
    // MARK: Navigation

    func navigateToVerify(source: SignInViewController, destination: VerifyViewController) {
        source.show(destination, sender: nil)
    }
    
    // MARK: Passing data

    func passDataToVerify(source: SignInDataStore, destination: inout VerifyDataStore) {
        destination.hash = source.hash
        destination.phoneNumber = source.phoneNumber
    }
}
