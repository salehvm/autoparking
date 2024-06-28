//
//  ActiveParkingInteractor.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

protocol ActiveParkingBusinessLogic {
    
    func load(request: ActiveParking.Load.Request)
    
    func bookedList(request: ActiveParking.BookedList.Request)
}

protocol ActiveParkingDataStore {
    
    //var name: String { get set }
}

final class ActiveParkingInteractor: ActiveParkingBusinessLogic, ActiveParkingDataStore {
    
    var presenter: ActiveParkingPresentationLogic?
    lazy var worker: ActiveParkingWorkingLogic = ActiveParkingWorker()
    //var name: String = ""
  
    
    // MARK: Business Logic
  
    func load(request: ActiveParking.Load.Request) {
        let response = ActiveParking.Load.Response()
        presenter?.presentLoad(response: response)
    }
    
    func bookedList(request: ActiveParking.BookedList.Request) {
        let token = SessionManager.shared.accessToken ?? ""
        
        self.worker.getBookedList(token: token) { [weak self] data, message in
            guard let self = self else { return }
            if let data = data {
                let response = ActiveParking.BookedList.Response(data: data.data ?? [])
                presenter?.presentBookedList(response: response)
            }
        }
    }
}
