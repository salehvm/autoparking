//
//  OnboardingConfigurator.swift
//  AutoParking
//
//  Created by Saleh Majidov on 27/07/2024.
//

import UIKit

final class OnboardingConfigurator {
    
    @discardableResult
    static func configure(_ viewController: OnboardingViewController) -> OnboardingViewController {
        let view = OnboardingView()
        let interactor = OnboardingInteractor()
        let presenter = OnboardingPresenter()
        let router = OnboardingRouter()
        
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
