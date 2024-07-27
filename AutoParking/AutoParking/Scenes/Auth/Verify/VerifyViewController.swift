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
//    func displayResendOTP(viewModel: Verify.ResendOTP.ViewModel)
}

final class VerifyViewController: UIViewController {
    
    var mainView: VerifyView = VerifyView()
    var interactor: VerifyBusinessLogic?
    var router: (VerifyRoutingLogic & VerifyDataPassing)?
  
    // MARK: - Lifecycle Methods

    override func loadView() {
        super.loadView()
        self.view = mainView
        mainView.delegate = self
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
    
//    func resendOTP() {
//        let request = Verify.ResendOTP.Request()
//        interactor?.resend(request: request)
//    }
}

// MARK: - Display Logic

extension VerifyViewController: VerifyDisplayLogic {
    
    func displayCheckOTP(viewModel: Verify.CheckOTP.ViewModel) {
        
        if viewModel.status == "error" {
            mainView.updateMessage("Təsdiq kodu səhvdir", isError: true)
            self.mainView.verifyOTPButton.isEnabled = false
            self.mainView.verifyOTPButton.backgroundColor = UIColor(hex: "ECEEF4")
            self.mainView.verifyOTPButton.setTitleColor(UIColor(hex: "000830"), for: .normal)
        } else {
            self.router?.routeToAddFirstCar()
        }
        
    }
    
    func displayLoad(viewModel: Verify.Load.ViewModel) {
        self.mainView.subTitle.text = "\(viewModel.phoneNumber) nömrəsinə göndərdiyimiz doğrulama kodunu daxil edin."
    }
    
//    func displayResendOTP(viewModel: Verify.ResendOTP.ViewModel) {
//        if viewModel.success {
//            mainView.updateMessage("OTP yenidən göndərildi", isError: false)
//        } else {
//            if let message = viewModel.errorMessage {
//                mainView.updateMessage(message, isError: true)
//            }
//        }
//    }
}

// MARK: - View Delegate

extension VerifyViewController: VerifyViewDelegate {
    
    func didTapVerifyOTP(otp: String) {
        self.checkOTP(otp: otp)
    }
    
    func didTapResendOTP() {
//        self.resendOTP()
    }
}
