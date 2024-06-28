//
//  ParkListModels.swift
//  AutoParking
//
//  Created by Saleh Majidov on 25/06/2024.
//

import UIKit
import AutoParkingNetwork

enum ParkList {
    
    // MARK: Use cases
  
    enum Load {
        
        struct Request {
        }
        
        struct Response {
        }
        
        struct ViewModel {
        }
    }
    
    enum ParkList {
        
        struct Request {
        }
        
        struct Response {
            let data: [Park]
        }
        
        struct ViewModel {
            let data: [Park]
        }
    }
}
