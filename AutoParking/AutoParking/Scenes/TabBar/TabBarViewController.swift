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
    
    private lazy var tabbarView : AppTabBar = {
        let view = AppTabBar()
        return view
    }()
    

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
//        self.tabBar.addSubview(self.menuButton)
    }
    
    private func addConstraints() {
//        self.menuButton.snp.updateConstraints { make in
//            make.width.height.equalTo(58)
//            make.bottom.equalToSuperview().offset(-50)
//            make.centerX.equalToSuperview()
//        }
    }


    private func addControllers() {
        let activeParkingVC = ActiveParkingViewController()
        let activeParkingView = MainNavigation(rootViewController: ActiveParkingConfigurator.configure(activeParkingVC))
        activeParkingView.tabBarItem = UITabBarItem()
        activeParkingView.tabBarItem.title = TabBarModels.activeParking.tabbarItemTitle
        activeParkingView.tabBarItem.image = TabBarModels.activeParking.tabbarItemImage
        
        let parkListVC = ParkListViewController()
        let parkListView = MainNavigation(rootViewController: ParkListConfigurator.configure(parkListVC))
        parkListView.tabBarItem = UITabBarItem()
        parkListView.tabBarItem.title = TabBarModels.parks.tabbarItemTitle
        parkListView.tabBarItem.image = TabBarModels.parks.tabbarItemImage
        
        let myCarsVC = MyCarsViewController()
        let myCarsView = MainNavigation(rootViewController: MyCarsConfigurator.configure(myCarsVC))
        myCarsView.tabBarItem = UITabBarItem()
        myCarsView.tabBarItem.title = TabBarModels.cars.tabbarItemTitle
        myCarsView.tabBarItem.image = TabBarModels.cars.tabbarItemImage
        
        let accountVC = ProfileViewController()
        let accountView = MainNavigation(rootViewController: ProfileConfigurator.configure(accountVC))
        accountView.tabBarItem = UITabBarItem()
        accountView.tabBarItem.title = TabBarModels.profile.tabbarItemTitle
        accountView.tabBarItem.image = TabBarModels.profile.tabbarItemImage
  
        let dummyVC = UIViewController()
        let dummyView = MainNavigation(rootViewController: dummyVC)
        
        let controllers = [activeParkingView, parkListView, dummyView, myCarsView, accountView]
        self.viewControllers = controllers
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
    }
    
    private func setupCustomTabBar() {
        self.setValue(tabbarView, forKey: "tabBar")
    }
    
    func doSomething() {
//        let request = TabBar.Something.Request()
//        interactor?.doSomething(request: request)
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
