//
//  MyCarsPresenter.swift
//  AutoParking
//
//  Created by Saleh Majidov on 26/06/2024.
//

import UIKit

protocol MyCarsPresentationLogic {
    
    func presentLoad(response: MyCars.Load.Response)
    
    func presentGetCarlist(response: MyCars.VehicleList.Response)
}

final class MyCarsPresenter: MyCarsPresentationLogic {
    
    weak var viewController: MyCarsDisplayLogic?
  
    // MARK: Presentation
  
    func presentLoad(response: MyCars.Load.Response) {
        let viewModel = MyCars.Load.ViewModel()
        viewController?.displayLoad(viewModel: viewModel)
    }
    
    func presentGetCarlist(response: MyCars.VehicleList.Response) {
        let viewModel = MyCars.VehicleList.ViewModel(data: response.data)
        viewController?.displayGetCarList(viewModel: viewModel)
    }
}
