//
//  AddFirstCarInteractor.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

protocol AddFirstCarBusinessLogic {
    
    func load(request: AddFirstCar.Load.Request)
    
    func getCarlist(request: AddFirstCar.VehicleList.Request)
}

protocol AddFirstCarDataStore {
    
    //var name: String { get set }
}

final class AddFirstCarInteractor: AddFirstCarBusinessLogic, AddFirstCarDataStore {
    
    var presenter: AddFirstCarPresentationLogic?
    lazy var worker: AddFirstCarWorkingLogic = AddFirstCarWorker()
    //var name: String = ""
  
    
    // MARK: Business Logic
  
    func load(request: AddFirstCar.Load.Request) {
        let response = AddFirstCar.Load.Response()
        presenter?.presentLoad(response: response)
    }
    
    func getCarlist(request: AddFirstCar.VehicleList.Request) {
        let token = SessionManager.shared.accessToken ?? ""
        self.worker.getCarList(token: token) { [weak self] data in
            guard let self = self else { return }
            
            if let data = data {
                let response = AddFirstCar.VehicleList.Response(data: data.data)
                presenter?.presentGetCarlist(response: response)
            }
        }
    }
}
