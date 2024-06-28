//
//  ParkListPresenter.swift
//  AutoParking
//
//  Created by Saleh Majidov on 25/06/2024.
//

import UIKit

protocol ParkListPresentationLogic {
    
    func presentLoad(response: ParkList.Load.Response)
    
    func presentGetParkList(response: ParkList.ParkList.Response)
}

final class ParkListPresenter: ParkListPresentationLogic {
    
    weak var viewController: ParkListDisplayLogic?
  
    
    // MARK: Presentation
  
    func presentLoad(response: ParkList.Load.Response) {
        let viewModel = ParkList.Load.ViewModel()
        viewController?.displayLoad(viewModel: viewModel)
    }
    
    func presentGetParkList(response: ParkList.ParkList.Response) {
        let viewModel = ParkList.ParkList.ViewModel(data: response.data)
        viewController?.displaygetParkList(viewModel: viewModel)
    }
}
