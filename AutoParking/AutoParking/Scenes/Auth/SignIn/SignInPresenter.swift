//
//  SignInPresenter.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

protocol SignInPresentationLogic {
    
    func presentLoad(response: SignIn.Load.Response)
    
    func presentSign(response: SignIn.Sign.Response)
}

final class SignInPresenter: SignInPresentationLogic {
    
    weak var viewController: SignInDisplayLogic?
  
    
    // MARK: Presentation
  
    func presentLoad(response: SignIn.Load.Response) {
        let viewModel = SignIn.Load.ViewModel()
        viewController?.displayLoad(viewModel: viewModel)
    }
    
    func presentSign(response: SignIn.Sign.Response) {
        let viewModel = SignIn.Sign.ViewModel()
        viewController?.displaySign(viewModel: viewModel)
    }
}
