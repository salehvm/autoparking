//
//  VerifyConfigurator.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

final class VerifyConfigurator {
    
    @discardableResult
    static func configure(_ viewController: VerifyViewController) -> VerifyViewController {
        let view = VerifyView()
        let interactor = VerifyInteractor()
        let presenter = VerifyPresenter()
        let router = VerifyRouter()
        
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
