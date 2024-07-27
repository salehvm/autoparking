//
//  PermissionAuthConfigurator.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/07/2024.
//

import UIKit

final class PermissionAuthConfigurator {
    
    @discardableResult
    static func configure(_ viewController: PermissionAuthViewController) -> PermissionAuthViewController {
        let view = PermissionAuthView()
        let interactor = PermissionAuthInteractor()
        let presenter = PermissionAuthPresenter()
        let router = PermissionAuthRouter()
        
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
