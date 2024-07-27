//
//  PermissionAuthInteractor.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/07/2024.
//

import UIKit

protocol PermissionAuthBusinessLogic {
    
    func load(request: PermissionAuth.Load.Request)
}

protocol PermissionAuthDataStore {
    
    //var name: String { get set }
}

final class PermissionAuthInteractor: PermissionAuthBusinessLogic, PermissionAuthDataStore {
    
    var presenter: PermissionAuthPresentationLogic?
    lazy var worker: PermissionAuthWorkingLogic = PermissionAuthWorker()
    //var name: String = ""
  
    
    // MARK: Business Logic
  
    func load(request: PermissionAuth.Load.Request) {
        let response = PermissionAuth.Load.Response()
        presenter?.presentLoad(response: response)
    }
}
