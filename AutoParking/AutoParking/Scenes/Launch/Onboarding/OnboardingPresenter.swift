//
//  OnboardingPresenter.swift
//  AutoParking
//
//  Created by Saleh Majidov on 27/07/2024.
//

import UIKit

protocol OnboardingPresentationLogic {
    
    func presentLoad(response: Onboarding.Load.Response)
}

final class OnboardingPresenter: OnboardingPresentationLogic {
    
    weak var viewController: OnboardingDisplayLogic?
  
    
    // MARK: Presentation
  
    func presentLoad(response: Onboarding.Load.Response) {
        let viewModel = Onboarding.Load.ViewModel()
        viewController?.displayLoad(viewModel: viewModel)
    }
}
