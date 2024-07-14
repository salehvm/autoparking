//
//  VerifyWorker.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit
import AutoParkingNetwork

protocol VerifyWorkingLogic {
    
    func verifyOTP(otp: String, hash: String, completion: @escaping (Step2Response?, String?) -> Void)
}

final class VerifyWorker: VerifyWorkingLogic {

    // MARK: - Private Properties
    
    private let service: ServiceProtocol = App.service

    // MARK: - Working Logic
    
    func verifyOTP(otp: String, hash: String, completion: @escaping (Step2Response?, String?) -> Void) {
        
        let ts = Int(Date().timeIntervalSince1970)
        
        let request = Step2Request(template: "4",
                                   source: "app",
                                   type: "user",
                                   lang: "az",
                                   version: "20",
                                   vs: "20",
                                   device: "iOS",
                                   ts: ts,
                                   dataCode: otp,
                                   dataHash: hash,
                                   dataOptions: "%5B%5D")
        
        service.auth.step2(request: request) { result in
            switch result {
            case .success(let response):
                
                print("Success: \(response)")
                completion(response, nil)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(nil, nil)
            case .successNoContent:
                break
            case .wrong(let response):
                let message = response.message
                completion(nil, message)
            }
        }
    }
    
}
