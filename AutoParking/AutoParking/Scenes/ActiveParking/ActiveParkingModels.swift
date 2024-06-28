//
//  ActiveParkingModels.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit
import AutoParkingNetwork

enum ActiveParking {
    
    // MARK: Use cases
  
    enum Load {
        
        struct Request {
        }
        
        struct Response {
        }
        
        struct ViewModel {
        }
    }
    
    enum BookedList {
        
        struct Request {
        }
        
        struct Response {
            let data: [Booking]
        }
        
        struct ViewModel {
            let data: [Booking]
        }
    }
}
