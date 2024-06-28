//
//  SignInConfigurator.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

final class SignInConfigurator {
    
    @discardableResult
    static func configure(_ viewController: SignInViewController) -> SignInViewController {
        let view = SignInView()
        let interactor = SignInInteractor()
        let presenter = SignInPresenter()
        let router = SignInRouter()
        
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
