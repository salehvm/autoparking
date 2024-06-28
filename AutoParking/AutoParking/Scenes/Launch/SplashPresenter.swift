//
//  SplashPresenter.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

protocol SplashPresentationLogic {
    
    func presentLoad(response: Splash.Load.Response)
}

final class SplashPresenter: SplashPresentationLogic {
    
    weak var viewController: SplashDisplayLogic?
  
    
    // MARK: Presentation
  
    func presentLoad(response: Splash.Load.Response) {
        let viewModel = Splash.Load.ViewModel()
        viewController?.displayLoad(viewModel: viewModel)
    }
}
