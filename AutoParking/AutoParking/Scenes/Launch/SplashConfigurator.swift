//
//  SplashConfigurator.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

final class SplashConfigurator {
    
    @discardableResult
    static func configure(_ viewController: SplashViewController) -> SplashViewController {
        let view = SplashView()
        let interactor = SplashInteractor()
        let presenter = SplashPresenter()
        let router = SplashRouter()
        
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
