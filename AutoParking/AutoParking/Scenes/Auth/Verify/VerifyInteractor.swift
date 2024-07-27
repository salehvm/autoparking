//
//  VerifyInteractor.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

protocol VerifyBusinessLogic {
    
    func load(request: Verify.Load.Request)
    
    func verify(request: Verify.CheckOTP.Request)
}

protocol VerifyDataStore {
    
    var hash: String? { get set }
    
    var phoneNumber: String? { get set }
}

final class VerifyInteractor: VerifyBusinessLogic, VerifyDataStore {
    
    var presenter: VerifyPresentationLogic?
    lazy var worker: VerifyWorkingLogic = VerifyWorker()
    
    var hash: String?
    
    var phoneNumber: String?
  
    // MARK: Business Logic
  
    func load(request: Verify.Load.Request) {
        let response = Verify.Load.Response(phoneNumber: self.phoneNumber ?? "")
        presenter?.presentLoad(response: response)
    }
    
    func verify(request: Verify.CheckOTP.Request) {
        
        self.worker.verifyOTP(otp: request.code, hash: self.hash ?? "") { [weak self] (response, message) in
            guard let self = self else { return }
            
            var success = false
            
            if let response = response {
                SessionManager.shared.accessToken = response.data?.token
                SessionManager.shared.hasLogin = true
                SessionManager.shared.user = response.data?.data
            
                success = true
            }
            
            let response = Verify.CheckOTP.Response(success: success, message: message, status: response?.status)
            self.presenter?.presentCheckOTP(response: response)
        }
    }
}
