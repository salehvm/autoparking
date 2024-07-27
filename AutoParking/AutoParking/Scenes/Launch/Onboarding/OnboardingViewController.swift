//
//  OnboardingViewController.swift
//  AutoParking
//
//  Created by Saleh Majidov on 27/07/2024.
//

import UIKit

protocol OnboardingDisplayLogic: AnyObject {
    
    func displayLoad(viewModel: Onboarding.Load.ViewModel)
}

final class OnboardingViewController: UIViewController {
    
    var mainView: OnboardingView?
    var interactor: OnboardingBusinessLogic?
    var router: (OnboardingRoutingLogic & OnboardingDataPassing)?
  
    
    // MARK: - Lifecycle Methods

    override func loadView() {
        super.loadView()
        
        self.view = mainView
        mainView?.delegate = self
        
        self.showBackButton = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.load()
    }
  
    
    // MARK: - Public Methods
  
    func load() {
        let request = Onboarding.Load.Request()
        interactor?.load(request: request)
    }
}

// MARK: - Display Logic

extension OnboardingViewController: OnboardingDisplayLogic {
    
    func displayLoad(viewModel: Onboarding.Load.ViewModel) {
        //nameTextField.text = viewModel.name
    }
}

// MARK: - View Delegate

extension OnboardingViewController: OnboardingViewDelegate {
    
    func viewSignInClick() {
        self.router?.routeToSignIn()
    }
}
