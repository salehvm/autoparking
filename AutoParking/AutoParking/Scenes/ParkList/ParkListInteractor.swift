//
//  ParkListInteractor.swift
//  AutoParking
//
//  Created by Saleh Majidov on 25/06/2024.
//

import UIKit

protocol ParkListBusinessLogic {
    
    func load(request: ParkList.Load.Request)
    
    func getParkList(request: ParkList.ParkList.Request)
}

protocol ParkListDataStore {
    
    //var name: String { get set }
}

final class ParkListInteractor: ParkListBusinessLogic, ParkListDataStore {
    
    var presenter: ParkListPresentationLogic?
    lazy var worker: ParkListWorkingLogic = ParkListWorker()
    //var name: String = ""
  
    var locationManager = LocationManager.shared
    
    
    init() {
        self.locationManager.delegates.add(delegate: self)
    }
    
    deinit {
        self.locationManager.delegates.remove(delegate: self)
    }
    
    // MARK: Business Logic
  
    func load(request: ParkList.Load.Request) {
        let response = ParkList.Load.Response()
        presenter?.presentLoad(response: response)
    }
    
    func getParkList(request: ParkList.ParkList.Request) {
        
        let token = SessionManager.shared.accessToken ?? ""
        
        self.worker.getParkList(token: token) { [weak self] data, message in
            guard let self = self else { return }
            
            if let data = data {
                
                self.locationManager.parks = data
                
                let response = ParkList.ParkList.Response(data: data)
                self.presenter?.presentGetParkList(response: response)
            }
        }
    }
    
    func getParkList() {
        var parks = LocationManager.shared.parks
        
        let response = ParkList.ParkList.Response(data: parks ?? [])
        self.presenter?.presentGetParkList(response: response)
    }
}

extension ParkListInteractor: LocationManagerDelegate {
    func fetchParksCompletion(status: Bool) {
        if status {
            self.getParkList()
        }
    }
    
    
}
