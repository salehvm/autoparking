//
//  ProfileViewController.swift
//  AutoParking
//
//  Created by Saleh Majidov on 25/06/2024.
//

import UIKit
import AutoParkingNetwork
import RealmSwift
import CoreLocation

protocol ProfileDisplayLogic: AnyObject {
    func displayLoad(viewModel: Profile.Load.ViewModel)
    func displayLogout(viewModel: Profile.Logout.ViewModel)
    func displayPaymentList(viewModel: Profile.PaymentCardList.ViewModel)
}

final class ProfileViewController: UIViewController {
    
    var mainView: ProfileView?
    var interactor: ProfileBusinessLogic?
    var router: (ProfileRoutingLogic & ProfileDataPassing)?
    var session = SessionManager.shared
    var locationManager = CLLocationManager()
    
    // MARK: - Lifecycle Methods
    
    override func loadView() {
        super.loadView()
        mainView = ProfileView()
        mainView?.delegate = self
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProfile()
        checkLocationPermission()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkLocationPermission()
    }
    
    // MARK: - Public Methods
    
    private func loadProfile() {
        let request = Profile.Load.Request()
        interactor?.load(request: request)
    }
    
    private func logoutApi() {
        let request = Profile.Logout.Request()
        interactor?.logout(request: request)
    }
    
    private func paymentCardList() {
        let request = Profile.PaymentCardList.Request()
        interactor?.getCardList(request: request)
    }
    
    private func checkLocationPermission() {
        let authorizationStatus = locationManager.authorizationStatus
        if authorizationStatus == .notDetermined || authorizationStatus == .denied {
            mainView?.locPermissionView.isHidden = false
            mainView?.bankCardView.isHidden = true
            mainView?.switchView.isHidden = true
            mainView?.logoutButton.isHidden = true
            mainView?.titleLabel.isHidden = true
        } else {
            mainView?.locPermissionView.isHidden = true
            mainView?.bankCardView.isHidden = false
            mainView?.switchView.isHidden = false
            mainView?.logoutButton.isHidden = false
            mainView?.titleLabel.isHidden = false
        }
    }
}

// MARK: - Display Logic

extension ProfileViewController: ProfileDisplayLogic {
    
    func displayLogout(viewModel: Profile.Logout.ViewModel) {
        if viewModel.check == true {
            session.logout()
            App.router.onboarding()
        } else {
            showError(message: "Logout failed. Please try again.")
        }
    }
    
    func displayPaymentList(viewModel: Profile.PaymentCardList.ViewModel) {
        if let defaultPaymentMethod = viewModel.data.first(where: { $0.default == 1 }) {
            let lastFourDigits = defaultPaymentMethod.title.suffix(4)
            mainView?.cardNumberLabel.text = "**\(lastFourDigits)"
        }
    }
    
    func displayLoad(viewModel: Profile.Load.ViewModel) {
        paymentCardList()
        let realm = try! Realm()
        if let autoNotification = realm.objects(AutoNotification.self).first {
            mainView?.switchBtn.isOn = autoNotification.isAutoCheck
        }
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - View Delegate

extension ProfileViewController: ProfileViewDelegate {
    
    func getLocation() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    func manageAutoSwcViewChange(_ isOn: Bool) {
        let realm = try! Realm()
        try! realm.write {
            if let autoNotification = realm.objects(AutoNotification.self).first {
                autoNotification.isAutoCheck = isOn
            } else {
                let newAutoNotification = AutoNotification()
                newAutoNotification.isAutoCheck = isOn
                realm.add(newAutoNotification)
            }
        }
    }
    
    func logout() {
        logoutApi()
    }
}
