//
//  PermissionAuthPresenter.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/07/2024.
//

import UIKit

protocol PermissionAuthPresentationLogic {
    
    func presentLoad(response: PermissionAuth.Load.Response)
}

final class PermissionAuthPresenter: PermissionAuthPresentationLogic {
    
    weak var viewController: PermissionAuthDisplayLogic?
  
    
    // MARK: Presentation
  
    func presentLoad(response: PermissionAuth.Load.Response) {
        let viewModel = PermissionAuth.Load.ViewModel()
        viewController?.displayLoad(viewModel: viewModel)
    }
}
