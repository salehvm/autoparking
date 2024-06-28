//
//  ParkListConfigurator.swift
//  AutoParking
//
//  Created by Saleh Majidov on 25/06/2024.
//

import UIKit

final class ParkListConfigurator {
    
    @discardableResult
    static func configure(_ viewController: ParkListViewController) -> ParkListViewController {
        let view = ParkListView()
        let interactor = ParkListInteractor()
        let presenter = ParkListPresenter()
        let router = ParkListRouter()
        
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
