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
        
        worker.getBookedList(token: token) { response, error in
            if let response = response {
                print("Successfully retrieved booking list")
                let response = ActiveParking.BookedList.Response(data: response.data ?? [])
                self.presenter?.presentBookedList(response: response)
            } else if let error = error {
                print("Error: \(error)")
            }
        }
    }
}
