//
//  ProfilePresenter.swift
//  AutoParking
//
//  Created by Saleh Majidov on 25/06/2024.
//

import UIKit

protocol ProfilePresentationLogic {
    
    func presentLoad(response: Profile.Load.Response)
    
    func presentLogout(response: Profile.Logout.Response)
    
    func presentGetPaymentList(response: Profile.PaymentCardList.Response)
}

final class ProfilePresenter: ProfilePresentationLogic {
    
    weak var viewController: ProfileDisplayLogic?
  
    
    // MARK: Presentation
  
    func presentLoad(response: Profile.Load.Response) {
        let viewModel = Profile.Load.ViewModel()
        viewController?.displayLoad(viewModel: viewModel)
    }
    
    func presentLogout(response: Profile.Logout.Response) {
        let viewModel = Profile.Logout.ViewModel(check: response.check)
        viewController?.displayLogout(viewModel: viewModel)
    }
    
    func presentGetPaymentList(response: Profile.PaymentCardList.Response) {
        let viewModel = Profile.PaymentCardList.ViewModel(data: response.data)
        viewController?.displayPaymentList(viewModel: viewModel)
    }
}
