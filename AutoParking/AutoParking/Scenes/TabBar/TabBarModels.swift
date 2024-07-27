//
//  TabBarModels.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

enum TabBar {
    // MARK: Use cases
    
    enum Something {
        struct Request { }
        
        struct Response { }
        
        struct ViewModel { }
    }
}

//MARK: TabbarModels

enum TabBarModels {
    case activeParking
    case cars
    case profile
}

extension TabBarModels {
    
    var tabbarItemTitle: String? {
        switch self {
        case .activeParking:
            return "Aktiv"
        case .cars:
            return "Avtomobillər"
        case .profile:
            return "Profil"
        }
    }
    
    var tabbarItemImage: UIImage? {
        switch self {
        case .activeParking:
            return UIImage(named: "tabbar_time_icon")
        case .cars:
            return UIImage(named: "tabbar_car_icon")
        case .profile:
            return UIImage(named: "tabbar_user_icon")
        }
    }
}
