//
//  MyCarsInteractor.swift
//  AutoParking
//
//  Created by Saleh Majidov on 26/06/2024.
//

import UIKit

protocol MyCarsBusinessLogic {
    
    func load(request: MyCars.Load.Request)
    
    func getCarlist(request: MyCars.VehicleList.Request)
}

protocol MyCarsDataStore {
    
    //var name: String { get set }
}

final class MyCarsInteractor: MyCarsBusinessLogic, MyCarsDataStore {
    
    var presenter: MyCarsPresentationLogic?
    lazy var worker: MyCarsWorkingLogic = MyCarsWorker()
    //var name: String = ""
  
    
    // MARK: Business Logic
  
    func load(request: MyCars.Load.Request) {
        let response = MyCars.Load.Response()
        presenter?.presentLoad(response: response)
    }
    
    func getCarlist(request: MyCars.VehicleList.Request) {
        let token = SessionManager.shared.accessToken ?? ""
        self.worker.getCarList(token: token) { [weak self] data in
            guard let self = self else { return }
            
            if let data = data {
                let response = MyCars.VehicleList.Response(data: data.data)
                presenter?.presentGetCarlist(response: response)
            }
        }
    }
}
