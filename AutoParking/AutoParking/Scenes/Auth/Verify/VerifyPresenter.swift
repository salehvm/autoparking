//
//  VerifyPresenter.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

protocol VerifyPresentationLogic {
    
    func presentLoad(response: Verify.Load.Response)
    
    func presentCheckOTP(response: Verify.CheckOTP.Response)
}

final class VerifyPresenter: VerifyPresentationLogic {
   
    weak var viewController: VerifyDisplayLogic?
  
    
    // MARK: Presentation
  
    func presentLoad(response: Verify.Load.Response) {
        let viewModel = Verify.Load.ViewModel(phoneNumber: response.phoneNumber)
        viewController?.displayLoad(viewModel: viewModel)
    }
    
    func presentCheckOTP(response: Verify.CheckOTP.Response) {
        let viewModel = Verify.CheckOTP.ViewModel(success: response.success, errorMessage: response.message, status: response.status)
        viewController?.displayCheckOTP(viewModel: viewModel)
    }
}
