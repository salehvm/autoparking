//
//  ActiveParkingPresenter.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

protocol ActiveParkingPresentationLogic {
    
    func presentLoad(response: ActiveParking.Load.Response)
    
    func presentBookedList(response: ActiveParking.BookedList.Response)
}

final class ActiveParkingPresenter: ActiveParkingPresentationLogic {
    
    weak var viewController: ActiveParkingDisplayLogic?
  
    
    // MARK: Presentation
  
    func presentLoad(response: ActiveParking.Load.Response) {
        let viewModel = ActiveParking.Load.ViewModel()
        viewController?.displayLoad(viewModel: viewModel)
    }
    
    func presentBookedList(response: ActiveParking.BookedList.Response) {
        let viewModel = ActiveParking.BookedList.ViewModel(data: response.data)
        viewController?.displayBookingList(viewModel: viewModel)
    }
}
