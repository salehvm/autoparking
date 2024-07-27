//
//  SignInViewController.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

protocol SignInDisplayLogic: AnyObject {
    func displayLoad(viewModel: SignIn.Load.ViewModel)
    func displaySign(viewModel: SignIn.Sign.ViewModel)
}

final class SignInViewController: UIViewController {
    
    var mainView: SignInView?
    var interactor: SignInBusinessLogic?
    var router: (SignInRoutingLogic & SignInDataPassing)?
    var selectedOperator: OperatorValue?
    var code: String?
    
    // MARK: - Lifecycle Methods

    override func loadView() {
        super.loadView()
        self.view = mainView
        mainView?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showBackButton = false
        
        self.hideKeyboardWhenTappedAround()
        self.load()
    }
    
    // MARK: - Public Methods
  
    func load() {
        let request = SignIn.Load.Request()
        interactor?.load(request: request)
    }
    
    func sign(operatorValue: String, number: String, ts: Int) {
        let request = SignIn.Sign.Request(operatorValue: operatorValue, number: number, ts: ts)
        interactor?.sign(request: request)
    }
    
    private func getTimestamp() -> Int {
        return Int(Date().timeIntervalSince1970)
    }
}

// MARK: - Display Logic

extension SignInViewController: SignInDisplayLogic {
    
    func displayLoad(viewModel: SignIn.Load.ViewModel) {
        // nameTextField.text = viewModel.name
    }
    
    func displaySign(viewModel: SignIn.Sign.ViewModel) {
        self.router?.routeToVerify()
    }
}

// MARK: - View Delegate

extension SignInViewController: SignInViewDelegate {
    
    func callPrefixBottom() {
        let selectView = PrefixBottomSheet { [weak self] code, operatorValue in
            self?.mainView?.prefixLabel.text = code
            self?.selectedOperator = operatorValue
            self?.code = code
        }
        self.showBottomUp(selectView, sizes: [.fixed(300)])
    }
    
    func didTapGetVerificationCode(number: String) {
        let timestamp = getTimestamp()
        guard let operatorValue = self.selectedOperator else { return }
        self.sign(operatorValue: operatorValue.rawValue, number: "\(code ?? "")\(number)", ts: timestamp)
    }
}

