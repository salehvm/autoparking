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
    case parks
    case programs
    case cars
    case profile
}

extension TabBarModels {
    ///title for tabbar item
    var tabbarItemTitle: String? {
        switch self {
        case .activeParking:
            return "Booked"
        case .parks:
            return "Parks"
        case .programs:
            return nil
        case .cars:
            return "Cars"
        case .profile:
            return "Profile"
        }
    }
    ///icon for tabbar item
    var tabbarItemImage: UIImage? {
        switch self {
        case .activeParking:
            return UIImage(systemName: "bookmark.fill")
        case .parks:
            return UIImage(systemName: "list.bullet")
        case .programs:
            return nil
        case .cars:
            return UIImage(systemName: "car.2")
        case .profile:
            return UIImage(systemName: "person.circle.fill")
        }
    }
}
