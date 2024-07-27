//
//  OnboardingInteractor.swift
//  AutoParking
//
//  Created by Saleh Majidov on 27/07/2024.
//

import UIKit

protocol OnboardingBusinessLogic {
    
    func load(request: Onboarding.Load.Request)
}

protocol OnboardingDataStore {
    
    //var name: String { get set }
}

final class OnboardingInteractor: OnboardingBusinessLogic, OnboardingDataStore {
    
    var presenter: OnboardingPresentationLogic?
    lazy var worker: OnboardingWorkingLogic = OnboardingWorker()
    //var name: String = ""
  
    
    // MARK: Business Logic
  
    func load(request: Onboarding.Load.Request) {
        let response = Onboarding.Load.Response()
        presenter?.presentLoad(response: response)
    }
}
