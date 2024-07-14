//
//  SignInWorker.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit
import AutoParkingNetwork

protocol SignInWorkingLogic {
    
    func sign(operatorValue: String, number: String, completion: @escaping (Step1Response?) -> Void)
}

final class SignInWorker: SignInWorkingLogic {
    
    // MARK: - Private Properties
    
    private let service: ServiceProtocol = App.service

    // MARK: - Working Logic
    
    func sign(operatorValue: String, number: String, completion: @escaping (Step1Response?) -> Void) {
        service.auth.step1(operatorValue: operatorValue, number: number) { result in
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
                break
            }
        }
    }
}
