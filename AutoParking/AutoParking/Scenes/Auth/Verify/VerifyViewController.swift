//
//  VerifyViewController.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

protocol VerifyDisplayLogic: AnyObject {
    
    func displayLoad(viewModel: Verify.Load.ViewModel)
    
    func displayCheckOTP(viewModel: Verify.CheckOTP.ViewModel)
}

final class VerifyViewController: UIViewController {
    
    var mainView: VerifyView?
    var interactor: VerifyBusinessLogic?
    var router: (VerifyRoutingLogic & VerifyDataPassing)?
  
    // MARK: - Lifecycle Methods

    override func loadView() {
        super.loadView()
        
        self.view = mainView
        mainView?.delegate = self
        
        self.title = "Verify"
        
        self.showBackButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.load()
    }
    
    // MARK: - Public Methods
  
    func load() {
        let request = Verify.Load.Request()
        interactor?.load(request: request)
    }
    
    func checkOTP(otp: String) {
        let request = Verify.CheckOTP.Request(code: otp)
        interactor?.verify(request: request)
    }
}

// MARK: - Display Logic

extension VerifyViewController: VerifyDisplayLogic {
    
    func displayCheckOTP(viewModel: Verify.CheckOTP.ViewModel) {
        
        if viewModel.success {
            self.router?.routeToAddFirstCar()
        } else {
            if let message = viewModel.errorMessage {
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                
                self.showBottomUp(alert)
            }
        }
    }
    
    func displayLoad(viewModel: Verify.Load.ViewModel) {
        //nameTextField.text = viewModel.name
    }
}

// MARK: - View Delegate

extension VerifyViewController: VerifyViewDelegate {
    
    func didTapVerifyOTP(otp: String) {
        self.checkOTP(otp: otp)
    }
}
