//
//  ProfileModels.swift
//  AutoParking
//
//  Created by Saleh Majidov on 25/06/2024.
//

import UIKit
import AutoParkingNetwork

enum Profile {
    
    // MARK: Use cases
  
    enum Load {
        
        struct Request {
        }
        
        struct Response {
        }
        
        struct ViewModel {
        }
    }
    
    enum Logout {
        
        struct Request {
        }
        
        struct Response {
            let check: Bool?
        }
        
        struct ViewModel {
            let check: Bool?
        }
    }
    
    enum PaymentCardList {
        
        struct Request {
        }
        
        struct Response {
            let data: [PaymentMethod]
        }
        
        struct ViewModel {
            let data: [PaymentMethod]
        }
    }
}
