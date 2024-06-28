//
//  ProfileWorker.swift
//  AutoParking
//
//  Created by Saleh Majidov on 25/06/2024.
//

import UIKit
import AutoParkingNetwork

protocol ProfileWorkingLogic {
    
    func logout(token: String, completion: @escaping (NoResponse?, Bool?) -> Void)
    
    func getCards(token: String, completion: @escaping ([PaymentMethod]?) -> Void)
}

final class ProfileWorker: ProfileWorkingLogic {

    // MARK: - Private Properties
    
    private let service: ServiceProtocol = App.service

    
    // MARK: - Working Logic
    
    func logout(token: String, completion: @escaping (NoResponse?, Bool?) -> Void) {
        
        service.auth.logout(token: token) { result in
            switch result {
            case .success(let response):
                
                print("Success: \(response)")
                completion(response, true)
            case .failure(let error):
              
                print("Error: \(error.localizedDescription)")
                completion(nil, false)
            case .successNoContent:
                break
            case .wrong(_):
                completion(nil, false)
            }
        }
    }
    
    func getCards(token: String, completion: @escaping ([PaymentMethod]?) -> Void) {
        
        service.auth.getPaymentCards(token: token) { result in
            switch result {
            case .success(let response):
                
                print("Success: \(response)")
                completion(response.data)
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
