//
//  ProfileViewController.swift
//  AutoParking
//
//  Created by Saleh Majidov on 25/06/2024.
//

import UIKit
import AutoParkingNetwork

protocol ProfileDisplayLogic: AnyObject {
    
    func displayLoad(viewModel: Profile.Load.ViewModel)
    
    func displayLogout(viewModel: Profile.Logout.ViewModel)
    
    func displayPaymentList(viewModel: Profile.PaymentCardList.ViewModel)
}

final class ProfileViewController: UIViewController {
    
    var mainView: ProfileView?
    var interactor: ProfileBusinessLogic?
    var router: (ProfileRoutingLogic & ProfileDataPassing)?
    
    private var items: [PaymentMethod] = [] {
        didSet {
            self.mainView?.collectionView.reloadData()
        }
    }
  
    var session = SessionManager.shared
    
    // MARK: - Lifecycle Methods

    override func loadView() {
        super.loadView()
        
        self.view = mainView
        mainView?.delegate = self
        
        self.mainView?.collectionView.dataSource = self
        self.mainView?.collectionView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.load()
    }
  
    
    // MARK: - Public Methods
  
    func load() {
        let request = Profile.Load.Request()
        interactor?.load(request: request)
    }
    
    func logoutApi() {
        let request = Profile.Logout.Request()
        interactor?.logout(request: request)
    }
    
    func paymentCardList() {
        let request = Profile.PaymentCardList.Request()
        interactor?.getCardList(request: request)
    }
}

// MARK: - Display Logic

extension ProfileViewController: ProfileDisplayLogic {

    func displayLogout(viewModel: Profile.Logout.ViewModel) {
        if viewModel.check == true {
            session.logout()
            App.router.signIn()
        } else {
            print("error")
        }
    }
    
    func displayPaymentList(viewModel: Profile.PaymentCardList.ViewModel) {
        self.items = viewModel.data
    }
    
    func displayLoad(viewModel: Profile.Load.ViewModel) {
        self.paymentCardList()
    }
}

// MARK: - View Delegate

extension ProfileViewController: ProfileViewDelegate {
    
    func logout() {
        self.logoutApi()
    }
    
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PaymentCardCell.reuseIdentifier, for: indexPath) as! PaymentCardCell
        let item = self.items[indexPath.row]
        
        if item.default == 1 {
            cell.bodyView.backgroundColor = .systemRed
            cell.bodyView.layer.opacity = 0.6
        }
        
        let maskedTitle = "**" + item.title.suffix(4)
        cell.title.text = maskedTitle

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
    
}
