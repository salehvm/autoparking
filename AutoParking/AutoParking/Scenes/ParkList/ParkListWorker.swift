//
//  ParkListWorker.swift
//  AutoParking
//
//  Created by Saleh Majidov on 25/06/2024.
//

import UIKit
import AutoParkingNetwork

protocol ParkListWorkingLogic {
    func getParkList(token: String, completion: @escaping ([Park]?, String?) -> Void)
}

final class ParkListWorker: ParkListWorkingLogic {

    // MARK: - Private Properties
    
    private let service: ServiceProtocol = App.service

    
    let locationManager = LocationManager.shared
    
    // MARK: - Working Logic
    
    func getParkList(token: String, completion: @escaping ([Park]?, String?) -> Void) {
        
        let location = locationManager.location
        
        guard let location = location else { return }
        
        
        service.park.getParkList(token: token, location: location) { result in
            switch result {
            case .success(let response):
                
                print("Success: \(response)")
                completion(response.data, nil)
            case .failure(let error):
              
                print("Error: \(error.localizedDescription)")
                completion(nil, error.localizedDescription)
            case .successNoContent:
                break
            case .wrong(_):
                break
            }
        }
    }
}
