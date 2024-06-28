//
//  MyCarsConfigurator.swift
//  AutoParking
//
//  Created by Saleh Majidov on 26/06/2024.
//

import UIKit

final class MyCarsConfigurator {
    
    @discardableResult
    static func configure(_ viewController: MyCarsViewController) -> MyCarsViewController {
        let view = MyCarsView()
        let interactor = MyCarsInteractor()
        let presenter = MyCarsPresenter()
        let router = MyCarsRouter()
        
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
