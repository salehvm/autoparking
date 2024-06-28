//
//  ProfileInteractor.swift
//  AutoParking
//
//  Created by Saleh Majidov on 25/06/2024.
//

import UIKit

protocol ProfileBusinessLogic {
    
    func load(request: Profile.Load.Request)
    
    func logout(request: Profile.Logout.Request)
    
    func getCardList(request: Profile.PaymentCardList.Request)
}

protocol ProfileDataStore {
    
    //var name: String { get set }
}

final class ProfileInteractor: ProfileBusinessLogic, ProfileDataStore {
   
    var presenter: ProfilePresentationLogic?
    lazy var worker: ProfileWorkingLogic = ProfileWorker()
    //var name: String = ""
  
    var session = SessionManager.shared
    
    // MARK: Business Logic
  
    func load(request: Profile.Load.Request) {
        let response = Profile.Load.Response()
        presenter?.presentLoad(response: response)
    }
    
    func logout(request: Profile.Logout.Request) {
        
        self.worker.logout(token: session.accessToken ?? "") { [weak self] data, check in
            
            guard let self = self else { return }
            let response = Profile.Logout.Response(check: check)
            self.presenter?.presentLogout(response: response)
        }
    }
    
    func getCardList(request: Profile.PaymentCardList.Request) {
        
        self.worker.getCards(token: session.accessToken ?? "") { [weak self] data in
            
            guard let self = self else { return }
            let response = Profile.PaymentCardList.Response(data: data ?? [])
            self.presenter?.presentGetPaymentList(response: response)
        }
    }
}
