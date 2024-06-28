//
//  AddFirstCarConfigurator.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

final class AddFirstCarConfigurator {
    
    @discardableResult
    static func configure(_ viewController: AddFirstCarViewController) -> AddFirstCarViewController {
        let view = AddFirstCarView()
        let interactor = AddFirstCarInteractor()
        let presenter = AddFirstCarPresenter()
        let router = AddFirstCarRouter()
        
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
