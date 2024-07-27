//
//  TabBarViewController.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit
import AutoParkingUIKit

protocol TabBarDisplayLogic: AnyObject {
    func displaySomething(viewModel: TabBar.Something.ViewModel)
}


final class TabBarController: UITabBarController, ThemeableViewController {
    var interactor: TabBarBusinessLogic?
    var router: (NSObjectProtocol & TabBarRoutingLogic & TabBarDataPassing)?

    var theme: ThemeProvider = App.theme
    
    private lazy var tabbarView: AppTabBar = {
        let view = AppTabBar()
        return view
    }()
    
//    private lazy var centerButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "centerButtonIcon"), for: .normal)
//        button.addTarget(self, action: #selector(centerButtonTapped), for: .touchUpInside)
//        button.layer.shadowColor = UIColor.black.cgColor
//        button.layer.shadowOpacity = 0.2
//        button.layer.shadowOffset = CGSize(width: 0, height: 4)
//        button.layer.shadowRadius = 6
//        return button
//    }()

    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCustomTabBar()
        self.setupUI()
        self.addSubviews()
        self.addConstraints()
        self.addControllers()
    }
    
    private func addSubviews() {
//        self.tabBar.addSubview(self.centerButton)
    }
    
    private func addConstraints() {
//        self.centerButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            self.centerButton.centerXAnchor.constraint(equalTo: self.tabBar.centerXAnchor),
//            self.centerButton.centerYAnchor.constraint(equalTo: self.tabBar.topAnchor, constant: 10),
//            self.centerButton.widthAnchor.constraint(equalToConstant: 58),
//            self.centerButton.heightAnchor.constraint(equalToConstant: 58)
//        ])
    }

    private func addControllers() {
        let activeParkingVC = ActiveParkingViewController()
        let activeParkingView = MainNavigation(rootViewController: ActiveParkingConfigurator.configure(activeParkingVC))
        activeParkingView.tabBarItem = UITabBarItem()
        activeParkingView.tabBarItem.title = TabBarModels.activeParking.tabbarItemTitle
        activeParkingView.tabBarItem.image = TabBarModels.activeParking.tabbarItemImage
        activeParkingView.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let myCarsVC = MyCarsViewController()
        let myCarsView = MainNavigation(rootViewController: MyCarsConfigurator.configure(myCarsVC))
        myCarsView.tabBarItem = UITabBarItem()
        myCarsView.tabBarItem.title = TabBarModels.cars.tabbarItemTitle
        myCarsView.tabBarItem.image = TabBarModels.cars.tabbarItemImage
        myCarsView.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let accountVC = ProfileViewController()
        let accountView = MainNavigation(rootViewController: ProfileConfigurator.configure(accountVC))
        accountView.tabBarItem = UITabBarItem()
        accountView.tabBarItem.title = TabBarModels.profile.tabbarItemTitle
        accountView.tabBarItem.image = TabBarModels.profile.tabbarItemImage
        accountView.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        let controllers = [activeParkingView, myCarsView, accountView]
        self.viewControllers = controllers
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
    }
    
    private func setupCustomTabBar() {
        self.setValue(tabbarView, forKey: "tabBar")
    }
    
    @objc private func centerButtonTapped() {
        // Handle center button action
    }
}

//MARK: UITabBarControllerDelegate

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return tabBarController.selectedIndex != 2
    }
}

extension TabBarController: TabBarDisplayLogic {
    func displaySomething(viewModel: TabBar.Something.ViewModel) {
    }
}
