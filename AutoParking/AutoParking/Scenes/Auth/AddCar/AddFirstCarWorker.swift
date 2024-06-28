//
//  AddFirstCarWorker.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit
import AutoParkingNetwork

protocol AddFirstCarWorkingLogic {
    func getCarList(token: String, completion: @escaping (VehicleResponse?) -> Void)
}

final class AddFirstCarWorker: AddFirstCarWorkingLogic {

    // MARK: - Private Properties
    
    private let service: ServiceProtocol = App.service

    
    // MARK: - Working Logic
    
    func getCarList(token: String, completion: @escaping (VehicleResponse?) -> Void) {
        
        service.park.getCarList(token: token) { result in
            switch result {
            case .success(let response):
                
                print("Success: \(response)")
                completion(response)
            case .failure(let error):
              
                print("Error: \(error.localizedDescription)")
                completion(nil)
            case .successNoContent:
                break
            case .wrong(_):
                completion(nil)
            }
        }
    }
}
