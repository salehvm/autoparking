//
//  SplashViewController.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

protocol SplashDisplayLogic: AnyObject {
    
    func displayLoad(viewModel: Splash.Load.ViewModel)
}

final class SplashViewController: UIViewController {
    
    var mainView: SplashView?
    var interactor: SplashBusinessLogic?
    var router: (SplashRoutingLogic & SplashDataPassing)?
  
    
    // MARK: - Lifecycle Methods

    override func loadView() {
        super.loadView()
        
        self.view = mainView
        mainView?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        App.router.checkStart()
        self.load()
    }
  
    
    // MARK: - Public Methods
  
    func load() {
        let request = Splash.Load.Request()
        interactor?.load(request: request)
    }
}

// MARK: - Display Logic

extension SplashViewController: SplashDisplayLogic {
    
    func displayLoad(viewModel: Splash.Load.ViewModel) {
        //nameTextField.text = viewModel.name
    }
}

// MARK: - View Delegate

extension SplashViewController: SplashViewDelegate {
    
}
