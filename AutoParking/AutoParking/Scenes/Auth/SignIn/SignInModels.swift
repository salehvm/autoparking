//
//  SignInModels.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

enum SignIn {
    
    // MARK: Use cases
  
    enum Load {
        
        struct Request {
        }
        
        struct Response {
        }
        
        struct ViewModel {
        }
    }
    
    enum Sign {
        
        struct Request {
            let operatorValue: String
            let number: String
            let ts: Int
        }
        
        struct Response {
            let expirationTime: Int
        }
        
        struct ViewModel {
        }
        
    }
}
