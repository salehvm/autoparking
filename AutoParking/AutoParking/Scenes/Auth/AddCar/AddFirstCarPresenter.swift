//
//  AddFirstCarPresenter.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

protocol AddFirstCarPresentationLogic {
    
    func presentLoad(response: AddFirstCar.Load.Response)
    
    func presentGetCarlist(response: AddFirstCar.VehicleList.Response)
}

final class AddFirstCarPresenter: AddFirstCarPresentationLogic {
    
    weak var viewController: AddFirstCarDisplayLogic?
  
    
    // MARK: Presentation
  
    func presentLoad(response: AddFirstCar.Load.Response) {
        let viewModel = AddFirstCar.Load.ViewModel()
        viewController?.displayLoad(viewModel: viewModel)
    }
    
    func presentGetCarlist(response: AddFirstCar.VehicleList.Response) {
        let viewModel = AddFirstCar.VehicleList.ViewModel(data: response.data)
        viewController?.displayGetCarList(viewModel: viewModel)
    }
}
