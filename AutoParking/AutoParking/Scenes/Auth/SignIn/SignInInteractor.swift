//
//  SignInInteractor.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

protocol SignInBusinessLogic {
    
    func load(request: SignIn.Load.Request)
    
    func sign(request: SignIn.Sign.Request)
}

protocol SignInDataStore {
    
    var expirationTime: Int? { get set }
    
    var phoneNumber: String? { get set }
    
    var hash: String? { get set }
}

final class SignInInteractor: SignInBusinessLogic, SignInDataStore {
    
    var presenter: SignInPresentationLogic?
    lazy var worker: SignInWorkingLogic = SignInWorker()
    
    var phoneNumber: String?
    var hash: String?
    var expirationTime: Int?
  
    
    // MARK: Business Logic
  
    func load(request: SignIn.Load.Request) {
        let response = SignIn.Load.Response()
        presenter?.presentLoad(response: response)
    }
    
    func sign(request: SignIn.Sign.Request) {
        self.worker.sign(operatorValue: request.operatorValue, number: request.number) { [weak self] data in
            guard let self = self else { return }
            if let data = data {
                let response = SignIn.Sign.Response(expirationTime: data.data?.expiration_time ?? 0)
                self.hash = data.data?.hash
                self.presenter?.presentSign(response: response)
            }
            
        }
        
    }
}
