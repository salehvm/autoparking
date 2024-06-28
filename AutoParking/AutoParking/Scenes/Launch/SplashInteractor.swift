//
//  SplashInteractor.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

protocol SplashBusinessLogic {
    
    func load(request: Splash.Load.Request)
}

protocol SplashDataStore {
    
    //var name: String { get set }
}

final class SplashInteractor: SplashBusinessLogic, SplashDataStore {
    
    var presenter: SplashPresentationLogic?
    lazy var worker: SplashWorkingLogic = SplashWorker()
    //var name: String = ""
  
    
    // MARK: Business Logic
  
    func load(request: Splash.Load.Request) {
        let response = Splash.Load.Response()
        presenter?.presentLoad(response: response)
    }
}
