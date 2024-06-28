//
//  ActiveParkingConfigurator.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

final class ActiveParkingConfigurator {
    
    @discardableResult
    static func configure(_ viewController: ActiveParkingViewController) -> ActiveParkingViewController {
        let view = ActiveParkingView()
        let interactor = ActiveParkingInteractor()
        let presenter = ActiveParkingPresenter()
        let router = ActiveParkingRouter()
        
        viewController.mainView = view
        viewController.interactor = interactor
        viewController.router = router
        
        interactor.presenter = presenter
        
        presenter.viewController = viewController
        
        router.viewController = viewController
        router.dataStore = interactor
        
        return viewController
    }
}
