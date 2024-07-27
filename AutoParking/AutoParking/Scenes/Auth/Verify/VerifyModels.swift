//
//  VerifyModels.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

enum Verify {
    
    // MARK: Use cases
  
    enum Load {
        
        struct Request {
            
        }
        
        struct Response {
            let phoneNumber: String
        }
        
        struct ViewModel {
            let phoneNumber: String
        }
    }
    
    enum CheckOTP {
        
        struct Request {
            let code: String
        }
        
        struct Response {
            let success: Bool
            let message: String?
            let status: String?
        }
        
        struct ViewModel {
            let success: Bool
            let errorMessage: String?
            let status: String?
        }
    }
}
