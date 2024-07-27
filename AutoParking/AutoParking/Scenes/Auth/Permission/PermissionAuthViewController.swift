//
//  PermissionAuthViewController.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/07/2024.
//

import UIKit

protocol PermissionAuthDisplayLogic: AnyObject {
    
    func displayLoad(viewModel: PermissionAuth.Load.ViewModel)
}

final class PermissionAuthViewController: UIViewController {
    
    var mainView: PermissionAuthView?
    var interactor: PermissionAuthBusinessLogic?
    var router: (PermissionAuthRoutingLogic & PermissionAuthDataPassing)?
  
    
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
        let request = PermissionAuth.Load.Request()
        interactor?.load(request: request)
    }
}

// MARK: - Display Logic

extension PermissionAuthViewController: PermissionAuthDisplayLogic {
    
    func displayLoad(viewModel: PermissionAuth.Load.ViewModel) {
        //nameTextField.text = viewModel.name
    }
}

// MARK: - View Delegate

extension PermissionAuthViewController: PermissionAuthViewDelegate {
    
    func getLocation() {
        LocationManager.shared.requestPermissions()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            App.router.main()
        })
    }
    
    func cancelLocation() {
        App.router.main()
    }
    
}
